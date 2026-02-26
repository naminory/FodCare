import Testing
import Foundation
@testable import FodCare

@Suite("FoodItem モデルテスト")
struct FoodItemTests {

    @Test("初期化が正しく動作する")
    func initialization() {
        let item = FoodItem(
            nameJA: "玉ねぎ",
            nameEN: "Onion",
            category: "野菜",
            overallLevel: 2,
            fructanLevel: 2,
            gosLevel: 0,
            lactoseLevel: 0,
            fructoseLevel: 1,
            polyolLevel: 0,
            safePortion: "なし（高FODMAP）",
            note: "フルクタンが非常に多い。"
        )

        #expect(item.nameJA == "玉ねぎ")
        #expect(item.nameEN == "Onion")
        #expect(item.category == "野菜")
        #expect(item.overallLevel == 2)
        #expect(item.isUserCreated == false)
    }

    @Test("FODMAPレベルが正しく返る")
    func fodmapLevel() {
        let low = FoodItem(nameJA: "白米", nameEN: "Rice", category: "穀物",
                           overallLevel: 0, fructanLevel: 0, gosLevel: 0,
                           lactoseLevel: 0, fructoseLevel: 0, polyolLevel: 0)
        let medium = FoodItem(nameJA: "さつまいも", nameEN: "Sweet Potato", category: "野菜",
                              overallLevel: 1, fructanLevel: 0, gosLevel: 0,
                              lactoseLevel: 0, fructoseLevel: 0, polyolLevel: 1)
        let high = FoodItem(nameJA: "玉ねぎ", nameEN: "Onion", category: "野菜",
                            overallLevel: 2, fructanLevel: 2, gosLevel: 0,
                            lactoseLevel: 0, fructoseLevel: 1, polyolLevel: 0)

        #expect(low.fodmapLevel == .low)
        #expect(medium.fodmapLevel == .medium)
        #expect(high.fodmapLevel == .high)
    }

    @Test("カテゴリ別レベル取得が正しい")
    func levelForCategory() {
        let item = FoodItem(nameJA: "牛乳", nameEN: "Milk", category: "乳製品",
                            overallLevel: 2, fructanLevel: 0, gosLevel: 0,
                            lactoseLevel: 2, fructoseLevel: 0, polyolLevel: 0)

        #expect(item.level(for: .fructan) == .low)
        #expect(item.level(for: .gos) == .low)
        #expect(item.level(for: .lactose) == .high)
        #expect(item.level(for: .fructose) == .low)
        #expect(item.level(for: .polyol) == .low)
    }

    @Test("ユーザー作成フラグが設定できる")
    func userCreated() {
        let item = FoodItem(nameJA: "自作食品", nameEN: "Custom", category: "その他",
                            overallLevel: 0, fructanLevel: 0, gosLevel: 0,
                            lactoseLevel: 0, fructoseLevel: 0, polyolLevel: 0,
                            isUserCreated: true)
        #expect(item.isUserCreated == true)
    }
}
