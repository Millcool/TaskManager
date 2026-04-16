import Foundation
import SwiftData

enum DataExportService {
    struct ExportedReminder: Codable {
        let reminderDate: String
        let isActive: Bool
    }

    struct ExportedGoal: Codable {
        let id: String
        let name: String
        let description: String
        let period: String
        let periodStartDate: String
        let priority: String
        let status: String
        let colorHex: String
        let sortOrder: Int
        let categoryName: String?
        let parentGoalName: String?
        let createdAt: String
        let updatedAt: String
        let reminders: [ExportedReminder]
    }

    struct ExportedCategory: Codable {
        let id: String
        let name: String
        let colorHex: String
    }

    struct ExportedRule: Codable {
        let id: String
        let title: String
        let content: String
        let kind: String
        let colorHex: String
        let sortOrder: Int
        let isPinned: Bool
        let createdAt: String
        let updatedAt: String
    }

    struct ExportData: Codable {
        let exportDate: String
        let schemaVersion: Int?
        let categories: [ExportedCategory]
        let goals: [ExportedGoal]
        let rules: [ExportedRule]?

        init(
            exportDate: String,
            schemaVersion: Int? = 3,
            categories: [ExportedCategory],
            goals: [ExportedGoal],
            rules: [ExportedRule]? = nil
        ) {
            self.exportDate = exportDate
            self.schemaVersion = schemaVersion
            self.categories = categories
            self.goals = goals
            self.rules = rules
        }
    }

