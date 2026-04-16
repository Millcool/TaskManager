import SwiftUI
import SwiftData

struct BackupSettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var isICloudEnabled: Bool = BackupCoordinator.shared.isICloudEnabled
    @State private var isTelegramEnabled: Bool = TelegramBackupService.isEnabled
    @State private var telegramToken: String = TelegramBackupService.botToken ?? ""
    @State private var telegramChatId: String = TelegramBackupService.chatId ?? ""

    @State private var lastBackupDate: Date? = BackupCoordinator.shared.lastBackupDate
    @State private var lastBackupStatus: String? = BackupCoordinator.shared.lastBackupStatus

    @State private var isRunningBackup = false
    @State private var backupResultMessage: String?
    @State private var showBackupResult = false

    @State private var isTesting = false
    @State private var testResultMessage: String?
    @State private var showTestResult = false

    @State private var showBackupList = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                statusCard
                iCloudSection
                telegramSection
                actionsSection
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle("Бэкапы")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Бэкап", isPresented: $showBackupResult) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(backupResultMessage ?? "")
        }
        .alert("Telegram", isPresented: $showTestResult) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(testResultMessage ?? "")
        }
        .sheet(isPresented: $showBackupList) {
            BackupListView()
        }
    }

    // MARK: - Status

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Последний бэкап")
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)

            if let date = lastBackupDate {
                Text(formatted(date))
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textPrimary)
            } else {
                Text("Ещё не запускался")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }

            if let status = lastBackupStatus, !status.isEmpty {
                Text(status)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    // MARK: - iCloud

    private var iCloudSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "icloud.fill")
                    .foregroundStyle(AppColors.accent)
                Text("iCloud Drive")
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Toggle("", isOn: $isICloudEnabled)
                    .tint(AppColors.accent)
                    .onChange(of: isICloudEnabled) { _, newValue in
                        BackupCoordinator.shared.isICloudEnabled = newValue
                    }
            }

            Text(iCloudStatusText)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)

            if !BackupFileManager.isICloudAvailable {
                Label("iCloud недоступен на устройстве", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(AppColors.red)
            }
        }
        .cardStyle()
    }

    private var iCloudStatusText: String {
        if BackupFileManager.isICloudAvailable {
            return "Бэкапы сохраняются в iCloud Drive в папке TaskManager/Backups. Переживают удаление приложения."
        } else {
            return "Бесплатный аккаунт разработчика не позволяет использовать iCloud Drive. Бэкапы сохраняются локально в папке приложения (видна в Files). Используйте Telegram для надёжного удалённого бэкапа."
        }
    }

    // MARK: - Telegram

    private var telegramSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(AppColors.accent)
                Text("Telegram бот")
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Toggle("", isOn: $isTelegramEnabled)
                    .tint(AppColors.accent)
                    .onChange(of: isTelegramEnabled) { _, newValue in
                        TelegramBackupService.isEnabled = newValue
                    }
            }

            Text("Создайте бота через @BotFather в Telegram, получите токен. Узнайте свой chat_id через @userinfobot.")
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)

            VStack(alignment: .leading, spacing: 6) {
                Text("Токен бота")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                SecureField("123456789:ABCdefGHI...", text: $telegramToken)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(AppColors.background)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onChange(of: telegramToken) { _, newValue in
                        TelegramBackupService.botToken = newValue
                    }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Chat ID")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                TextField("123456789", text: $telegramChatId)
                    .textFieldStyle(.plain)
                    .keyboardType(.numbersAndPunctuation)
                    .padding(10)
                    .background(AppColors.background)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onChange(of: telegramChatId) { _, newValue in
                        TelegramBackupService.chatId = newValue
                    }
            }

            Button {
                testTelegram()
            } label: {
                HStack {
                    if isTesting {
                        ProgressView().scaleEffect(0.8)
                    } else {
                        Image(systemName: "checkmark.circle")
                    }
                    Text("Проверить подключение")
                }
                .fontWeight(.medium)
                .foregroundStyle(AppColors.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(AppColors.background)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
            }
            .disabled(isTesting || telegramToken.isEmpty || telegramChatId.isEmpty)
        }
        .cardStyle()
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                runBackupNow()
            } label: {
                HStack {
                    if isRunningBackup {
                        ProgressView().scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.clockwise.icloud.fill")
                    }
                    Text("Сделать бэкап сейчас")
                }
                .accentButtonStyle()
            }
            .disabled(isRunningBackup)

            Button {
                showBackupList = true
            } label: {
                Label("Список бэкапов и восстановление", systemImage: "clock.arrow.circlepath")
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
            }
        }
    }

    // MARK: - Actions

    private func runBackupNow() {
        isRunningBackup = true
        Task { @MainActor in
            let result = await BackupCoordinator.shared.runBackup(context: modelContext)
            lastBackupDate = result.timestamp
            lastBackupStatus = BackupCoordinator.shared.lastBackupStatus

            var parts: [String] = []
            if result.localURL != nil { parts.append("✓ Локально") }
            if result.iCloudURL != nil { parts.append("✓ iCloud Drive") }
            if result.telegramSucceeded { parts.append("✓ Telegram") }
            if let err = result.telegramError { parts.append("✗ Telegram: \(err)") }
            backupResultMessage = parts.isEmpty
                ? "Нет активных каналов бэкапа. Включите хотя бы один."
                : parts.joined(separator: "\n")
            showBackupResult = true
            isRunningBackup = false
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }

    private func testTelegram() {
        isTesting = true
        Task { @MainActor in
            do {
                try await TelegramBackupService.testConnection()
                testResultMessage = "✅ Тестовое сообщение отправлено. Проверьте ваш чат с ботом."
            } catch {
                testResultMessage = "❌ \(error.localizedDescription)"
            }
            showTestResult = true
            isTesting = false
        }
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: date)
    }
}
