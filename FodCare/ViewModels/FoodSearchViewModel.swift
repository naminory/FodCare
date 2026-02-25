import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class FoodSearchViewModel {
    var searchText = ""
    var selectedCategory: String? = nil
    var selectedLevel: Int? = nil // nil=すべて, 0=低のみ, 1=中以下

    // 食品カテゴリ一覧
    static let categories = ["野菜", "果物", "穀物", "大豆製品", "乳製品", "たんぱく質", "調味料", "加工食品", "飲料"]

    func fetchFoods(modelContext: ModelContext) -> [FoodItem] {
        var descriptor = FetchDescriptor<FoodItem>(
            sortBy: [SortDescriptor(\.nameJA)]
        )

        guard let allFoods = try? modelContext.fetch(descriptor) else {
            return []
        }

        var results = allFoods

        // カテゴリフィルター
        if let category = selectedCategory {
            results = results.filter { $0.category == category }
        }

        // FODMAPレベルフィルター
        if let level = selectedLevel {
            results = results.filter { $0.overallLevel <= level }
        }

        // テキスト検索
        if !searchText.isEmpty {
            results = results.filter {
                $0.nameJA.localizedStandardContains(searchText) ||
                $0.nameEN.localizedStandardContains(searchText)
            }
        }

        return results
    }
}
