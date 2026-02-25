import Foundation
import SwiftData

// 食事あたりの食品量
enum PortionSize: String, CaseIterable, Codable, Identifiable {
    case small = "少量"
    case medium = "普通"
    case large = "多め"

    var id: String { rawValue }
}

@Model
final class MealFoodEntry {
    var id: UUID
    var portion: String             // PortionSize.rawValue

    var foodItem: FoodItem?
    var mealRecord: MealRecord?

    init(
        id: UUID = UUID(),
        portion: String = PortionSize.medium.rawValue,
        foodItem: FoodItem? = nil,
        mealRecord: MealRecord? = nil
    ) {
        self.id = id
        self.portion = portion
        self.foodItem = foodItem
        self.mealRecord = mealRecord
    }

    var portionSize: PortionSize? {
        PortionSize(rawValue: portion)
    }
}
