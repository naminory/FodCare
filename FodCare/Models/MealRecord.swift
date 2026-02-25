import Foundation
import SwiftData

// 食事タイプ
enum MealType: String, CaseIterable, Codable, Identifiable {
    case breakfast = "朝食"
    case lunch = "昼食"
    case dinner = "夕食"
    case snack = "間食"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .breakfast: "sunrise"
        case .lunch: "sun.max"
        case .dinner: "moon.stars"
        case .snack: "cup.and.saucer"
        }
    }
}

@Model
final class MealRecord {
    var id: UUID
    var date: Date
    var mealType: String            // MealType.rawValue
    var memo: String?

    @Relationship(deleteRule: .cascade, inverse: \MealFoodEntry.mealRecord)
    var entries: [MealFoodEntry]

    init(
        id: UUID = UUID(),
        date: Date = .now,
        mealType: String,
        memo: String? = nil
    ) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.memo = memo
        self.entries = []
    }

    /// MealType enumとして取得
    var mealTypeEnum: MealType? {
        MealType(rawValue: mealType)
    }

    /// この食事の最大FODMAPレベル（各カテゴリ）
    func maxLevel(for category: FODMAPCategory) -> Int {
        entries.compactMap { $0.foodItem?.level(for: category).rawValue }.max() ?? 0
    }
}