    static func exportGoals(from context: ModelContext) -> Data? {
        let goalsDescriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.createdAt)])
        let categoriesDescriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        let rulesDescriptor = FetchDescriptor<Rule>(sortBy: [SortDescriptor(\.createdAt)])
        guard let goals = try? context.fetch(goalsDescriptor),
              let categories = try? context.fetch(categoriesDescriptor) else { return nil }
        let rules = (try? context.fetch(rulesDescriptor)) ?? []

        let formatter = ISO8601DateFormatter()

        let exportedCategories = categories.map { cat in
            ExportedCategory(
                id: cat.id.uuidString,
                name: cat.name,
                colorHex: cat.colorHex
            )
        }

        let exportedGoals = goals.map { goal in
            let exportedReminders = (goal.reminders ?? []).map { reminder in
                ExportedReminder(
                    reminderDate: formatter.string(from: reminder.reminderDate),
                    isActive: reminder.isActive
                )
            }

            return ExportedGoal(
                id: goal.id.uuidString,
                name: goal.name,
                description: goal.goalDescription,
                period: goal.period.rawValue,
                periodStartDate: formatter.string(from: goal.periodStartDate),
                priority: goal.priority.rawValue,
                status: goal.status.rawValue,
                colorHex: goal.colorHex,
                sortOrder: goal.sortOrder,
                categoryName: goal.category?.name,
                parentGoalName: goal.parent?.name,
                createdAt: formatter.string(from: goal.createdAt),
                updatedAt: formatter.string(from: goal.updatedAt),
                reminders: exportedReminders
            )
        }

        let exportedRules = rules.map { rule in
            ExportedRule(
                id: rule.id.uuidString,
                title: rule.title,
                content: rule.content,
                kind: rule.kindRaw,
                colorHex: rule.colorHex,
                sortOrder: rule.sortOrder,
                isPinned: rule.isPinned,
                createdAt: formatter.string(from: rule.createdAt),
                updatedAt: formatter.string(from: rule.updatedAt)
            )
        }

        let export = ExportData(
            exportDate: formatter.string(from: Date()),
            schemaVersion: 3,
            categories: exportedCategories,
            goals: exportedGoals,
            rules: exportedRules
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(export)
    }

    // MARK: - Import

    enum ImportError: LocalizedError {
        case decodingFailed
        case saveFailed(Error)

        var errorDescription: String? {
            switch self {
            case .decodingFailed:
                return "Не удалось прочитать файл. Убедитесь, что это корректный JSON-бэкап."
            case .saveFailed(let error):
                return "Ошибка сохранения: \(error.localizedDescription)"
            }
        }
    }

    static func importGoals(from data: Data, into context: ModelContext) throws {
        let decoder = JSONDecoder()
        guard let exportData = try? decoder.decode(ExportData.self, from: data) else {
            throw ImportError.decodingFailed
        }

        let formatter = ISO8601DateFormatter()

        // 1. Fetch existing categories to avoid duplicates
        let existingCategoriesDescriptor = FetchDescriptor<Category>()
        let existingCategories = (try? context.fetch(existingCategoriesDescriptor)) ?? []
        var categoryMap: [String: Category] = [:]
        for cat in existingCategories {
            categoryMap[cat.name] = cat
        }

        // 2. Create missing categories
        for exportedCat in exportData.categories {
            if categoryMap[exportedCat.name] == nil {
                let category = Category(name: exportedCat.name, colorHex: exportedCat.colorHex)
                context.insert(category)
                categoryMap[exportedCat.name] = category
            }
        }

        // 3. Create goals (without parent links)
        var goalMap: [String: Goal] = [:] // name -> Goal

        for exportedGoal in exportData.goals {
            let period = GoalPeriod(rawValue: exportedGoal.period) ?? .day
            let priority = GoalPriority(rawValue: exportedGoal.priority) ?? .medium
            let periodStartDate = formatter.date(from: exportedGoal.periodStartDate) ?? Date()

            let goal = Goal(
                name: exportedGoal.name,
                goalDescription: exportedGoal.description,
                period: period,
                periodStartDate: periodStartDate,
                priority: priority,
                colorHex: exportedGoal.colorHex,
                category: exportedGoal.categoryName.flatMap { categoryMap[$0] },
                sortOrder: exportedGoal.sortOrder
            )

            // Restore status
            let status = GoalStatus(rawValue: exportedGoal.status) ?? .new
            goal.status = status

            // Restore dates
            if let createdAt = formatter.date(from: exportedGoal.createdAt) {
                goal.createdAt = createdAt
            }
            if let updatedAt = formatter.date(from: exportedGoal.updatedAt) {
                goal.updatedAt = updatedAt
            }

            context.insert(goal)
            goalMap[exportedGoal.name] = goal

            // 4. Create reminders
            for exportedReminder in exportedGoal.reminders {
                if let reminderDate = formatter.date(from: exportedReminder.reminderDate) {
                    let reminder = GoalReminder(reminderDate: reminderDate, goal: goal)
                    reminder.isActive = exportedReminder.isActive
                    context.insert(reminder)
                }
            }
        }

        // 5. Restore parent-child relationships
        for exportedGoal in exportData.goals {
            if let parentName = exportedGoal.parentGoalName,
               let child = goalMap[exportedGoal.name],
               let parent = goalMap[parentName] {
                child.parent = parent
            }
        }

        // 6. Import rules (if present in backup)
        if let exportedRules = exportData.rules {
            let existingRulesDescriptor = FetchDescriptor<Rule>()
            let existingRules = (try? context.fetch(existingRulesDescriptor)) ?? []
            let existingIds = Set(existingRules.map(\.id))

            for exportedRule in exportedRules {
                if let id = UUID(uuidString: exportedRule.id), existingIds.contains(id) {
                    continue
                }
                let kind = RuleKind(rawValue: exportedRule.kind) ?? .rule
                let rule = Rule(
                    title: exportedRule.title,
                    content: exportedRule.content,
                    kind: kind,
                    colorHex: exportedRule.colorHex,
                    sortOrder: exportedRule.sortOrder,
                    isPinned: exportedRule.isPinned
                )
                if let id = UUID(uuidString: exportedRule.id) {
                    rule.id = id
                }
                if let createdAt = formatter.date(from: exportedRule.createdAt) {
                    rule.createdAt = createdAt
                }
                if let updatedAt = formatter.date(from: exportedRule.updatedAt) {
                    rule.updatedAt = updatedAt
                }
                context.insert(rule)
            }
        }

        // 7. Save
        do {
            try context.save()
        } catch {
            throw ImportError.saveFailed(error)
        }
    }

    static func deleteAllData(from context: ModelContext) {
        do {
            try context.delete(model: GoalReminder.self)
            try context.delete(model: Goal.self)
            try context.delete(model: Category.self)
            try context.delete(model: Rule.self)
            try context.save()
        } catch {
            // Silently fail
        }
    }
}
