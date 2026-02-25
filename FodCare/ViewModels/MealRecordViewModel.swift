import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class MealRecordViewModel {
    var selectedMealType: MealType = .breakfast
    var selectedFoods: [(food: FoodItem, portion: PortionSize)] = []
    var memo: String = ""
    var date: Date = .now
    var searchText: String = ""

    func addFood(_ food: FoodItem, portion: PortionSize = .medium) {
        // 重複チェック
        guard !selectedFoods.contains(where: { $0.food.id == food.id }) else { return }
        selectedFoods.append((food: food, portion: portion))
    }

    func removeFood(at offsets: IndexSet) {
        selectedFoods.remove(atOffsets: offsets)
    }

    func updatePortion(for food: FoodItem, to portion: PortionSize) {
        guard let index = selectedFoods.firstIndex(where: { $0.food.id == food.id }) else { return }
        selectedFoods[index] = (food: food, portion: portion)
    }

    func save(modelContext: ModelContext) {
        let record = MealRecord(
            date: date,
            mealType: selectedMealType.rawValue,
            memo: memo.isEmpty ? nil : memo
        )
        modelContext.insert(record)

        for item in selectedFoods {
            let entry = MealFoodEntry(
                portion: item.portion.rawValue,
                foodItem: item.food,
                mealRecord: record
            )
            modelContext.insert(entry)
        }

        try? modelContext.save()
    }

    func searchFoods(modelContext: ModelContext) -> [FoodItem] {
        var descriptor = FetchDescriptor<FoodItem>(
            sortBy: [SortDescriptor(\.nameJA)]
        )
        guard let allFoods = try? modelContext.fetch(descriptor) else { return [] }

        if searchText.isEmpty { return allFoods }

        return allFoods.filter {
            $0.nameJA.localizedStandardContains(searchText) ||
            $0.nameEN.localizedStandardContains(searchText)
        }
    }

    func reset() {
        selectedFoods = []
        memo = ""
        searchText = ""
    }
}
