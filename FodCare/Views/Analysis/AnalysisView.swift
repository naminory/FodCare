import SwiftUI
import SwiftData

struct AnalysisView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AnalysisViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 週間FODMAPトレンド
                    fodmapChartSection

                    // 症状スコア推移
                    symptomChartSection

                    // 簡易相関
                    correlationSection
                }
                .padding()
            }
            .navigationTitle("分析")
        }
    }

    private var fodmapChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("週間FODMAPトレンド")
                .font(.headline)

            let data = viewModel.fetchWeeklyFODMAP(modelContext: modelContext)
            FODMAPChartView(data: data)
                .frame(height: 200)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var symptomChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("症状スコア推移")
                    .font(.headline)
                Spacer()
                Picker("期間", selection: $viewModel.symptomPeriod) {
                    ForEach(AnalysisViewModel.SymptomPeriod.allCases) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
            }

            let data = viewModel.fetchSymptomTrend(modelContext: modelContext)
            SymptomChartView(data: data)
                .frame(height: 200)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var correlationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("相関分析", systemImage: "lightbulb")
                .font(.headline)

            if let text = viewModel.correlationText(modelContext: modelContext) {
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("データが蓄積されると、食事と症状の相関が表示されます。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
