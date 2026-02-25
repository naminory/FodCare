import SwiftUI

// 信号機カラーバッジ（低/中/高）
struct FODMAPBadge: View {
    let level: FODMAPLevel

    var body: some View {
        Text(level.label)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(level.color, in: Capsule())
    }
}

// 食品名の横に表示するコンパクトバッジ
struct FODMAPDot: View {
    let level: FODMAPLevel

    var body: some View {
        Circle()
            .fill(level.color)
            .frame(width: 12, height: 12)
    }
}

#Preview {
    VStack(spacing: 12) {
        FODMAPBadge(level: .low)
        FODMAPBadge(level: .medium)
        FODMAPBadge(level: .high)

        HStack {
            FODMAPDot(level: .low)
            FODMAPDot(level: .medium)
            FODMAPDot(level: .high)
        }
    }
}
