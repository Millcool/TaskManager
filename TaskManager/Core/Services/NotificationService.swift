import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    // MARK: - Permission

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    // MARK: - System Notifications

    func rescheduleAllSystemNotifications() {
        let defaults = UserDefaults.standard

        // Cancel old system notifications
        let systemIds = ["daily_planning", "weekly_planning", "monthly_planning", "yearly_planning"]
        center.removePendingNotificationRequests(withIdentifiers: systemIds)

        // Daily
        if defaults.bool(forKey: "notification_daily_enabled") {
            let hour = defaults.integer(forKey: "notification_daily_hour")
            let minute = defaults.integer(forKey: "notification_daily_minute")
            let h = hour == 0 && minute == 0 ? 23 : hour
            let m = hour == 0 && minute == 0 ? 50 : minute
            scheduleRepeating(
                id: "daily_planning",
                title: "Планирование дня",
                body: "Пора запланировать цели на завтра",
                hour: h, minute: m,
                weekday: nil
            )
        }

        // Weekly
        if defaults.bool(forKey: "notification_weekly_enabled") {
            let hour = defaults.integer(forKey: "notification_weekly_hour")
            let minute = defaults.integer(forKey: "notification_weekly_minute")
            let h = hour == 0 && minute == 0 ? 11 : hour
            scheduleRepeating(
                id: "weekly_planning",
                title: "Планирование недели",
                body: "Пора запланировать цели на следующую неделю",
                hour: h, minute: minute,
                weekday: 1 // Sunday
            )
        }

        // Monthly
        if defaults.bool(forKey: "notification_monthly_enabled") {
            let hour = defaults.integer(forKey: "notification_monthly_hour")
            let minute = defaults.integer(forKey: "notification_monthly_minute")
            let h = hour == 0 && minute == 0 ? 11 : hour
            scheduleMonthly(
                id: "monthly_planning",
                title: "Планирование месяца",
                body: "Пора запланировать цели на следующий месяц",
                day: 1, hour: h, minute: minute
            )
        }

        // Yearly
        if defaults.bool(forKey: "notification_yearly_enabled") {
            let hour = defaults.integer(forKey: "notification_yearly_hour")
            let minute = defaults.integer(forKey: "notification_yearly_minute")
            let h = hour == 0 && minute == 0 ? 11 : hour
            scheduleYearly(
                id: "yearly_planning",
                title: "Планирование года",
                body: "Пора запланировать цели на следующий год",
                month: 1, day: 1, hour: h, minute: minute
            )
        }
    }

    // MARK: - Goal Reminders

    func scheduleGoalReminder(_ reminder: GoalReminder, goalName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body = goalName
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminder.reminderDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: reminder.notificationIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - PhD Application Start

    private static let phdApplicationIdPrefix = "phd_app_start_"

    func reschedulePhdApplicationStartNotifications(
        programs: [PhdProgram],
        store: PhdApplicationStore = .shared,
        universityLookup: @escaping (PhdProgram) -> University? = { PhdProgramsDataProvider.university(for: $0) }
    ) {
        center.getPendingNotificationRequests { [center] requests in
            let toRemove = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.phdApplicationIdPrefix) }
            if !toRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: toRemove)
            }

            let now = Date()
            for program in programs {
                guard store.status(for: program.id) == .notApplied else { continue }
                guard let start = PhdDateParser.date(from: program.applicationStartDate, reference: now) else { continue }
                let triggerDate = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: start) ?? start
                guard triggerDate > now else { continue }

                let content = UNMutableNotificationContent()
                let uniName = universityLookup(program)?.shortName ?? "вуз"
                content.title = "Открыт приём документов"
                content.body = "\(uniName): «\(program.name)». Приём до \(program.applicationEndDate)."
                content.sound = .default

                let components = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: triggerDate
                )
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                let request = UNNotificationRequest(
                    identifier: Self.phdApplicationIdPrefix + program.id.uuidString,
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    // MARK: - Private

    private func scheduleRepeating(id: String, title: String, body: String, hour: Int, minute: Int, weekday: Int?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        if let weekday {
            components.weekday = weekday
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }

    private func scheduleMonthly(id: String, title: String, body: String, day: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var components = DateComponents()
        components.day = day
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }

    private func scheduleYearly(id: String, title: String, body: String, month: Int, day: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var components = DateComponents()
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }
}
