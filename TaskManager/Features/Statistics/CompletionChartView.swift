import SwiftUI
import Charts

struct CompletionChartView: View {
    let data: [StatisticsViewModel.DayStat]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Активность за 14 дней")
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)

            if data.allSatisfy({ $0.total == 0 }) {
                Text("Нет данных за этот период")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                Chart {
                    ForEach(data) { stat in
                        BarMark(
                            x: .value("Дата", stat.date, unit: .day),
                            y: .value("Выполнено", stat.completed)
                        )
                        .foregroundStyle(AppColors.green)
                        .cornerRadius(4)

                        BarMark(
                            x: .value("Дата", stat.date, unit: .day),
                            y: .value("Не выполнено", stat.failed)
                        )
                        .foregroundStyle(AppColors.red)
                        .cornerRadius(4)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 2)) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(shortDate(date))
                                    .font(.caption2)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(AppColors.cardStroke)
                        AxisValueLabel()
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .frame(height: 180)
            }
        }
        .cardStyle()
    }

    private func shortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d.MM"
        return f.string(from: date)
    }
}
