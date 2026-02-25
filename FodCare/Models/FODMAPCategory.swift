import SwiftUI

// FODMAP 5分類
enum FODMAPCategory: String, CaseIterable, Codable, Identifiable {
    case fructan = "フルクタン"
    case gos = "GOS"
    case lactose = "乳糖"
    case fructose = "フルクトース"
    case polyol = "ポリオール"

    var id: String { rawValue }

    var nameEN: String {
        switch self {
        case .fructan: "Fructan"
        case .gos: "GOS"
        case .lactose: "Lactose"
        case .fructose: "Excess Fructose"
        case .polyol: "Polyol"
        }
    }

    var icon: String {
        switch self {
        case .fructan: "leaf"
        case .gos: "bean"
        case .lactose: "cup.and.saucer"
        case .fructose: "apple.logo"
        case .polyol: "drop"
        }
    }
}

// FODMAPレベル（0=低, 1=中, 2=高）
enum FODMAPLevel: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2

    var label: String {
        switch self {
        case .low: "低"
        case .medium: "中"
        case .high: "高"
        }
    }

    var color: Color {
        switch self {
        case .low: ColorTheme.fodmapLow
        case .medium: ColorTheme.fodmapMedium
        case .high: ColorTheme.fodmapHigh
        }
    }
}
