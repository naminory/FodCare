import Testing
import Foundation
import SwiftData
@testable import FodCare

@Suite("FoodSearchViewModel テスト")
struct FoodSearchViewModelTests {

    @MainActor
    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([FoodItem.self, MealRecord.self, MealFoodEntry.self, SymptomRecord.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }

    @MainActor
    private func insertSampleFoods(_ context: ModelContext) {
        let foods = [
            FoodItem(nameJA: "白米", nameEN: "Rice", category: "穀物",
                     overallLevel: 0, fructanLevel: 0, gosLevel: 0,
                     lactoseLevel: 0, fructoseLevel: 0, polyolLevel: 0),
            FoodItem(nameJA: "玉ねぎ", nameEN: "Onion", category: "野菜",
                     overallLevel: 2, fructanLevel: 2, gosLevel: 0,
                     lactoseLevel: 0, fructoseLevel: 1, polyolLevel: 0),
            FoodItem(nameJA: "牛乳", nameEN: "Milk", category: "乳製品",
                     overallLevel: 2, fructanLevel: 0, gosLevel: 0,
                     lactoseLevel: 2, fructoseLevel: 0, polyolLevel: 0),
            FoodItem(nameJA: "さつまいも", nameEN: "Sweet Potato", category: "野菜",
                     overallLevel: 1, fructanLevel: 0, gosLevel: 0,
                     lactoseLevel: 0, fructoseLevel: 0, polyolLevel: 1),
        ]
        for food in foods {
            context.insert(food)
        }
    }

    // MARK: - 初期状態

    @Test("初期状態が正しい")
    @MainActor
    func initialState() {
        let vm = FoodSearchViewModel()
        #expect(vm.searchText.isEmpty)
        #expect(vm.selectedCategory == nil)
        #expect(vm.selectedLevel == nil)
    }

    @Test("カテゴリ一覧が9つ存在する")
    @MainActor
    func categoriesCount() {
        #expect(FoodSearchViewModel.categories.count == 9)
    }

    // MARK: - フィルターなし

    @Test("フィルターなしで全食品を返す")
    @MainActor
    func fetchAllFoods() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 4)
    }

    // MARK: - カテゴリフィルター

    @Test("カテゴリフィルターが正しく動作する")
    @MainActor
    func filterByCategory() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.selectedCategory = "野菜"
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.category == "野菜" })
    }

    // MARK: - FODMAPレベルフィルター

    @Test("低FODMAPのみフィルター")
    @MainActor
    func filterByLowLevel() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.selectedLevel = 0
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 1)
        #expect(results.first?.nameJA == "白米")
    }

    @Test("中以下FODMAPフィルター")
    @MainActor
    func filterByMediumOrLow() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.selectedLevel = 1
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.overallLevel <= 1 })
    }

    // MARK: - テキスト検索

    @Test("日本語名で検索できる")
    @MainActor
    func searchByJapaneseName() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.searchText = "玉ねぎ"
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 1)
        #expect(results.first?.nameJA == "玉ねぎ")
    }

    @Test("英語名で検索できる")
    @MainActor
    func searchByEnglishName() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.searchText = "Rice"
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 1)
        #expect(results.first?.nameEN == "Rice")
    }

    // MARK: - 複合フィルター

    @Test("カテゴリ + テキスト検索の複合フィルター")
    @MainActor
    func combinedFilter() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.selectedCategory = "野菜"
        vm.searchText = "さつまいも"
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.count == 1)
        #expect(results.first?.nameJA == "さつまいも")
    }

    @Test("ヒットしない検索は空配列を返す")
    @MainActor
    func noResults() throws {
        let container = try makeContainer()
        let context = container.mainContext
        insertSampleFoods(context)
        try context.save()

        let vm = FoodSearchViewModel()
        vm.searchText = "存在しない食品"
        let results = vm.fetchFoods(modelContext: context)
        #expect(results.isEmpty)
    }
}
