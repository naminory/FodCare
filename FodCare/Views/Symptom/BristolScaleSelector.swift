import SwiftUI

struct BristolScaleSelector: View {
    @Binding var selectedScale: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 選択なしボタン
            if selectedScale != nil {
                Button {
                    selectedScale = nil
                } label: {
                    Text("選択を解除")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // スケール選択
            ForEach(BristolScale.allCases) { scale in
                Button {
                    selectedScale = scale.rawValue
                } label: {
                    HStack(spacing: 12) {
                        Text(scale.emoji)
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(scale.label)
                                .font(.subheadline)
                                .fontWeight(selectedScale == scale.rawValue ? .bold : .regular)
                            Text(scale.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(scale.category)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(categoryColor(scale.category).opacity(0.15))
                            .foregroundStyle(categoryColor(scale.category))
                            .clipShape(Capsule())

                        if selectedScale == scale.rawValue {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(ColorTheme.primary)
                        }
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "便秘傾向": ColorTheme.fodmapMedium
        case "正常": ColorTheme.fodmapLow
        case "下痢傾向": ColorTheme.fodmapHigh
        default: .secondary
        }
    }
}
