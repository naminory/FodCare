import SwiftUI

enum ColorTheme {
    // プライマリ: 落ち着いたティール/グリーン系
    static let primary = Color(red: 0.20, green: 0.60, blue: 0.56)       // #339E8F
    static let primaryLight = Color(red: 0.55, green: 0.78, blue: 0.75)  // #8CC7BF
    static let primaryDark = Color(red: 0.10, green: 0.40, blue: 0.37)   // #1A665E

    // FODMAP信号機カラー
    static let fodmapLow = Color(red: 0.30, green: 0.69, blue: 0.31)     // #4CAF50
    static let fodmapMedium = Color(red: 1.00, green: 0.76, blue: 0.03)  // #FFC107
    static let fodmapHigh = Color(red: 0.96, green: 0.26, blue: 0.21)    // #F44336

    // セマンティックカラー
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let cardBackground = Color(.tertiarySystemBackground)
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
}
