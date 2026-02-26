import Testing
import Foundation
@testable import FodCare

@Suite("Enum テスト")
struct EnumTests {

    // MARK: - FODMAPCategory
    @Test("FODMAPCategoryが5分類すべて存在する")
    func fodmapCategoryCount() {
        #expect(FODMAPCategory.allCases.count == 5)
    }

    @Test("FODMAPCategory日本語名が正しい")
    func fodmapCategoryNames() {
        #expect(FODMAPCategory.fructan.rawValue == "フルクタン")
        #expect(FODMAPCategory.gos.rawValue == "GOS")
        #expect(FODMAPCategory.lactose.rawValue == "乳糖")
        #expect(FODMAPCategory.fructose.rawValue == "フルクトース")
        #expect(FODMAPCategory.polyol.rawValue == "ポリオール")
    }

    // MARK: - FODMAPLevel
    @Test("FODMAPLevelラベルが正しい")
    func fodmapLevelLabels() {
        #expect(FODMAPLevel.low.label == "低")
        #expect(FODMAPLevel.medium.label == "中")
        #expect(FODMAPLevel.high.label == "高")
    }

    @Test("FODMAPLevel rawValueが正しい")
    func fodmapLevelRawValues() {
        #expect(FODMAPLevel.low.rawValue == 0)
        #expect(FODMAPLevel.medium.rawValue == 1)
        #expect(FODMAPLevel.high.rawValue == 2)
    }

    // MARK: - BristolScale
    @Test("BristolScaleが7タイプすべて存在する")
    func bristolScaleCount() {
        #expect(BristolScale.allCases.count == 7)
    }

    @Test("BristolScaleカテゴリ分類が正しい")
    func bristolScaleCategories() {
        #expect(BristolScale.type1.category == "便秘傾向")
        #expect(BristolScale.type2.category == "便秘傾向")
        #expect(BristolScale.type3.category == "正常")
        #expect(BristolScale.type4.category == "正常")
        #expect(BristolScale.type5.category == "正常")
        #expect(BristolScale.type6.category == "下痢傾向")
        #expect(BristolScale.type7.category == "下痢傾向")
    }

    // MARK: - SymptomSeverity
    @Test("SymptomSeverityが4段階すべて存在する")
    func symptomSeverityCount() {
        #expect(SymptomSeverity.allCases.count == 4)
    }

    @Test("SymptomSeverityラベルが正しい")
    func symptomSeverityLabels() {
        #expect(SymptomSeverity.none.label == "なし")
        #expect(SymptomSeverity.mild.label == "軽度")
        #expect(SymptomSeverity.moderate.label == "中度")
        #expect(SymptomSeverity.severe.label == "重度")
    }

    // MARK: - SymptomType
    @Test("SymptomTypeが5症状すべて存在する")
    func symptomTypeCount() {
        #expect(SymptomType.allCases.count == 5)
    }
}
