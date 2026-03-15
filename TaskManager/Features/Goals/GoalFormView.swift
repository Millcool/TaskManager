import SwiftUI
import SwiftData

enum GoalFormMode {
    case create
    case edit(Goal)
}

struct GoalFormView: View {
    let mode: GoalFormMode
    var viewModel: GoalsViewModel

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var goalDescription = ""
    @State private var period: GoalPeriod = .day
    @State private var priority: GoalPriority = .medium
    @State private var colorHex = "#8B5CF6"
    @State private var selectedCategory: Category?
    @State private var selectedParent: Goal?
    @State private var hasReminder = false
    @State private var reminderDate = Date()

    @State private var categories: [Category] = []

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var title: String {
        isEditing ? "Редактировать" : "Новая цель"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Название")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        TextField("Название цели", text: $name)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Описание")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        TextField("Подробное описание", text: $goalDescription, axis: .vertical)
                            .textFieldStyle(.plain)
                            .lineLimit(3...6)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    }

                    // Period (only for create)
                    if !isEditing {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Период")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                            Picker("Период", selection: $period) {
                                ForEach(GoalPeriod.allCases, id: \.self) { p in
                                    Text(p.title).tag(p)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: period) { _, newValue in
                                viewModel.fetchAvailableParents(for: newValue)
                                selectedParent = nil
                            }
                        }
                    }

                    // Priority
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Приоритет")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        Picker("Приоритет", selection: $priority) {
                            ForEach(GoalPriority.allCases, id: \.self) { p in
                                Text(p.title).tag(p)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Color
                    ColorPickerRow(title: "Цвет", selectedHex: $colorHex)

                    // Category
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Категория")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        Menu {
                            Button("Без категории") {
                                selectedCategory = nil
                            }
                            ForEach(categories, id: \.id) { cat in
                                Button(cat.name) {
                                    selectedCategory = cat
                                }
                            }
                        } label: {
                            HStack {
                                if let cat = selectedCategory {
                                    Circle()
                                        .fill(Color(hex: cat.colorHex))
                                        .frame(width: 10, height: 10)
                                    Text(cat.name)
                                } else {
                                    Text("Без категории")
                                }
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                            .foregroundStyle(AppColors.textPrimary)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                        }
                    }

                    // Parent goal
                    if !viewModel.availableParents.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Родительская цель")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                            Menu {
                                Button("Без привязки") {
                                    selectedParent = nil
                                }
                                ForEach(viewModel.availableParents, id: \.id) { goal in
                                    Button("\(goal.period.shortTitle): \(goal.name)") {
                                        selectedParent = goal
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedParent?.name ?? "Без привязки")
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                                .foregroundStyle(AppColors.textPrimary)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                            }
                        }
                    }

                    // Reminder
                    VStack(alignment: .leading, spacing: 6) {
                        Toggle(isOn: $hasReminder) {
                            Text("Напоминание")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        .tint(AppColors.accent)

                        if hasReminder {
                            DatePicker(
                                "Дата и время",
                                selection: $reminderDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .tint(AppColors.accent)
                            .foregroundStyle(AppColors.textPrimary)
                        }
                    }
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))

                    // Save button
                    Button {
                        save()
                    } label: {
                        Text(isEditing ? "Сохранить" : "Создать")
                            .accentButtonStyle()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(name.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.horizontalPadding)
            }
            .background(AppColors.background)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .onAppear {
                loadData()
            }
        }
    }

    private func loadData() {
        // Load categories
        let descriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        categories = (try? modelContext.fetch(descriptor)) ?? []

        // Setup for mode
        switch mode {
        case .create:
            period = viewModel.selectedPeriod
            viewModel.fetchAvailableParents(for: period)

        case .edit(let goal):
            name = goal.name
            goalDescription = goal.goalDescription
            period = goal.period
            priority = goal.priority
            colorHex = goal.colorHex
            selectedCategory = goal.category
            selectedParent = goal.parent
            viewModel.fetchAvailableParents(for: goal.period, excluding: goal.id)

            if let reminder = goal.reminders?.first {
                hasReminder = true
                reminderDate = reminder.reminderDate
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        switch mode {
        case .create:
            viewModel.addGoal(
                name: trimmedName,
                description: goalDescription,
                period: period,
                priority: priority,
                colorHex: colorHex,
                category: selectedCategory,
                parent: selectedParent,
                reminderDate: hasReminder ? reminderDate : nil
            )
        case .edit(let goal):
            viewModel.updateGoal(
                goal,
                name: trimmedName,
                description: goalDescription,
                priority: priority,
                colorHex: colorHex,
                category: selectedCategory,
                parent: selectedParent,
                reminderDate: hasReminder ? reminderDate : nil
            )
        }

        dismiss()
    }
}
