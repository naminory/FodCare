import Foundation
import SwiftData

@Model
final class FoodItem {
    var id: UUID
    var nameJA: String              // 日本語名（例: "玉ねぎ"）
    var nameEN: String              // 英語名（例: "Onion"）
    var category: String            // カテゴリ（野菜、果物、穀物、乳製品、たんぱく質、調味料、その他）
    var overallLevel: Int           // 総合FODMAPレベル 0=低 1=中 2=高
    var fructanLevel: Int           // フルクタン 0-2
    var gosLevel: Int               // ガラクトオリゴ糖 0-2
    var lactoseLevel: Int           // 乳糖 0-2
    var fructoseLevel: Int          // 余剰フルクトース 0-2
    var polyolLevel: Int            // ポリオール 0-2
    var safePortion: String?        // 安全な量（例: "75g"）
    var note: String?               // 備考
    var isUserCreated: Bool         // ユーザー追加食品か

    @Relationship(deleteRule: .nullify, inverse: \MealFoodEntry.foodItem)
    var mealFoodEntries: [MealFoodEntry]

    init(
        id: UUID = UUID(),
        nameJA: String,
        nameEN: String,
        category: String,
        overallLevel: Int,
        fructanLevel: Int,
        gosLevel: Int,
        lactoseLevel: Int,
        fructoseLevel: Int,
        polyolLevel: Int,
        safePortion: String? = nil,
        note: String? = nil,
        isUserCreated: Bool = false
    ) {
        self.id = id
        self.nameJA = nameJA
        self.nameEN = nameEN
        self.category = category
        self.overallLevel = overallLevel
        self.fructanLevel = fructanLevel
        self.gosLevel = gosLevel
        self.lactoseLevel = lactoseLevel
        self.fructoseLevel = fructoseLevel
        self.polyolLevel = polyolLevel
        self.safePortion = safePortion
        self.note = note
        self.isUserCreated = isUserCreated
        self.mealFoodEntries = []
    }

    /// 指定カテゴリのFODMAPレベル取得
    func level(for category: FODMAPCategory) -> FODMAPLevel {
        let value = switch category {
        case .fructan: fructanLevel
        case .gos: gosLevel
        case .lactose: lactoseLevel
        case .fructose: fructoseLevel
        case .polyol: polyolLevel
        }
        return FODMAPLevel(rawValue: value) ?? .low
    }

    /// 総合FODMAPレベル
    var fodmapLevel: FODMAPLevel {
        FODMAPLevel(rawValue: overallLevel) ?? .low
    }
}
