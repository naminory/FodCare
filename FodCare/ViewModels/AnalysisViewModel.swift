import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class AnalysisViewModel {
    var symptomPeriod: SymptomPeriod = .week

    enum SymptomPeriod: String, CaseIterable, Identifiable {
        case week = "7日間"
        case month = "30日間"
        var id: String { rawValue }
        var days: Int {
            switch self {
            case .week: 7
            case .month: 30
            }
        }
    }

    // 日別FODMAPデータ（過去7日分）
    struct DailyFODMAP: Identifiable {
        let id = UUID()
        let date: Date
        let category: FODMAPCategory
        let maxLevel: Int
    }

    // 日別症状データ
    struct DailySymptom: Identifiable {
        let id = UUID()
        let date: Date
        let score: Int
    }

    func fetchWeeklyFODMAP(modelContext: ModelContext) -> [DailyFODMAP] {
        var results: [DailyFODMAP] = []

        for dayOffset in 0..<7 {
            let date = DateHelper.daysAgo(6 - dayOffset)
            let start = DateHelper.startOfDay(date)
            let end = DateHelper.endOfDay(date)

            var descriptor = FetchDescriptor<MealRecord>(
                predicate: #Predicate { $0.date >= start && $0.date <= end }
            )
            let meals = (try? modelContext.fetch(descriptor)) ?? []

            for category in FODMAPCategory.allCases {
                let maxLevel = meals.flatMap { $0.entries }
                    .compactMap { $0.foodItem?.level(for: category).rawValue }
                    .max() ?? 0
                results.append(DailyFODMAP(date: date, category: category, maxLevel: maxLevel))
            }
        }
        return results
    }

    func fetchSymptomTrend(modelContext: ModelContext) -> [DailySymptom] {
        var results: [DailySymptom] = []

        for dayOffset in 0..<symptomPeriod.days {
            let date = DateHelper.daysAgo(symptomPeriod.days - 1 - dayOffset)
            let start = DateHelper.startOfDay(date)
            let end = DateHelper.endOfDay(date)

            var descriptor = FetchDescriptor<SymptomRecord>(
                predicate: #Predicate { $0.date >= start && $0.date <= end },
                sortBy: [SortDescriptor(\.time, order: .reverse)]
            )
            let records = (try? modelContext.fetch(descriptor)) ?? []

            // その日の最大スコア
            let maxScore = records.map { $0.overallScore }.max() ?? 0
            results.append(DailySymptom(date: date, score: maxScore))
        }
        return results
    }

    // 簡易相関分析
    func correlationText(modelContext: ModelContext) -> String? {
        var highFODMAPDays = 0
        var symptomAfterHighDays = 0
        var totalDays = 0

        for dayOffset in 1..<14 {
            let prevDate = DateHelper.daysAgo(dayOffset)
            let currDate = DateHelper.daysAgo(dayOffset - 1)

            // 前日の食事を取得
            let prevStart = DateHelper.startOfDay(prevDate)
            let prevEnd = DateHelper.endOfDay(prevDate)
            var mealDescriptor = FetchDescriptor<MealRecord>(
                predicate: #Predicate { $0.date >= prevStart && $0.date <= prevEnd }
            )
            let meals = (try? modelContext.fetch(mealDescriptor)) ?? []

            let hasHighFODMAP = meals.flatMap { $0.entries }
                .compactMap { $0.foodItem }
                .contains { $0.overallLevel >= 2 }

            // 当日の症状を取得
            let currStart = DateHelper.startOfDay(currDate)
            let currEnd = DateHelper.endOfDay(currDate)
            var symptomDescriptor = FetchDescriptor<SymptomRecord>(
                predicate: #Predicate { $0.date >= currStart && $0.date <= currEnd }
            )
            let symptoms = (try? modelContext.fetch(symptomDescriptor)) ?? []
            let maxScore = symptoms.map { $0.overallScore }.max() ?? 0

            if hasHighFODMAP {
                highFODMAPDays += 1
                if maxScore >= 5 {
                    symptomAfterHighDays += 1
                }
            }
            totalDays += 1
        }

        guard highFODMAPDays >= 2 else { return nil }

        let rate = Double(symptomAfterHighDays) / Double(highFODMAPDays) * 100
        if rate >= 50 {
            return "高FODMAPを摂取した翌日に症状スコアが高い傾向があります（\(Int(rate))%の確率）。"
        } else if highFODMAPDays > 0 {
            return "過去2週間で高FODMAP食品を\(highFODMAPDays)日摂取しました。"
        }
        return nil
    }
}
