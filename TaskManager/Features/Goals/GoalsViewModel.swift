import Foundation
import SwiftData
import SwiftUI

struct DeletedGoalData {
    let name: String
    let goalDescription: String
    let periodRaw: String
    let periodStartDate: Date
    let priorityRaw: String
    let colorHex: String
    let sortOrder: Int
    let categoryId: UUID?
    let parentId: UUID?

    init(from goal: Goal) {
        self.name = goal.name
        self.goalDescription = goal.goalDescription
        self.periodRaw = goal.periodRaw
        self.periodStartDate = goal.periodStartDate
        self.priorityRaw = goal.priorityRaw
        self.colorHex = goal.colorHex
        self.sortOrder = goal.sortOrder
        self.categoryId = goal.category?.id
        self.parentId = goal.parent?.id
    }
}

@Observable
final class GoalsViewModel {
    var selectedPeriod: GoalPeriod = .day
    var currentDate: Date = Date()
    var goals: [Goal] = []
    var allCategories: [Category] = []
    var selectedCategoryIds: Set<UUID> = []
    var availableParents: [Goal] = []
    var showUndoSnackbar: Bool = false
    var deletedGoalName: String = ""

    var displayedGoals: [Goal] {
        guard !selectedCategoryIds.isEmpty else { return goals }
        return goals.filter { goal in
            guard let id = goal.category?.id else { return false }
            return selectedCategoryIds.contains(id)
        }
    }

