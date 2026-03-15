import Foundation
import SwiftData

@Model
final class GoalReminder {
    var id: UUID = UUID()
    var reminderDate: Date = Date()
    var notificationIdentifier: String = ""
    var isActive: Bool = true

    @Relationship
    var goal: Goal?

    init(reminderDate: Date, goal: Goal? = nil) {
        self.id = UUID()
        self.reminderDate = reminderDate
        self.notificationIdentifier = UUID().uuidString
        self.isActive = true
        self.goal = goal
    }
}
