import Foundation
import SwiftData

@Model
final class SymptomRecord {
    var id: UUID
    var date: Date
    var time: Date
    var bloating: Int               // お腹の張り 0-3
    var abdominalPain: Int          // 腹痛 0-3
    var gas: Int                    // ガス 0-3
    var diarrhea: Int               // 下痢 0-3
    var constipation: Int           // 便秘 0-3
    var bristolScale: Int?          // ブリストルスケール 1-7
    var memo: String?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        time: Date = .now,
        bloating: Int = 0,
        abdominalPain: Int = 0,
        gas: Int = 0,
        diarrhea: Int = 0,
        constipation: Int = 0,
        bristolScale: Int? = nil,
        memo: String? = nil
    ) {
        self.id = id
        self.date = date
        self.time = time
        self.bloating = bloating
        self.abdominalPain = abdominalPain
        self.gas = gas
        self.diarrhea = diarrhea
        self.constipation = constipation
        self.bristolScale = bristolScale
        self.memo = memo
    }

    /// 総合スコア（5症状の合計、0-15）
    var overallScore: Int {
        bloating + abdominalPain + gas + diarrhea + constipation
    }

    /// 症状の重症度ラベル
    var severityLabel: String {
        switch overallScore {
        case 0: "症状なし"
        case 1...4: "軽度"
        case 5...9: "中度"
        case 10...15: "重度"
        default: "不明"
        }
    }

    /// ブリストルスケールenum
    var bristolScaleEnum: BristolScale? {
        guard let bristolScale else { return nil }
        return BristolScale(rawValue: bristolScale)
    }
}

// 症状名とキーパスのマッピング
enum SymptomType: String, CaseIterable, Identifiable {
    case bloating = "お腹の張り"
    case abdominalPain = "腹痛"
    case gas = "ガス"
    case diarrhea = "下痢"
    case constipation = "便秘"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .bloating: "circle.circle"
        case .abdominalPain: "bolt.fill"
        case .gas: "wind"
        case .diarrhea: "drop.fill"
        case .constipation: "stop.fill"
        }
    }
}

// 症状の重症度（0-3）
enum SymptomSeverity: Int, CaseIterable, Identifiable {
    case none = 0
    case mild = 1
    case moderate = 2
    case severe = 3

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .none: "なし"
        case .mild: "軽度"
        case .moderate: "中度"
        case .severe: "重度"
        }
    }
}
