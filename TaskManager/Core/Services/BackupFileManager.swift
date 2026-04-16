import Foundation

enum BackupFileManager {
    static let backupsFolderName = "Backups"
    static let maxLocalBackups = 30

    struct BackupFile: Identifiable, Hashable {
        let id: String
        let url: URL
        let date: Date
        let sizeBytes: Int
        let location: Location

        enum Location: String {
            case local
            case iCloud
        }
    }

    // MARK: - Destinations

    static func localBackupsFolder() -> URL? {
        let fm = FileManager.default
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let folder = docs.appendingPathComponent(backupsFolderName, isDirectory: true)
        if !fm.fileExists(atPath: folder.path) {
            try? fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    static func iCloudBackupsFolder() -> URL? {
        let fm = FileManager.default
        guard let container = fm.url(forUbiquityContainerIdentifier: nil) else { return nil }
        let folder = container
            .appendingPathComponent("Documents", isDirectory: true)
            .appendingPathComponent(backupsFolderName, isDirectory: true)
        if !fm.fileExists(atPath: folder.path) {
            try? fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    static var isICloudAvailable: Bool {
        FileManager.default.ubiquityIdentityToken != nil &&
        FileManager.default.url(forUbiquityContainerIdentifier: nil) != nil
    }

    // MARK: - Write

    static func filename(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return "taskmanager-backup-\(formatter.string(from: date)).json"
    }

    @discardableResult
    static func writeLocal(data: Data, name: String? = nil) -> URL? {
        guard let folder = localBackupsFolder() else { return nil }
        let fileName = name ?? filename()
        let url = folder.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: [.atomic])
            pruneLocalBackups()
            return url
        } catch {
            return nil
        }
    }

    @discardableResult
    static func writeICloud(data: Data, name: String? = nil) -> URL? {
        guard let folder = iCloudBackupsFolder() else { return nil }
        let fileName = name ?? filename()
        let url = folder.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: [.atomic])
            return url
        } catch {
            return nil
        }
    }

    // MARK: - Listing

    static func listBackups() -> [BackupFile] {
        var results: [BackupFile] = []
        if let local = localBackupsFolder() {
            results.append(contentsOf: listFiles(in: local, location: .local))
        }
        if let cloud = iCloudBackupsFolder() {
            results.append(contentsOf: listFiles(in: cloud, location: .iCloud))
        }
        return results.sorted(by: { $0.date > $1.date })
    }

    private static func listFiles(in folder: URL, location: BackupFile.Location) -> [BackupFile] {
        let fm = FileManager.default
        guard let items = try? fm.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }
        return items.compactMap { url in
            guard url.pathExtension.lowercased() == "json" else { return nil }
            let values = try? url.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
            let date = values?.contentModificationDate ?? Date.distantPast
            let size = values?.fileSize ?? 0
            return BackupFile(
                id: url.path,
                url: url,
                date: date,
                sizeBytes: size,
                location: location
            )
        }
    }

    // MARK: - Delete

    static func delete(_ backup: BackupFile) {
        try? FileManager.default.removeItem(at: backup.url)
    }

    private static func pruneLocalBackups() {
        let list = listBackups().filter { $0.location == .local }
        guard list.count > maxLocalBackups else { return }
        let toDelete = list.suffix(list.count - maxLocalBackups)
        for item in toDelete {
            try? FileManager.default.removeItem(at: item.url)
        }
    }

    // MARK: - Read

    static func readData(_ backup: BackupFile) -> Data? {
        try? Data(contentsOf: backup.url)
    }
}
