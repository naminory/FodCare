import Foundation
import SwiftData

// JSONデコード用DTO
struct FoodItemDTO: Codable {
    let nameJA: String
    let nameEN: String
    let category: String
    let overallLevel: Int
    let fructanLevel: Int
    let gOSLevel: Int
    let lactoseLevel: Int
    let fructoseLevel: Int
    let polyolLevel: Int
    let safePortion: String?
    let note: String?
}

@MainActor
final class DataManager {
    private static let seedKey = "hasSeededFoodData_v1"

    /// 初回起動時に食品マスタデータをシード投入
    static func seedIfNeeded(modelContext: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: seedKey) else { return }

        guard let url = Bundle.main.url(forResource: "fodmap_foods_ja", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let foods = try? JSONDecoder().decode([FoodItemDTO].self, from: data)
        else {
            return
        }

        for dto in foods {
            let item = FoodItem(
                nameJA: dto.nameJA,
                nameEN: dto.nameEN,
                category: dto.category,
                overallLevel: dto.overallLevel,
                fructanLevel: dto.fructanLevel,
                gosLevel: dto.gOSLevel,
                lactoseLevel: dto.lactoseLevel,
                fructoseLevel: dto.fructoseLevel,
                polyolLevel: dto.polyolLevel,
                safePortion: dto.safePortion,
                note: dto.note,
                isUserCreated: false
            )
            modelContext.insert(item)
        }

        try? modelContext.save()
        UserDefaults.standard.set(true, forKey: seedKey)
    }
}
