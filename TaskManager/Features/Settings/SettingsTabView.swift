import SwiftUI

struct SettingsTabView: View {
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // Appearance section
                    NavigationLink(destination: AppearanceSettingsView()) {
                        settingsRow(
                            icon: "paintbrush.fill",
                            title: "Оформление",
                            subtitle: "Тема приложения"
                        )
                    }

                    // Notifications section
                    NavigationLink(destination: NotificationSettingsView(viewModel: viewModel)) {
                        settingsRow(
                            icon: "bell.fill",
                            title: "Уведомления",
                            subtitle: "Настройка напоминаний для планирования"
                        )
                    }

                    // Categories section
                    NavigationLink(destination: CategoryManagementView()) {
                        settingsRow(
                            icon: "folder.fill",
                            title: "Категории",
                            subtitle: "Управление категориями целей"
                        )
                    }

                    // Backup section
                    NavigationLink(destination: BackupSettingsView()) {
                        settingsRow(
                            icon: "icloud.and.arrow.up.fill",
                            title: "Бэкапы",
                            subtitle: "iCloud, Telegram, автосохранение"
                        )
                    }

                    // Data section
                    NavigationLink(destination: DataManagementView()) {
                        settingsRow(
                            icon: "externaldrive.fill",
                            title: "Данные",
                            subtitle: "Экспорт и удаление данных"
                        )
                    }

                    // App info
                    VStack(spacing: 8) {
                        Text("Task Manager")
                            .font(.headline)
                            .foregroundStyle(AppColors.textPrimary)
                        Text("Версия 1.0")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .padding(.top, 32)
                }
                .padding(AppTheme.horizontalPadding)
            }
            .background(AppColors.background)
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func settingsRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppColors.accent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppColors.neutral)
        }
        .cardStyle()
    }
}
