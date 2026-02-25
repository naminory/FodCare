import SwiftUI
import Charts

// 症状スコア折れ線グラフ
struct SymptomChartView: View {
    let data: [AnalysisViewModel.DailySymptom]

    var body: some View {
        if data.allSatisfy({ $0.score == 0 }) {
            ContentUnavailableView(
                "データがありません",
                systemImage: "chart.line.uptrend.xyaxis",
                description: Text("症状を記録するとチャートが表示されます")
            )
        } else {
            Chart(data) { item in
                LineMark(
                    x: .value("日付", item.date, unit: .day),
                    y: .value("スコア", item.score)
                )
                .foregroundStyle(ColorTheme.primary)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("日付", item.date, unit: .day),
                    y: .value("スコア", item.score)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [ColorTheme.primary.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("日付", item.date, unit: .day),
                    y: .value("スコア", item.score)
                )
                .foregroundStyle(ColorTheme.primary)
                .symbolSize(item.score > 0 ? 30 : 0)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(dayLabel(date))
                                .font(.caption2)
                        }
                    }
                }
            }
            .chartYScale(domain: 0...15)
            .chartYAxis {
                AxisMarks(values: [0, 5, 10, 15]) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}
