import SwiftUI
import Charts

struct FODMAPChartView: View {
    let data: [AnalysisViewModel.DailyFODMAP]

    var body: some View {
        if data.allSatisfy({ $0.maxLevel == 0 }) {
            ContentUnavailableView(
                "データがありません",
                systemImage: "chart.bar",
                description: Text("食事を記録するとチャートが表示されます")
            )
        } else {
            Chart(data) { item in
                BarMark(
                    x: .value("日付", item.date, unit: .day),
                    y: .value("レベル", item.maxLevel)
                )
                .foregroundStyle(by: .value("カテゴリ", item.category.rawValue))
                .position(by: .value("カテゴリ", item.category.rawValue))
            }
            .chartForegroundStyleScale([
                "フルクタン": ColorTheme.fodmapHigh,
                "GOS": ColorTheme.fodmapMedium,
                "乳糖": Color.blue,
                "フルクトース": Color.orange,
                "ポリオール": Color.purple
            ])
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(dayLabel(date))
                                .font(.caption2)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: [0, 1, 2]) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text(["低", "中", "高"][v])
                                .font(.caption2)
                        }
                    }
                }
            }
            .chartYScale(domain: 0...2)
            .chartLegend(position: .bottom, spacing: 8)
        }
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "d日"
        return formatter.string(from: date)
    }
}
