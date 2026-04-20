import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID = UUID()
    var name: String = ""
    var goalDescription: String = ""
    var periodRaw: String = GoalPeriod.day.rawValue
    var periodStartDate: Date = Date()
    var priorityRaw: String = GoalPriority.medium.rawValue
    var statusRaw: String = GoalStatus.new.rawValue
    var colorHex: String = "#8B5CF6"
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var sortOrder: Int = 0
    var estimatedMinutes: Int? = nil

    var category: Category?

    @Relationship(inverse: \Goal.children)
    var parent: Goal?

    @Relationship(deleteRule: .nullify)
    var children: [Goal]?

    @Relationship(deleteRule: .cascade, inverse: \GoalReminder.goal)
    var reminders: [GoalReminder]?

    var period: GoalPeriod {
        get { GoalPeriod(rawValue: periodRaw) ?? .day }
        set { periodRaw = newValue.rawValue }
    }

    var priority: GoalPriority {
        get { GoalPriority(rawValue: priorityRaw) ?? .medium }
        set { priorityRaw = newValue.rawValue }
    }

    var status: GoalStatus {
        get { GoalStatus(rawValue: statusRaw) ?? .new }
        set {
            statusRaw = newValue.rawValue
            updatedAt = Date()
        }
    }

    init(
        name: String,
        goalDescription: String = "",
        period: GoalPeriod,
        periodStartDate: Date,
        priority: GoalPriority = .medium,
        colorHex: String = "#8B5CF6",
        category: Category? = nil,
        parent: Goal? = nil,
        sortOrder: Int = 0,
        estimatedMinutes: Int? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.goalDescription = goalDescription
        self.periodRaw = period.rawValue
        self.periodStartDate = periodStartDate
        self.priorityRaw = priority.rawValue
        self.statusRaw = GoalStatus.new.rawValue
        self.colorHex = colorHex
        self.category = category
        self.parent = parent
        self.sortOrder = sortOrder
        self.estimatedMinutes = estimatedMinutes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
