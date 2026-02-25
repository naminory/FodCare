import SwiftUI

struct FODMAPInfoView: View {
    let foodItem: FoodItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ヘッダー
                headerSection

                Divider()

                // FODMAP 5分類
                fodmapSection

                Divider()

                // 安全な量
                if let portion = foodItem.safePortion {
                    infoSection(title: "安全な量", content: portion, icon: "scalemass")
                }

                // 備考
                if let note = foodItem.note, !note.isEmpty {
                    infoSection(title: "備考", content: note, icon: "info.circle")
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(foodItem.nameJA)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - ヘッダー
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(foodItem.nameJA)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(foodItem.nameEN)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                FODMAPBadge(level: foodItem.fodmapLevel)
                    .scaleEffect(1.3)
            }

            HStack {
                Label(foodItem.category, systemImage: "tag")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - FODMAP 5分類
    private var fodmapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FODMAP分類")
                .font(.headline)

            ForEach(FODMAPCategory.allCases) { category in
                let level = foodItem.level(for: category)
                HStack {
                    Image(systemName: category.icon)
                        .frame(width: 24)
                        .foregroundStyle(ColorTheme.primary)
                    Text(category.rawValue)
                        .font(.subheadline)
                    Spacer()
                    levelBar(level: level)
                    FODMAPBadge(level: level)
                }
            }
        }
    }

    // MARK: - レベルバー
    private func levelBar(level: FODMAPLevel) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i <= level.rawValue ? level.color : Color(.systemGray5))
                    .frame(width: 20, height: 8)
            }
        }
    }

    // MARK: - 情報セクション
    private func infoSection(title: String, content: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
            Text(content)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
