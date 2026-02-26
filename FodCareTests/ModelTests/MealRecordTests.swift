import Testing
import Foundation
@testable import FodCare

@Suite("MealRecord モデルテスト")
struct MealRecordTests {

    @Test("MealTypeの全ケースが存在する")
    func mealTypeAllCases() {
        #expect(MealType.allCases.count == 4)
        #expect(MealType.allCases.contains(.breakfast))
        #expect(MealType.allCases.contains(.lunch))
        #expect(MealType.allCases.contains(.dinner))
        #expect(MealType.allCases.contains(.snack))
    }

    @Test("MealType rawValueが日本語")
    func mealTypeRawValue() {
        #expect(MealType.breakfast.rawValue == "朝食")
        #expect(MealType.lunch.rawValue == "昼食")
        #expect(MealType.dinner.rawValue == "夕食")
        #expect(MealType.snack.rawValue == "間食")
    }

    @Test("MealRecord初期化が正しい")
    func initialization() {
        let date = Date()
        let record = MealRecord(date: date, mealType: MealType.lunch.rawValue, memo: "テストメモ")

        #expect(record.mealType == "昼食")
        #expect(record.memo == "テストメモ")
        #expect(record.entries.isEmpty)
    }

    @Test("mealTypeEnumが正しく変換される")
    func mealTypeEnum() {
        let record = MealRecord(mealType: MealType.dinner.rawValue)
        #expect(record.mealTypeEnum == .dinner)

        let invalid = MealRecord(mealType: "不明")
        #expect(invalid.mealTypeEnum == nil)
    }

    @Test("PortionSizeの全ケースが存在する")
    func portionSizeAllCases() {
        #expect(PortionSize.allCases.count == 3)
        #expect(PortionSize.small.rawValue == "少量")
        #expect(PortionSize.medium.rawValue == "普通")
        #expect(PortionSize.large.rawValue == "多め")
    }
}
