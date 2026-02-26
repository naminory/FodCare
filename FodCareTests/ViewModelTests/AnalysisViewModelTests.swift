import Testing
import Foundation
import SwiftData
@testable import FodCare

@Suite("AnalysisViewModel テスト")
struct AnalysisViewModelTests {

    @MainActor
    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([FoodItem.self, MealRecord.self, MealFoodEntry.self, SymptomRecord.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }

    // MARK: - SymptomPeriod

    @Test("SymptomPeriodが正しい日数を返す")
    func symptomPeriodDays() {
        #expect(AnalysisViewModel.SymptomPeriod.week.days == 7)
        #expect(AnalysisViewModel.SymptomPeriod.month.days == 30)
    }

    @Test("SymptomPeriod rawValueが日本語")
    func symptomPeriodRawValue() {
        #expect(AnalysisViewModel.SymptomPeriod.week.rawValue == "7日間")
        #expect(AnalysisViewModel.SymptomPeriod.month.rawValue == "30日間")
    }

    @Test("SymptomPeriodが全ケース2つ")
    func symptomPeriodAllCases() {
        #expect(AnalysisViewModel.SymptomPeriod.allCases.count == 2)
    }

    // MARK: - 初期状態

    @Test("初期状態はweek")
    @MainActor
    func initialState() {
        let vm = AnalysisViewModel()
        #expect(vm.symptomPeriod == .week)
    }

    // MARK: - 週間FODMAPデータ

    @Test("データなしで週間FODMAPが7日x5カテゴリ=35件返る")
    @MainActor
    func weeklyFODMAPEmpty() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = AnalysisViewModel()
        let results = vm.fetchWeeklyFODMAP(modelContext: context)
        #expect(results.count == 35)
        #expect(results.allSatisfy { $0.maxLevel == 0 })
    }

    // MARK: - 症状トレンド

    @Test("weekモードで7日分の症状トレンドを返す")
    @MainActor
    func symptomTrendWeek() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = AnalysisViewModel()
        vm.symptomPeriod = .week
        let results = vm.fetchSymptomTrend(modelContext: context)
        #expect(results.count == 7)
        #expect(results.allSatisfy { $0.score == 0 })
    }

    @Test("monthモードで30日分の症状トレンドを返す")
    @MainActor
    func symptomTrendMonth() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = AnalysisViewModel()
        vm.symptomPeriod = .month
        let results = vm.fetchSymptomTrend(modelContext: context)
        #expect(results.count == 30)
    }

    @Test("症状レコードがある日はスコアが反映される")
    @MainActor
    func symptomTrendWithData() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = AnalysisViewModel()

        let record = SymptomRecord(
            date: .now,
            time: .now,
            bloating: 3,
            abdominalPain: 2,
            gas: 1
        )
        context.insert(record)
        try context.save()

        let results = vm.fetchSymptomTrend(modelContext: context)
        let todayEntry = results.last
        #expect(todayEntry?.score == 6)
    }

    // MARK: - 相関分析

    @Test("データ不足の場合nilを返す")
    @MainActor
    func correlationNoData() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = AnalysisViewModel()
        let result = vm.correlationText(modelContext: context)
        #expect(result == nil)
    }
}
