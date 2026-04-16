import Foundation
import BackgroundTasks
import SwiftData

enum BackupScheduler {
    static let taskIdentifier = "com.ilamironov.taskmanager.dailyBackup"

    static func register(modelContainer: ModelContainer) {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: taskIdentifier,
            using: nil
        ) { task in
            guard let task = task as? BGAppRefreshTask else { return }
            handle(task: task, container: modelContainer)
        }
    }

    static func scheduleNext() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 20, to: Date())
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            // Ignore — will retry next launch
        }
    }

    private static func handle(task: BGAppRefreshTask, container: ModelContainer) {
        scheduleNext()

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        Task { @MainActor in
            let context = ModelContext(container)
            _ = await BackupCoordinator.shared.runBackup(context: context)
            task.setTaskCompleted(success: true)
        }
    }

    /// Runs a backup if more than 20 hours passed since last one.
    /// Called on app foreground as a fallback when BGTask doesn't fire.
    @MainActor
    static func runIfDue(container: ModelContainer) async {
        let lastDate = BackupCoordinator.shared.lastBackupDate ?? .distantPast
        let interval = Date().timeIntervalSince(lastDate)
        guard interval > 20 * 3600 else { return }
        let context = ModelContext(container)
        _ = await BackupCoordinator.shared.runBackup(context: context)
    }
}
