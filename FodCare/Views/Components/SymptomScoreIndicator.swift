import SwiftUI

struct SymptomScoreIndicator: View {
    let score: Int
    let maxScore: Int = 15

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 6)

                Circle()
                    .trim(from: 0, to: CGFloat(score) / CGFloat(maxScore))
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(scoreColor)
                    Text("/\(maxScore)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 64, height: 64)

            Text(severityLabel)
                .font(.caption)
                .foregroundStyle(scoreColor)
        }
    }

    private var scoreColor: Color {
        switch score {
        case 0: ColorTheme.fodmapLow
        case 1...4: ColorTheme.fodmapLow
        case 5...9: ColorTheme.fodmapMedium
        case 10...15: ColorTheme.fodmapHigh
        default: .secondary
        }
    }

    private var severityLabel: String {
        switch score {
        case 0: "症状なし"
        case 1...4: "軽度"
        case 5...9: "中度"
        case 10...15: "重度"
        default: "不明"
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        SymptomScoreIndicator(score: 0)
        SymptomScoreIndicator(score: 3)
        SymptomScoreIndicator(score: 7)
        SymptomScoreIndicator(score: 12)
    }
}
