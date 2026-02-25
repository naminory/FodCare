import SwiftUI
import SwiftData

struct FoodSearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: MealRecordViewModel

    var body: some View {
        NavigationStack {
            let foods = viewModel.searchFoods(modelContext: modelContext)
            List(foods, id: \.id) { food in
                Button {
                    viewModel.addFood(food)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        FODMAPDot(level: food.fodmapLevel)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(food.nameJA)
                                .font(.body)
                                .foregroundStyle(.primary)
                            Text(food.nameEN)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(food.category)
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        FODMAPBadge(level: food.fodmapLevel)

                        // 追加済みマーク
                        if viewModel.selectedFoods.contains(where: { $0.food.id == food.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(ColorTheme.primary)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("食品を検索")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "食品名で検索")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }
}
