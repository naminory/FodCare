import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class HomeViewModel {
    var selectedDate: Date = .now

    func moveDay(by offset: Int) {
        selectedDate = Calendar.current.date(byAdding: .day, value: offset, to: selectedDate) ?? selectedDate
    }

    func goToToday() {
        selectedDate = .now
    }

    // 選択日の食事記録を取得
    func fetchMeals(modelContext: ModelContext) -> [MealRecord] {
        let start = DateHelper.startOfDay(selectedDate)
        let end = DateHelper.endOfDay(selectedDate)
        var descriptor = FetchDescriptor<MealRecord>(
            predicate: #Predicate { $0.date >= start && $0.date <= end },
            sortBy: [SortDescriptor(\.date)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    // 選択日の最新症状記録を取得
    func fetchLatestSymptom(modelContext: ModelContext) -> SymptomRecord? {
        let start = DateHelper.startOfDay(selectedDate)
        let end = DateHelper.endOfDay(selectedDate)
        var descriptor = FetchDescriptor<SymptomRecord>(
            predicate: #Predicate { $0.date >= start && $0.date <= end },
            sortBy: [SortDescriptor(\.time, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return (try? modelContext.fetch(descriptor))?.first
    }

    // 選択日のFODMAPサマリー（各カテゴリの最大レベル）
    func fodmapSummary(meals: [MealRecord]) -> [FODMAPCategory: Int] {
        var summary: [FODMAPCategory: Int] = [:]
        for category in FODMAPCategory.allCases {
            let maxLevel = meals.flatMap { $0.entries }
                .compactMap { $0.foodItem?.level(for: category).rawValue }
                .max() ?? 0
            summary[category] = maxLevel
        }
        return summary
    }
}
