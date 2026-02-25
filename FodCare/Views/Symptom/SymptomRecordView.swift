import SwiftUI
import SwiftData

struct SymptomRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SymptomRecordViewModel()

    var body: some View {
        NavigationStack {
            Form {
                // 日時
                Section("日時") {
                    DatePicker("日付", selection: $viewModel.date, displayedComponents: .date)
                    DatePicker("時刻", selection: $viewModel.time, displayedComponents: .hourAndMinute)
                }

                // 症状
                Section {
                    ForEach(SymptomType.allCases) { symptom in
                        symptomRow(symptom)
                    }
                } header: {
                    Text("症状")
                } footer: {
                    HStack {
                        Text("総合スコア:")
                        Text("\(viewModel.overallScore)/15")
                            .fontWeight(.bold)
                        Text("（\(viewModel.severityLabel)）")
                            .foregroundStyle(scoreColor)
                    }
                }

                // ブリストルスケール
                Section("排便（任意）") {
                    BristolScaleSelector(selectedScale: $viewModel.bristolScale)
                }

                // メモ
                Section("メモ") {
                    TextField("メモ（任意）", text: $viewModel.memo, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("症状を記録")
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
                    .fontWeight(.bold)
                }
            }
        }
    }

    private func symptomRow(_ symptom: SymptomType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: symptom.icon)
                    .foregroundStyle(ColorTheme.primary)
                    .frame(width: 20)
                Text(symptom.rawValue)
                    .font(.subheadline)
                Spacer()
                Text(SymptomSeverity(rawValue: viewModel.value(for: symptom))?.label ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Picker(symptom.rawValue, selection: Binding(
                get: { viewModel.value(for: symptom) },
                set: { viewModel.setValue($0, for: symptom) }
            )) {
                ForEach(SymptomSeverity.allCases) { severity in
                    Text(severity.label).tag(severity.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 2)
    }

    private var scoreColor: Color {
        switch viewModel.overallScore {
        case 0: ColorTheme.fodmapLow
        case 1...4: ColorTheme.fodmapLow
        case 5...9: ColorTheme.fodmapMedium
        case 10...15: ColorTheme.fodmapHigh
        default: .secondary
        }
    }
}
