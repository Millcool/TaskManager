import Foundation

@Observable
final class SettingsViewModel {
    // Daily notification
    var dailyEnabled: Bool {
        didSet {
            UserDefaults.standard.set(dailyEnabled, forKey: "notification_daily_enabled")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }
    var dailyTime: Date {
        didSet {
            let components = Calendar.current.dateComponents([.hour, .minute], from: dailyTime)
            UserDefaults.standard.set(components.hour ?? 23, forKey: "notification_daily_hour")
            UserDefaults.standard.set(components.minute ?? 50, forKey: "notification_daily_minute")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }

    // Weekly notification
    var weeklyEnabled: Bool {
        didSet {
            UserDefaults.standard.set(weeklyEnabled, forKey: "notification_weekly_enabled")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }
    var weeklyTime: Date {
        didSet {
            let components = Calendar.current.dateComponents([.hour, .minute], from: weeklyTime)
            UserDefaults.standard.set(components.hour ?? 11, forKey: "notification_weekly_hour")
            UserDefaults.standard.set(components.minute ?? 0, forKey: "notification_weekly_minute")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }

    // Monthly notification
    var monthlyEnabled: Bool {
        didSet {
            UserDefaults.standard.set(monthlyEnabled, forKey: "notification_monthly_enabled")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }
    var monthlyTime: Date {
        didSet {
            let components = Calendar.current.dateComponents([.hour, .minute], from: monthlyTime)
            UserDefaults.standard.set(components.hour ?? 11, forKey: "notification_monthly_hour")
            UserDefaults.standard.set(components.minute ?? 0, forKey: "notification_monthly_minute")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }

    // Yearly notification
    var yearlyEnabled: Bool {
        didSet {
            UserDefaults.standard.set(yearlyEnabled, forKey: "notification_yearly_enabled")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }
    var yearlyTime: Date {
        didSet {
            let components = Calendar.current.dateComponents([.hour, .minute], from: yearlyTime)
            UserDefaults.standard.set(components.hour ?? 11, forKey: "notification_yearly_hour")
            UserDefaults.standard.set(components.minute ?? 0, forKey: "notification_yearly_minute")
            NotificationService.shared.rescheduleAllSystemNotifications()
        }
    }

    init() {
        let defaults = UserDefaults.standard

        // Load saved state or defaults
        self.dailyEnabled = defaults.object(forKey: "notification_daily_enabled") as? Bool ?? true
        self.weeklyEnabled = defaults.object(forKey: "notification_weekly_enabled") as? Bool ?? true
        self.monthlyEnabled = defaults.object(forKey: "notification_monthly_enabled") as? Bool ?? true
        self.yearlyEnabled = defaults.object(forKey: "notification_yearly_enabled") as? Bool ?? true

        // Build dates from saved hours/minutes
        func timeDate(hourKey: String, minuteKey: String, defaultHour: Int, defaultMinute: Int) -> Date {
            let h = defaults.object(forKey: hourKey) as? Int ?? defaultHour
            let m = defaults.object(forKey: minuteKey) as? Int ?? defaultMinute
            var components = DateComponents()
            components.hour = h
            components.minute = m
            return Calendar.current.date(from: components) ?? Date()
        }

        self.dailyTime = timeDate(hourKey: "notification_daily_hour", minuteKey: "notification_daily_minute", defaultHour: 23, defaultMinute: 50)
        self.weeklyTime = timeDate(hourKey: "notification_weekly_hour", minuteKey: "notification_weekly_minute", defaultHour: 11, defaultMinute: 0)
        self.monthlyTime = timeDate(hourKey: "notification_monthly_hour", minuteKey: "notification_monthly_minute", defaultHour: 11, defaultMinute: 0)
        self.yearlyTime = timeDate(hourKey: "notification_yearly_hour", minuteKey: "notification_yearly_minute", defaultHour: 11, defaultMinute: 0)
    }
}
