import SwiftUI

struct FoodDetailView: View {
    let foodItem: FoodItem
    var onSelect: ((FoodItem) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // ヘッダー
                HStack {
                    VStack(alignment: .leading) {
                        Text(foodItem.nameJA)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(foodItem.nameEN)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    FODMAPBadge(level: foodItem.fodmapLevel)
                }

                // 5分類バー
                FODMAPCategoryBar(foodItem: foodItem)
                    .frame(maxWidth: .infinity)

                // 安全な量
                if let portion = foodItem.safePortion {
                    GroupBox("安全な量") {
                        Text(portion)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // 備考
                if let note = foodItem.note, !note.isEmpty {
                    GroupBox("備考") {
                        Text(note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // 選択ボタン
                if let onSelect {
                    Button {
                        onSelect(foodItem)
                    } label: {
                        Label("この食品を追加", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ColorTheme.primary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
