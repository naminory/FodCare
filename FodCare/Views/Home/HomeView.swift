import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()
    @State private var showMealRecord = false
    @State private var showSymptomRecord = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 日付ナビゲーション
                    DateNavigator(
                        date: $viewModel.selectedDate,
                        onPrevious: { viewModel.moveDay(by: -1) },
                        onNext: { viewModel.moveDay(by: 1) }
                    )

                    let meals = viewModel.fetchMeals(modelContext: modelContext)
                    let symptom = viewModel.fetchLatestSymptom(modelContext: modelContext)

                    // FODMAPサマリー
                    fodmapSummaryCard(meals: meals)

                    // 食事カード
                    mealsSection(meals: meals)

                    // 症状スコア
                    symptomSection(symptom: symptom)
                }
                .padding()
            }
            .navigationTitle("フォドケア")
            .overlay(alignment: .bottom) {
                quickActionButtons
            }
            .sheet(isPresented: $showMealRecord) {
                MealRecordView()
            }
            .sheet(isPresented: $showSymptomRecord) {
                SymptomRecordView()
            }
        }
    }

    // MARK: - FODMAPサマリーカード
    private func fodmapSummaryCard(meals: [MealRecord]) -> some View {
        let summary = viewModel.fodmapSummary(meals: meals)

        return VStack(alignment: .leading, spacing: 12) {
            Text("今日のFODMAP")
                .font(.headline)

            if meals.isEmpty {
                Text("食事が記録されていません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                HStack(spacing: 12) {
                    ForEach(FODMAPCategory.allCases) { category in
                        let level = FODMAPLevel(rawValue: summary[category] ?? 0) ?? .low
                        VStack(spacing: 6) {
                            Circle()
                                .fill(level.color)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Text(level.label)
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            Text(category.rawValue)
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 食事セクション
    private func mealsSection(meals: [MealRecord]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("食事記録")
                .font(.headline)

            if meals.isEmpty {
                Text("まだ記録がありません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(meals, id: \.id) { meal in
                    mealCard(meal)
                }
            }
        }
    }

    private func mealCard(_ meal: MealRecord) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let mealType = meal.mealTypeEnum {
                    Image(systemName: mealType.icon)
                        .foregroundStyle(ColorTheme.primary)
                    Text(mealType.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Spacer()
                Text(DateHelper.displayTime(meal.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(meal.entries, id: \.id) { entry in
                if let food = entry.foodItem {
                    HStack(spacing: 8) {
                        FODMAPDot(level: food.fodmapLevel)
                        Text(food.nameJA)
                            .font(.caption)
                        Spacer()
                        Text(entry.portion)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - 症状セクション
    private func symptomSection(symptom: SymptomRecord?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("症状")
                .font(.headline)

            if let symptom {
                HStack {
                    SymptomScoreIndicator(score: symptom.overallScore)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(DateHelper.displayTime(symptom.time))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ForEach(SymptomType.allCases) { type in
                            let value = symptomValue(symptom, type: type)
                            if value > 0 {
                                HStack {
                                    Text(type.rawValue)
                                        .font(.caption)
                                    Spacer()
                                    Text(SymptomSeverity(rawValue: value)?.label ?? "")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("まだ記録がありません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.bottom, 80) // クイックアクションボタン分の余白
    }

    private func symptomValue(_ record: SymptomRecord, type: SymptomType) -> Int {
        switch type {
        case .bloating: record.bloating
        case .abdominalPain: record.abdominalPain
        case .gas: record.gas
        case .diarrhea: record.diarrhea
        case .constipation: record.constipation
        }
    }

    // MARK: - クイックアクションボタン
    private var quickActionButtons: some View {
        HStack(spacing: 16) {
            Button {
                showMealRecord = true
            } label: {
                Label("食事を記録", systemImage: "fork.knife")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ColorTheme.primary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Button {
                showSymptomRecord = true
            } label: {
                Label("症状を記録", systemImage: "heart.text.clipboard")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ColorTheme.primaryLight)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
