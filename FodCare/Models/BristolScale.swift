import Foundation

// ブリストルスケール（便の形状分類 1-7）
enum BristolScale: Int, CaseIterable, Codable, Identifiable {
    case type1 = 1
    case type2 = 2
    case type3 = 3
    case type4 = 4
    case type5 = 5
    case type6 = 6
    case type7 = 7

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .type1: "タイプ1"
        case .type2: "タイプ2"
        case .type3: "タイプ3"
        case .type4: "タイプ4"
        case .type5: "タイプ5"
        case .type6: "タイプ6"
        case .type7: "タイプ7"
        }
    }

    var description: String {
        switch self {
        case .type1: "硬くコロコロした塊"
        case .type2: "ソーセージ状だが硬い"
        case .type3: "表面にひび割れのあるソーセージ状"
        case .type4: "滑らかで柔らかいソーセージ状"
        case .type5: "柔らかい半固形の塊"
        case .type6: "泥状でふわふわ"
        case .type7: "水状、固形物なし"
        }
    }

    var emoji: String {
        switch self {
        case .type1: "🔵"
        case .type2: "🟤"
        case .type3: "🟡"
        case .type4: "🟢"
        case .type5: "🟡"
        case .type6: "🟠"
        case .type7: "🔴"
        }
    }

    /// 便秘傾向(1-2) / 正常(3-5) / 下痢傾向(6-7)
    var category: String {
        switch self {
        case .type1, .type2: "便秘傾向"
        case .type3, .type4, .type5: "正常"
        case .type6, .type7: "下痢傾向"
        }
    }
}
