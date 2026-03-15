import Foundation
import SwiftData

enum DataExportService {
    struct ExportedGoal: Codable {
        let id: String
        let name: String
        let description: String
        let period: String
        let periodStartDate: String
        let priority: String
        let status: String
        let colorHex: String
        let categoryName: String?
        let parentGoalName: String?
        let createdAt: String
        let updatedAt: String
    }

    struct ExportData: Codable {
        let exportDate: String
        let goals: [ExportedGoal]
    }

    static func exportGoals(from context: ModelContext) -> Data? {
        let descriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.createdAt)])
        guard let goals = try? context.fetch(descriptor) else { return nil }

        let formatter = ISO8601DateFormatter()

        let exportedGoals = goals.map { goal in
            ExportedGoal(
                id: goal.id.uuidString,
                name: goal.name,
                description: goal.goalDescription,
                period: goal.period.rawValue,
                periodStartDate: formatter.string(from: goal.periodStartDate),
                priority: goal.priority.rawValue,
                status: goal.status.rawValue,
                colorHex: goal.colorHex,
                categoryName: goal.category?.name,
                parentGoalName: goal.parent?.name,
                createdAt: formatter.string(from: goal.createdAt),
                updatedAt: formatter.string(from: goal.updatedAt)
            )
        }

        let export = ExportData(
            exportDate: formatter.string(from: Date()),
            goals: exportedGoals
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(export)
    }

    static func deleteAllData(from context: ModelContext) {
        do {
            try context.delete(model: GoalReminder.self)
            try context.delete(model: Goal.self)
            try context.delete(model: Category.self)
            try context.save()
        } catch {
            // Silently fail
        }
    }
}
