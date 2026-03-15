import SwiftUI

struct PeriodBreakdownView: View {
    let stats: [StatisticsViewModel.PeriodStat]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("По периодам")
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)

            ForEach(stats) { stat in
                if stat.total > 0 {
                    VStack(spacing: 8) {
                        HStack {
                            Text(stat.period.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(AppColors.textPrimary)
                            Spacer()
                            Text("\(stat.completed)/\(stat.total)")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.neutral.opacity(0.3))
                                    .frame(height: 8)

                                if stat.total > 0 {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(AppColors.green)
                                        .frame(
                                            width: geo.size.width * CGFloat(stat.completed) / CGFloat(stat.total),
                                            height: 8
                                        )
                                }
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }

            if stats.allSatisfy({ $0.total == 0 }) {
                Text("Нет данных")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .cardStyle()
    }
}
