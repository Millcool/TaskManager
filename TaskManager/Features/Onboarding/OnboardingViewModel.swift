import Foundation

@Observable
final class OnboardingViewModel {
    var currentPage = 0
    let totalPages = 2

    var isLastPage: Bool {
        currentPage == totalPages - 1
    }

    func nextPage() {
        if currentPage < totalPages - 1 {
            currentPage += 1
        }
    }

    func requestNotifications() async -> Bool {
        await NotificationService.shared.requestPermission()
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")

        // Set default notification settings
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "notification_daily_enabled")
        defaults.set(true, forKey: "notification_weekly_enabled")
        defaults.set(true, forKey: "notification_monthly_enabled")
        defaults.set(true, forKey: "notification_yearly_enabled")
        defaults.set(23, forKey: "notification_daily_hour")
        defaults.set(50, forKey: "notification_daily_minute")
        defaults.set(11, forKey: "notification_weekly_hour")
        defaults.set(11, forKey: "notification_monthly_hour")
        defaults.set(11, forKey: "notification_yearly_hour")

        NotificationService.shared.rescheduleAllSystemNotifications()
    }
}
