import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showResetAlert = false
    @State private var showDisclaimer = false

    var body: some View {
        NavigationStack {
            List {
                // アプリ情報
                Section("アプリ情報") {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("アプリ名")
                        Spacer()
                        Text("フォドケア")
                            .foregroundStyle(.secondary)
                    }
                }

                // 免責事項
                Section("法的情報") {
                    Button {
                        showDisclaimer = true
                    } label: {
                        Label("免責事項", systemImage: "doc.text")
                            .foregroundStyle(.primary)
                    }
                }

                // データ管理
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("食事・症状データを削除", systemImage: "trash")
                    }
                } header: {
                    Text("データ管理")
                } footer: {
                    Text("食品マスタデータは削除されません。食事記録と症状記録のみ削除されます。")
                }

                // FODMAPについて
                Section("FODMAPとは") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FODMAP（フォドマップ）は、小腸で吸収されにくい短鎖炭水化物の総称です。")
                            .font(.subheadline)
                        Text("F: Fermentable（発酵性）")
                        Text("O: Oligosaccharides（オリゴ糖）")
                        Text("D: Disaccharides（二糖類）")
                        Text("M: Monosaccharides（単糖類）")
                        Text("A: And")
                        Text("P: Polyols（ポリオール）")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .alert("データを削除", isPresented: $showResetAlert) {
                Button("キャンセル", role: .cancel) {}
                Button("削除", role: .destructive) {
                    resetUserData()
                }
            } message: {
                Text("食事記録と症状記録をすべて削除します。この操作は取り消せません。")
            }
            .sheet(isPresented: $showDisclaimer) {
                disclaimerSheet
            }
        }
    }

    private var disclaimerSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("免責事項")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("本アプリ「フォドケア」の情報は医療アドバイスではありません。")
                        .fontWeight(.semibold)

                    Text("本アプリは、低FODMAP食に関する一般的な情報を提供することを目的としています。特定の食品のFODMAP含有量は、Monash大学の公開研究データを基準としていますが、一部の食品については類似食品からの推定値が含まれます。")

                    Text("食事の変更は必ず医師・管理栄養士にご相談ください。")
                        .fontWeight(.semibold)
                        .foregroundStyle(ColorTheme.fodmapHigh)

                    Text("本アプリの情報に基づいて行った食事の変更や健康管理について、開発者は一切の責任を負いません。個人の健康状態や症状は個人差があるため、専門家の指導のもとで食事管理を行ってください。")

                    Text("データの取り扱いについて")
                        .font(.headline)
                        .padding(.top, 8)

                    Text("本アプリで記録されたデータはすべてお使いのデバイス内にのみ保存されます。外部サーバーへの送信は一切行いません。")
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { showDisclaimer = false }
                }
            }
        }
    }

    private func resetUserData() {
        // 食事記録を削除
        let mealDescriptor = FetchDescriptor<MealRecord>()
        if let meals = try? modelContext.fetch(mealDescriptor) {
            for meal in meals {
                modelContext.delete(meal)
            }
        }

        // 症状記録を削除
        let symptomDescriptor = FetchDescriptor<SymptomRecord>()
        if let symptoms = try? modelContext.fetch(symptomDescriptor) {
            for symptom in symptoms {
                modelContext.delete(symptom)
            }
        }

        try? modelContext.save()
    }
}
