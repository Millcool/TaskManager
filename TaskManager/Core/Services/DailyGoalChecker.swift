import Foundation
import SwiftData

enum DailyGoalChecker {
    static func hasDailyGoals(on date: Date, container: ModelContainer) -> Bool {
        let context = ModelContext(container)
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return false }
        let dayPeriod = GoalPeriod.day.rawValue
        let descriptor = FetchDescriptor<Goal>(predicate: #Predicate { goal in
            goal.periodRaw == dayPeriod && goal.periodStartDate >= start && goal.periodStartDate < end
        })
        return ((try? context.fetchCount(descriptor)) ?? 0) > 0
    }
}