    func fetchCategories() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        allCategories = (try? modelContext.fetch(descriptor)) ?? []
    }

    func toggleCategoryFilter(_ id: UUID) {
        if selectedCategoryIds.contains(id) {
            selectedCategoryIds.remove(id)
        } else {
            selectedCategoryIds.insert(id)
        }
    }

    func clearCategoryFilter() {
        selectedCategoryIds.removeAll()
    }

    private var modelContext: ModelContext?
    private var deletedGoalData: DeletedGoalData?
    private var undoTimer: Timer?

    var periodTitle: String {
        DateHelper.periodTitle(for: currentDate, period: selectedPeriod)
    }

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchCategories()
        fetchGoals()
    }

    func fetchGoals() {
        guard let modelContext else { return }
        let startDate = DateHelper.periodStartDate(for: currentDate, period: selectedPeriod)
        let endDate = DateHelper.periodEndDate(for: currentDate, period: selectedPeriod)
        let periodRaw = selectedPeriod.rawValue

        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate<Goal> {
                $0.periodRaw == periodRaw &&
                $0.periodStartDate >= startDate &&
                $0.periodStartDate <= endDate
            },
            sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.priorityRaw), SortDescriptor(\.createdAt)]
        )

        do {
            goals = try modelContext.fetch(descriptor)
        } catch {
            goals = []
        }
    }

    func fetchAvailableParents(for period: GoalPeriod, excluding goalId: UUID? = nil) {
        guard let modelContext else { return }

        let higherPeriods: [String]
        switch period {
        case .day: higherPeriods = [GoalPeriod.week.rawValue, GoalPeriod.month.rawValue, GoalPeriod.year.rawValue]
        case .week: higherPeriods = [GoalPeriod.month.rawValue, GoalPeriod.year.rawValue]
        case .month: higherPeriods = [GoalPeriod.year.rawValue]
        case .year: higherPeriods = []
        }

        guard !higherPeriods.isEmpty else {
            availableParents = []
            return
        }

        let statusNew = GoalStatus.new.rawValue
        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate<Goal> {
                higherPeriods.contains($0.periodRaw) &&
                ($0.statusRaw == statusNew)
            },
            sortBy: [SortDescriptor(\.periodRaw), SortDescriptor(\.name)]
        )

        do {
            var results = try modelContext.fetch(descriptor)
            if let goalId {
                results.removeAll { $0.id == goalId }
            }
            availableParents = results
        } catch {
            availableParents = []
        }
    }

    func navigatePeriod(direction: Int) {
        currentDate = DateHelper.navigate(from: currentDate, period: selectedPeriod, direction: direction)
        fetchGoals()
    }

    func goToToday() {
        currentDate = Date()
        fetchGoals()
    }

    func selectPeriod(_ period: GoalPeriod) {
        selectedPeriod = period
        currentDate = Date()
        fetchGoals()
    }

    // MARK: - Delete with Undo

    func deleteGoal(_ goal: Goal) {
        commitPendingDeletion()

        if let reminders = goal.reminders {
            for r in reminders {
                NotificationService.shared.cancelNotification(identifier: r.notificationIdentifier)
            }
        }

        deletedGoalData = DeletedGoalData(from: goal)
        deletedGoalName = goal.name

        modelContext?.delete(goal)
        try? modelContext?.save()
        fetchGoals()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showUndoSnackbar = true
        }

        undoTimer?.invalidate()
        undoTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.commitPendingDeletion()
            }
        }
    }

    func undoDelete() {
        undoTimer?.invalidate()
        undoTimer = nil

        guard let data = deletedGoalData, let modelContext else {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showUndoSnackbar = false
            }
            return
        }

        let goal = Goal(
            name: data.name,
            goalDescription: data.goalDescription,
            period: GoalPeriod(rawValue: data.periodRaw) ?? .day,
            periodStartDate: data.periodStartDate,
            priority: GoalPriority(rawValue: data.priorityRaw) ?? .medium,
            colorHex: data.colorHex,
            sortOrder: data.sortOrder
        )

        if let categoryId = data.categoryId {
            let descriptor = FetchDescriptor<Category>(
                predicate: #Predicate<Category> { $0.id == categoryId }
            )
            goal.category = try? modelContext.fetch(descriptor).first
        }

        if let parentId = data.parentId {
            let descriptor = FetchDescriptor<Goal>(
                predicate: #Predicate<Goal> { $0.id == parentId }
            )
            goal.parent = try? modelContext.fetch(descriptor).first
        }

        modelContext.insert(goal)
        try? modelContext.save()

        deletedGoalData = nil
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showUndoSnackbar = false
        }
        fetchGoals()
    }

    private func commitPendingDeletion() {
        undoTimer?.invalidate()
        undoTimer = nil
        deletedGoalData = nil
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showUndoSnackbar = false
        }
    }

    // MARK: - Reorder

    func moveGoalUp(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }), index > 0 else { return }
        let other = goals[index - 1]
        let tempOrder = goal.sortOrder
        goal.sortOrder = other.sortOrder
        other.sortOrder = tempOrder
        if goal.sortOrder == other.sortOrder {
            goal.sortOrder = index - 1
            other.sortOrder = index
        }
        goal.updatedAt = Date()
        other.updatedAt = Date()
        try? modelContext?.save()
        fetchGoals()
    }

    func moveGoalDown(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }), index < goals.count - 1 else { return }
        let other = goals[index + 1]
        let tempOrder = goal.sortOrder
        goal.sortOrder = other.sortOrder
        other.sortOrder = tempOrder
        if goal.sortOrder == other.sortOrder {
            goal.sortOrder = index + 1
            other.sortOrder = index
        }
        goal.updatedAt = Date()
        other.updatedAt = Date()
        try? modelContext?.save()
        fetchGoals()
    }

    // MARK: - Move to Next/Previous Period

    func moveToNextPeriod(_ goal: Goal) {
        let nextDate = DateHelper.navigate(from: goal.periodStartDate, period: goal.period, direction: 1)
        let nextStart = DateHelper.periodStartDate(for: nextDate, period: goal.period)
        goal.periodStartDate = nextStart
        goal.status = .new
        goal.sortOrder = Int(Date().timeIntervalSince1970)
        goal.updatedAt = Date()
        try? modelContext?.save()
        fetchGoals()
    }

    func moveToPreviousPeriod(_ goal: Goal) {
        let prevDate = DateHelper.navigate(from: goal.periodStartDate, period: goal.period, direction: -1)
        let prevStart = DateHelper.periodStartDate(for: prevDate, period: goal.period)
        goal.periodStartDate = prevStart
        goal.status = .new
        goal.sortOrder = Int(Date().timeIntervalSince1970)
        goal.updatedAt = Date()
        try? modelContext?.save()
        fetchGoals()
    }

    // MARK: - Status

    func setStatus(_ goal: Goal, status: GoalStatus) {
        goal.status = status
        try? modelContext?.save()
        fetchGoals()
    }

    // MARK: - CRUD

    func addGoal(
        name: String,
        description: String,
        period: GoalPeriod,
        priority: GoalPriority,
        colorHex: String,
        category: Category?,
        parent: Goal?,
        reminderDate: Date?
    ) {
        let startDate = DateHelper.periodStartDate(for: currentDate, period: period)
        let nextSortOrder = (goals.map(\.sortOrder).max() ?? -1) + 1
        let goal = Goal(
            name: name,
            goalDescription: description,
            period: period,
            periodStartDate: startDate,
            priority: priority,
            colorHex: colorHex,
            category: category,
            parent: parent,
            sortOrder: nextSortOrder
        )
        modelContext?.insert(goal)

        if let reminderDate {
            let reminder = GoalReminder(reminderDate: reminderDate, goal: goal)
            modelContext?.insert(reminder)
            NotificationService.shared.scheduleGoalReminder(reminder, goalName: name)
        }

        try? modelContext?.save()
        fetchGoals()
    }

    func updateGoal(
        _ goal: Goal,
        name: String,
        description: String,
        priority: GoalPriority,
        colorHex: String,
        category: Category?,
        parent: Goal?,
        reminderDate: Date?
    ) {
        goal.name = name
        goal.goalDescription = description
        goal.priority = priority
        goal.colorHex = colorHex
        goal.category = category
        goal.parent = parent
        goal.updatedAt = Date()

        // Update reminders
        if let existingReminders = goal.reminders {
            for r in existingReminders {
                NotificationService.shared.cancelNotification(identifier: r.notificationIdentifier)
                modelContext?.delete(r)
            }
        }

        if let reminderDate {
            let reminder = GoalReminder(reminderDate: reminderDate, goal: goal)
            modelContext?.insert(reminder)
            NotificationService.shared.scheduleGoalReminder(reminder, goalName: name)
        }

        try? modelContext?.save()
        fetchGoals()
    }
}
