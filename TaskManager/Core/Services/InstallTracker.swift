import Foundation
import UserNotifications

enum InstallTracker {
    static let totalDuration: TimeInterval = 7 * 24 * 60 * 60
    static let warningThreshold: TimeInterval = 24 * 60 * 60

    private static let notificationIdentifier = "install_expiration_warning"

    static var installDate: Date {
        guard let execPath = Bundle.main.executablePath,
              let attrs = try? FileManager.default.attributesOfItem(atPath: execPath),
              let date = attrs[.modificationDate] as? Date else {
            return Date()
        }
        return date
    }

    static var expirationDate: Date {
        installDate.addingTimeInterval(totalDuration)
    }

    static func remainingTime(from reference: Date = Date()) -> TimeInterval {
        max(0, expirationDate.timeIntervalSince(reference))
    }

    static func isInLastDay(from reference: Date = Date()) -> Bool {
        let remaining = remainingTime(from: reference)
        return remaining > 0 && remaining <= warningThreshold
    }

    static func isExpired(from reference: Date = Date()) -> Bool {
        remainingTime(from: reference) <= 0
    }

    static func scheduleExpirationNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])

        let fireDate = expirationDate.addingTimeInterval(-warningThreshold)
        guard fireDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Осталось 24 часа"
        content.body = "Приложение будет удалено через сутки. Пересоберите и установите его заново, чтобы не потерять данные."
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: fireDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }
}
