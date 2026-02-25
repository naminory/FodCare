import SwiftUI
import SwiftData

struct MealRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = MealRecordViewModel()
    @State private var showFoodSearch = false

    var body: some View {
        NavigationStack {
            Form {
                // 食事タイプ
                Section("食事タイプ") {
                    Picker("タイプ", selection: $viewModel.selectedMealType) {
                        ForEach(MealType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    DatePicker("日時", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                }

                // 食品リスト
                Section {
                    if viewModel.selectedFoods.isEmpty {
                        Text("食品を追加してください")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(viewModel.selectedFoods.enumerated()), id: \.element.food.id) { _, item in
                            foodEntryRow(item.food, portion: item.portion)
                        }
                        .onDelete { offsets in
                            viewModel.removeFood(at: offsets)
                        }
                    }

                    Button {
                        showFoodSearch = true
                    } label: {
                        Label("食品を追加", systemImage: "plus.circle.fill")
                            .foregroundStyle(ColorTheme.primary)
                    }
                } header: {
                    Text("食品（\(viewModel.selectedFoods.count)品）")
                }

                // メモ
                Section("メモ") {
                    TextField("メモ（任意）", text: $viewModel.memo, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("食事を記録")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        viewModel.save(modelContext: modelContext)
                        dismiss()
                    }
                    .disabled(viewModel.selectedFoods.isEmpty)
                    .fontWeight(.bold)
                }
            }
            .sheet(isPresented: $showFoodSearch) {
                FoodSearchView(viewModel: viewModel)
            }
        }
    }

    private func foodEntryRow(_ food: FoodItem, portion: PortionSize) -> some View {
        HStack {
            FODMAPDot(level: food.fodmapLevel)

            VStack(alignment: .leading) {
                Text(food.nameJA)
                    .font(.body)
                Text(food.nameEN)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // 量選択
            HStack(spacing: 4) {
                ForEach(PortionSize.allCases) { size in
                    Button {
                        viewModel.updatePortion(for: food, to: size)
                    } label: {
                        Text(size.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(portion == size ? ColorTheme.primary : Color(.tertiarySystemBackground))
                            .foregroundStyle(portion == size ? .white : .primary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
