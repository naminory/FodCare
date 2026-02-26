import Testing
import Foundation
@testable import FodCare

@Suite("SymptomRecord モデルテスト")
struct SymptomRecordTests {

    @Test("総合スコアが正しく計算される")
    func overallScore() {
        let record = SymptomRecord(
            bloating: 2,
            abdominalPain: 1,
            gas: 3,
            diarrhea: 0,
            constipation: 1
        )
        #expect(record.overallScore == 7)
    }

    @Test("すべて0の場合スコアは0")
    func zeroScore() {
        let record = SymptomRecord()
        #expect(record.overallScore == 0)
    }

    @Test("最大スコアは15")
    func maxScore() {
        let record = SymptomRecord(
            bloating: 3,
            abdominalPain: 3,
            gas: 3,
            diarrhea: 3,
            constipation: 3
        )
        #expect(record.overallScore == 15)
    }

    @Test("重症度ラベルが正しい", arguments: [
        (0, "症状なし"),
        (2, "軽度"),
        (4, "軽度"),
        (5, "中度"),
        (9, "中度"),
        (10, "重度"),
        (15, "重度")
    ])
    func severityLabel(score: Int, expected: String) {
        // スコアを直接作り出すため各症状を調整
        let bloating = min(score, 3)
        let remaining = score - bloating
        let pain = min(remaining, 3)
        let rest = remaining - pain
        let gas = min(rest, 3)
        let rest2 = rest - gas
        let diarrhea = min(rest2, 3)
        let constipation = rest2 - diarrhea

        let record = SymptomRecord(
            bloating: bloating,
            abdominalPain: pain,
            gas: gas,
            diarrhea: diarrhea,
            constipation: constipation
        )
        #expect(record.severityLabel == expected)
    }

    @Test("ブリストルスケールenumが正しく変換される")
    func bristolScaleEnum() {
        let withScale = SymptomRecord(bristolScale: 4)
        #expect(withScale.bristolScaleEnum == .type4)
        #expect(withScale.bristolScaleEnum?.description == "滑らかで柔らかいソーセージ状")

        let withoutScale = SymptomRecord()
        #expect(withoutScale.bristolScaleEnum == nil)
    }
}
