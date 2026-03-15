import Foundation
import SwiftData

@Observable
final class StatisticsViewModel {
    var totalGoals: Int = 0
    var completedGoals: Int = 0
    var failedGoals: Int = 0
    var newGoals: Int = 0
    var completionRate: Double = 0

    var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    var endDate: Date = Date()

    struct PeriodStat: Identifiable {
        let id = UUID()
        let period: GoalPeriod
        let total: Int
        let completed: Int
        let failed: Int
    }

    struct DayStat: Identifiable {
        let id = UUID()
        let date: Date
        let completed: Int
        let failed: Int
        let total: Int
    }

    var periodStats: [PeriodStat] = []
    var dailyStats: [DayStat] = []

    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        refresh()
    }

    func refresh() {
        guard let modelContext else { return }

        let start = startDate.startOfDay
        let end = endDate.endOfDay

        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate<Goal> {
                $0.createdAt >= start && $0.createdAt <= end
            }
        )

        guard let goals = try? modelContext.fetch(descriptor) else { return }

        totalGoals = goals.count
        completedGoals = goals.filter { $0.status == .completed }.count
        failedGoals = goals.filter { $0.status == .failed }.count
        newGoals = goals.filter { $0.status == .new }.count
        completionRate = totalGoals > 0 ? Double(completedGoals) / Double(totalGoals) * 100 : 0

        // Period stats
        periodStats = GoalPeriod.allCases.map { period in
            let periodGoals = goals.filter { $0.period == period }
            return PeriodStat(
                period: period,
                total: periodGoals.count,
                completed: periodGoals.filter { $0.status == .completed }.count,
                failed: periodGoals.filter { $0.status == .failed }.count
            )
        }

        // Daily stats (last 14 days from endDate)
        let cal = Calendar.current
        var dailyData: [DayStat] = []
        for i in (0..<14).reversed() {
            guard let date = cal.date(byAdding: .day, value: -i, to: endDate) else { continue }
            let dayStart = date.startOfDay
            let dayEnd = date.endOfDay
            let dayGoals = goals.filter { $0.createdAt >= dayStart && $0.createdAt <= dayEnd }
            dailyData.append(DayStat(
                date: dayStart,
                completed: dayGoals.filter { $0.status == .completed }.count,
                failed: dayGoals.filter { $0.status == .failed }.count,
                total: dayGoals.count
            ))
        }
        dailyStats = dailyData
    }
}
