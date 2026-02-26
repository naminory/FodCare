import Testing
import Foundation
import SwiftData
@testable import FodCare

@Suite("SymptomRecordViewModel テスト")
struct SymptomRecordViewModelTests {

    @MainActor
    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([FoodItem.self, MealRecord.self, MealFoodEntry.self, SymptomRecord.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }

    // MARK: - 初期状態

    @Test("初期状態が正しい")
    @MainActor
    func initialState() {
        let vm = SymptomRecordViewModel()
        #expect(vm.bloating == 0)
        #expect(vm.abdominalPain == 0)
        #expect(vm.gas == 0)
        #expect(vm.diarrhea == 0)
        #expect(vm.constipation == 0)
        #expect(vm.bristolScale == nil)
        #expect(vm.memo.isEmpty)
    }

    // MARK: - 総合スコア

    @Test("overallScoreが正しく計算される")
    @MainActor
    func overallScore() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 2
        vm.abdominalPain = 1
        vm.gas = 3
        vm.diarrhea = 0
        vm.constipation = 1
        #expect(vm.overallScore == 7)
    }

    @Test("すべて0のoverallScore")
    @MainActor
    func overallScoreZero() {
        let vm = SymptomRecordViewModel()
        #expect(vm.overallScore == 0)
    }

    @Test("最大overallScore")
    @MainActor
    func overallScoreMax() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 3
        vm.abdominalPain = 3
        vm.gas = 3
        vm.diarrhea = 3
        vm.constipation = 3
        #expect(vm.overallScore == 15)
    }

    // MARK: - 重症度ラベル

    @Test("severityLabel: 症状なし")
    @MainActor
    func severityLabelNone() {
        let vm = SymptomRecordViewModel()
        #expect(vm.severityLabel == "症状なし")
    }

    @Test("severityLabel: 軽度")
    @MainActor
    func severityLabelMild() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 2
        vm.abdominalPain = 1
        #expect(vm.severityLabel == "軽度")
    }

    @Test("severityLabel: 中度")
    @MainActor
    func severityLabelModerate() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 3
        vm.abdominalPain = 1
        vm.gas = 1
        #expect(vm.severityLabel == "中度")
    }

    @Test("severityLabel: 重度")
    @MainActor
    func severityLabelSevere() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 3
        vm.abdominalPain = 3
        vm.gas = 3
        vm.diarrhea = 1
        #expect(vm.severityLabel == "重度")
    }

    // MARK: - 値の取得・設定

    @Test("value(for:)が正しい値を返す")
    @MainActor
    func valueForType() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 2
        vm.gas = 3
        #expect(vm.value(for: .bloating) == 2)
        #expect(vm.value(for: .gas) == 3)
        #expect(vm.value(for: .diarrhea) == 0)
    }

    @Test("setValue(_:for:)が値を正しく設定する")
    @MainActor
    func setValueForType() {
        let vm = SymptomRecordViewModel()
        vm.setValue(2, for: .abdominalPain)
        vm.setValue(1, for: .constipation)
        #expect(vm.abdominalPain == 2)
        #expect(vm.constipation == 1)
    }

    @Test("全SymptomTypeに対してsetValue/valueが正しく動く")
    @MainActor
    func setAndGetAllTypes() {
        let vm = SymptomRecordViewModel()
        for (i, type) in SymptomType.allCases.enumerated() {
            vm.setValue(i, for: type)
        }
        for (i, type) in SymptomType.allCases.enumerated() {
            #expect(vm.value(for: type) == i)
        }
    }

    // MARK: - リセット

    @Test("リセットで初期状態に戻る")
    @MainActor
    func reset() {
        let vm = SymptomRecordViewModel()
        vm.bloating = 3
        vm.abdominalPain = 2
        vm.gas = 1
        vm.diarrhea = 2
        vm.constipation = 1
        vm.bristolScale = 4
        vm.memo = "テスト"

        vm.reset()

        #expect(vm.bloating == 0)
        #expect(vm.abdominalPain == 0)
        #expect(vm.gas == 0)
        #expect(vm.diarrhea == 0)
        #expect(vm.constipation == 0)
        #expect(vm.bristolScale == nil)
        #expect(vm.memo.isEmpty)
    }

    // MARK: - 保存

    @Test("保存でSymptomRecordが作成される")
    @MainActor
    func save() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = SymptomRecordViewModel()
        vm.bloating = 2
        vm.abdominalPain = 1
        vm.gas = 3
        vm.bristolScale = 5
        vm.memo = "テスト保存"

        vm.save(modelContext: context)

        let records = try context.fetch(FetchDescriptor<SymptomRecord>())
        #expect(records.count == 1)
        #expect(records.first?.bloating == 2)
        #expect(records.first?.abdominalPain == 1)
        #expect(records.first?.gas == 3)
        #expect(records.first?.bristolScale == 5)
        #expect(records.first?.memo == "テスト保存")
    }

    @Test("memoが空の場合nilで保存される")
    @MainActor
    func saveEmptyMemo() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = SymptomRecordViewModel()
        vm.memo = ""
        vm.save(modelContext: context)

        let records = try context.fetch(FetchDescriptor<SymptomRecord>())
        #expect(records.first?.memo == nil)
    }
}
