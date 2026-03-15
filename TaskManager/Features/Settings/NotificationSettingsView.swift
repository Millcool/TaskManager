import SwiftUI

struct NotificationSettingsView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                notificationCard(
                    title: "Ежедневное",
                    subtitle: "Напоминание запланировать цели на завтра",
                    isEnabled: $viewModel.dailyEnabled,
                    time: $viewModel.dailyTime
                )

                notificationCard(
                    title: "Еженедельное",
                    subtitle: "Планирование целей на следующую неделю (воскресенье)",
                    isEnabled: $viewModel.weeklyEnabled,
                    time: $viewModel.weeklyTime
                )

                notificationCard(
                    title: "Ежемесячное",
                    subtitle: "Планирование целей на следующий месяц (1-е число)",
                    isEnabled: $viewModel.monthlyEnabled,
                    time: $viewModel.monthlyTime
                )

                notificationCard(
                    title: "Ежегодное",
                    subtitle: "Планирование целей на следующий год (1 января)",
                    isEnabled: $viewModel.yearlyEnabled,
                    time: $viewModel.yearlyTime
                )
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle("Уведомления")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func notificationCard(
        title: String,
        subtitle: String,
        isEnabled: Binding<Bool>,
        time: Binding<Date>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: isEnabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .tint(AppColors.accent)

            if isEnabled.wrappedValue {
                HStack {
                    Text("Время")
                        .foregroundStyle(AppColors.textSecondary)
                    Spacer()
                    DatePicker("", selection: time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .tint(AppColors.accent)
                }
            }
        }
        .cardStyle()
    }
}
