import SwiftUI
import SwiftData

struct StatisticsTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = StatisticsViewModel()
    @State private var showDateFilter = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Date filter toggle
                    Button {
                        withAnimation { showDateFilter.toggle() }
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                            Text(dateRangeText)
                            Spacer()
                            Image(systemName: showDateFilter ? "chevron.up" : "chevron.down")
                                .font(.caption)
                        }
                        .font(.subheadline)
                        .foregroundStyle(AppColors.accent)
                        .padding(12)
                        .background(AppColors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    }

                    if showDateFilter {
                        DateRangePickerView(
                            startDate: Binding(
                                get: { viewModel.startDate },
                                set: { viewModel.startDate = $0; viewModel.refresh() }
                            ),
                            endDate: Binding(
                                get: { viewModel.endDate },
                                set: { viewModel.endDate = $0; viewModel.refresh() }
                            )
                        )
                    }

                    // Summary cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        StatCardView(
                            title: "Всего",
                            value: "\(viewModel.totalGoals)",
                            color: AppColors.accent
                        )
                        StatCardView(
                            title: "Выполнено",
                            value: "\(viewModel.completedGoals)",
                            color: AppColors.green
                        )
                        StatCardView(
                            title: "Не выполнено",
                            value: "\(viewModel.failedGoals)",
                            color: AppColors.red
                        )
                        StatCardView(
                            title: "% выполнения",
                            value: String(format: "%.0f%%", viewModel.completionRate),
                            color: AppColors.accent
                        )
                    }

                    // Chart
                    CompletionChartView(data: viewModel.dailyStats)

                    // Period breakdown
                    PeriodBreakdownView(stats: viewModel.periodStats)
                }
                .padding(AppTheme.horizontalPadding)
            }
            .background(AppColors.background)
            .navigationTitle("Статистика")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
        }
    }

    private var dateRangeText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMM"
        return "\(f.string(from: viewModel.startDate)) — \(f.string(from: viewModel.endDate))"
    }
}
