import Foundation
import SwiftData

@MainActor
final class BackupCoordinator {
    static let shared = BackupCoordinator()

    enum Key {
        static let iCloudEnabled = "backup_icloud_enabled"
        static let lastBackupDate = "backup_last_date"
        static let lastBackupStatus = "backup_last_status"
    }

    struct RunResult {
        let localURL: URL?
        let iCloudURL: URL?
        let telegramSucceeded: Bool
        let telegramError: String?
        let timestamp: Date
    }

    var isICloudEnabled: Bool {
        get { UserDefaults.standard.object(forKey: Key.iCloudEnabled) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: Key.iCloudEnabled) }
    }

    var lastBackupDate: Date? {
        UserDefaults.standard.object(forKey: Key.lastBackupDate) as? Date
    }

    var lastBackupStatus: String? {
        UserDefaults.standard.string(forKey: Key.lastBackupStatus)
    }

    func runBackup(context: ModelContext) async -> RunResult {
        guard let data = DataExportService.exportGoals(from: context) else {
            let status = "Ошибка: не удалось сериализовать данные"
            UserDefaults.standard.set(status, forKey: Key.lastBackupStatus)
            return RunResult(
                localURL: nil,
                iCloudURL: nil,
                telegramSucceeded: false,
                telegramError: "Нет данных для бэкапа",
                timestamp: Date()
            )
        }

        let filename = BackupFileManager.filename()
        let localURL = BackupFileManager.writeLocal(data: data, name: filename)

        var iCloudURL: URL? = nil
        if isICloudEnabled && BackupFileManager.isICloudAvailable {
            iCloudURL = BackupFileManager.writeICloud(data: data, name: filename)
        }

        var telegramSucceeded = false
        var telegramError: String? = nil

        if TelegramBackupService.isEnabled && TelegramBackupService.isConfigured {
            do {
                let dateString = DateFormatter.localizedString(
                    from: Date(),
                    dateStyle: .medium,
                    timeStyle: .short
                )
                try await TelegramBackupService.sendBackup(
                    data: data,
                    filename: filename,
                    caption: "Task Manager — бэкап \(dateString)"
                )
                telegramSucceeded = true
            } catch {
                telegramError = error.localizedDescription
            }
        }

        let now = Date()
        UserDefaults.standard.set(now, forKey: Key.lastBackupDate)

        var parts: [String] = []
        if localURL != nil { parts.append("локально") }
        if iCloudURL != nil { parts.append("iCloud") }
        if telegramSucceeded { parts.append("Telegram") }
        if let err = telegramError { parts.append("Telegram ошибка: \(err)") }
        let status = parts.isEmpty ? "Нет активных каналов бэкапа" : parts.joined(separator: ", ")
        UserDefaults.standard.set(status, forKey: Key.lastBackupStatus)

        return RunResult(
            localURL: localURL,
            iCloudURL: iCloudURL,
            telegramSucceeded: telegramSucceeded,
            telegramError: telegramError,
            timestamp: now
        )
    }

    func restore(from backup: BackupFileManager.BackupFile, context: ModelContext) throws {
        guard let data = BackupFileManager.readData(backup) else {
            throw DataExportService.ImportError.decodingFailed
        }
        try DataExportService.importGoals(from: data, into: context)
    }

    func hasAnyBackup() -> Bool {
        !BackupFileManager.listBackups().isEmpty
    }

    func latestBackup() -> BackupFileManager.BackupFile? {
        BackupFileManager.listBackups().first
    }
}
