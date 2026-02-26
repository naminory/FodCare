import Testing
import Foundation
import SwiftData
@testable import FodCare

@Suite("MealRecordViewModel テスト")
struct MealRecordViewModelTests {

    @MainActor
    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([FoodItem.self, MealRecord.self, MealFoodEntry.self, SymptomRecord.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }

    @MainActor
    private func makeFoodItem(context: ModelContext, name: String = "テスト食品", overallLevel: Int = 0) -> FoodItem {
        let item = FoodItem(
            nameJA: name, nameEN: "Test", category: "野菜",
            overallLevel: overallLevel, fructanLevel: 0, gosLevel: 0,
            lactoseLevel: 0, fructoseLevel: 0, polyolLevel: 0
        )
        context.insert(item)
        return item
    }

    // MARK: - 初期状態

    @Test("初期状態が正しい")
    @MainActor
    func initialState() {
        let vm = MealRecordViewModel()
        #expect(vm.selectedMealType == .breakfast)
        #expect(vm.selectedFoods.isEmpty)
        #expect(vm.memo.isEmpty)
        #expect(vm.searchText.isEmpty)
    }

    // MARK: - 食品追加

    @Test("食品を追加できる")
    @MainActor
    func addFood() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        let food = makeFoodItem(context: context)
        vm.addFood(food)
        #expect(vm.selectedFoods.count == 1)
        #expect(vm.selectedFoods.first?.food.nameJA == "テスト食品")
        #expect(vm.selectedFoods.first?.portion == .medium)
    }

    @Test("カスタムポーションで追加できる")
    @MainActor
    func addFoodWithPortion() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        let food = makeFoodItem(context: context)
        vm.addFood(food, portion: .large)
        #expect(vm.selectedFoods.first?.portion == .large)
    }

    @Test("同じ食品を二重追加できない")
    @MainActor
    func addDuplicateFood() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        let food = makeFoodItem(context: context)
        vm.addFood(food)
        vm.addFood(food)
        #expect(vm.selectedFoods.count == 1)
    }

    @Test("異なる食品を複数追加できる")
    @MainActor
    func addMultipleFoods() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        vm.addFood(makeFoodItem(context: context, name: "白米"))
        vm.addFood(makeFoodItem(context: context, name: "豆腐"))
        vm.addFood(makeFoodItem(context: context, name: "鶏肉"))
        #expect(vm.selectedFoods.count == 3)
    }

    // MARK: - 食品削除

    @Test("食品を削除できる")
    @MainActor
    func removeFood() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        vm.addFood(makeFoodItem(context: context, name: "白米"))
        vm.addFood(makeFoodItem(context: context, name: "豆腐"))
        vm.removeFood(at: IndexSet(integer: 0))
        #expect(vm.selectedFoods.count == 1)
        #expect(vm.selectedFoods.first?.food.nameJA == "豆腐")
    }

    // MARK: - ポーション変更

    @Test("ポーションを変更できる")
    @MainActor
    func updatePortion() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        let food = makeFoodItem(context: context)
        vm.addFood(food, portion: .small)
        vm.updatePortion(for: food, to: .large)
        #expect(vm.selectedFoods.first?.portion == .large)
    }

    // MARK: - リセット

    @Test("リセットで初期状態に戻る")
    @MainActor
    func reset() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        vm.addFood(makeFoodItem(context: context))
        vm.memo = "テストメモ"
        vm.searchText = "検索"
        vm.reset()
        #expect(vm.selectedFoods.isEmpty)
        #expect(vm.memo.isEmpty)
        #expect(vm.searchText.isEmpty)
    }

    // MARK: - 保存

    @Test("保存でMealRecordとMealFoodEntryが作成される")
    @MainActor
    func save() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        vm.selectedMealType = .dinner

        let food = makeFoodItem(context: context)
        vm.addFood(food)
        vm.memo = "テスト保存"

        vm.save(modelContext: context)

        let records = try context.fetch(FetchDescriptor<MealRecord>())
        #expect(records.count == 1)
        #expect(records.first?.mealType == "夕食")
        #expect(records.first?.memo == "テスト保存")

        let entries = try context.fetch(FetchDescriptor<MealFoodEntry>())
        #expect(entries.count == 1)
    }

    @Test("memoが空の場合nilで保存される")
    @MainActor
    func saveEmptyMemo() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()
        vm.memo = ""
        vm.save(modelContext: context)

        let records = try context.fetch(FetchDescriptor<MealRecord>())
        #expect(records.first?.memo == nil)
    }

    // MARK: - 検索

    @Test("searchFoodsが全食品を返す（検索テキスト空）")
    @MainActor
    func searchFoodsAll() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let vm = MealRecordViewModel()

        makeFoodItem(context: context, name: "白米")
        makeFoodItem(context: context, name: "豆腐")
        try context.save()

        let results = vm.searchFoods(modelContext: context)
        #expect(results.count == 2)
    }
}
