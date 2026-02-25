import SwiftUI
import SwiftData

struct FoodListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FoodSearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // フィルターバー
                filterBar

                // 食品リスト
                let foods = viewModel.fetchFoods(modelContext: modelContext)
                if foods.isEmpty {
                    ContentUnavailableView(
                        "食品が見つかりません",
                        systemImage: "magnifyingglass",
                        description: Text("検索条件を変更してください")
                    )
                } else {
                    List(foods, id: \.id) { food in
                        NavigationLink {
                            FODMAPInfoView(foodItem: food)
                        } label: {
                            foodRow(food)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("食品図鑑")
            .searchable(text: $viewModel.searchText, prompt: "食品名で検索")
        }
    }

    // MARK: - フィルターバー
    private var filterBar: some View {
        VStack(spacing: 8) {
            // カテゴリスクロール
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryChip(nil, label: "すべて")
                    ForEach(FoodSearchViewModel.categories, id: \.self) { cat in
                        categoryChip(cat, label: cat)
                    }
                }
                .padding(.horizontal)
            }

            // FODMAPレベルフィルター
            HStack(spacing: 8) {
                levelChip(nil, label: "すべて")
                levelChip(0, label: "低のみ")
                levelChip(1, label: "中以下")
                Spacer()
                let count = viewModel.fetchFoods(modelContext: modelContext).count
                Text("\(count)品目")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }

    // MARK: - カテゴリチップ
    private func categoryChip(_ category: String?, label: String) -> some View {
        let selected = viewModel.selectedCategory == category
        return Button {
            viewModel.selectedCategory = category
        } label: {
            Text(label)
                .font(.caption)
                .fontWeight(selected ? .bold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selected ? ColorTheme.primary : Color(.tertiarySystemBackground))
                .foregroundStyle(selected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    // MARK: - レベルチップ
    private func levelChip(_ level: Int?, label: String) -> some View {
        let selected = viewModel.selectedLevel == level
        return Button {
            viewModel.selectedLevel = level
        } label: {
            Text(label)
                .font(.caption)
                .fontWeight(selected ? .bold : .regular)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(selected ? ColorTheme.primary.opacity(0.2) : Color(.tertiarySystemBackground))
                .foregroundStyle(selected ? ColorTheme.primary : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(selected ? ColorTheme.primary : .clear, lineWidth: 1)
                )
        }
    }

    // MARK: - 食品行
    private func foodRow(_ food: FoodItem) -> some View {
        HStack(spacing: 12) {
            FODMAPDot(level: food.fodmapLevel)

            VStack(alignment: .leading, spacing: 2) {
                Text(food.nameJA)
                    .font(.body)
                Text(food.nameEN)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let portion = food.safePortion {
                Text(portion)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            FODMAPBadge(level: food.fodmapLevel)
        }
        .padding(.vertical, 2)
    }
}
