import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    @Environment(\.dismiss) private var dismiss
    @State private var showEditSheet = false
    var viewModel: GoalsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Status and Priority
                HStack {
                    StatusBadge(status: goal.status)
                    Spacer()
                    PriorityIndicator(priority: goal.priority)
                    Text(goal.priority.title)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                // Description
                if !goal.goalDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Описание")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        Text(goal.goalDescription)
                            .font(.body)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .cardStyle()
                }

                // Info
                VStack(spacing: 12) {
                    infoRow(title: "Период", value: goal.period.title)
                    infoRow(title: "Создана", value: formattedDate(goal.createdAt))

                    if let category = goal.category {
                        HStack {
                            Text("Категория")
                                .foregroundStyle(AppColors.textSecondary)
                            Spacer()
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color(hex: category.colorHex))
                                    .frame(width: 8, height: 8)
                                Text(category.name)
                                    .foregroundStyle(AppColors.textPrimary)
                            }
                        }
                        .font(.subheadline)
                    }

                    if let parent = goal.parent {
                        HStack {
                            Text("Родительская цель")
                                .foregroundStyle(AppColors.textSecondary)
                            Spacer()
                            Text(parent.name)
                                .foregroundStyle(AppColors.accent)
                        }
                        .font(.subheadline)
                    }
                }
                .cardStyle()

                // Children
                if let children = goal.children, !children.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Подцели")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        ForEach(children, id: \.id) { child in
                            HStack {
                                Circle()
                                    .fill(Color(hex: child.colorHex))
                                    .frame(width: 8, height: 8)
                                Text(child.name)
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.textPrimary)
                                Spacer()
                                StatusBadge(status: child.status)
                            }
                        }
                    }
                    .cardStyle()
                }

                // Reminders
                if let reminders = goal.reminders, !reminders.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Напоминания")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        ForEach(reminders, id: \.id) { reminder in
                            HStack {
                                Image(systemName: reminder.isActive ? "bell.fill" : "bell.slash")
                                    .foregroundStyle(reminder.isActive ? AppColors.accent : AppColors.neutral)
                                Text(formattedDateTime(reminder.reminderDate))
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.textPrimary)
                            }
                        }
                    }
                    .cardStyle()
                }

                // Actions
                VStack(spacing: 10) {
                    if goal.status != .completed {
                        Button {
                            viewModel.setStatus(goal, status: .completed)
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
                            Label("Выполнена", systemImage: "checkmark.circle.fill")
                                .accentButtonStyle()
                        }
                    }

                    if goal.status != .failed {
                        Button {
                            viewModel.setStatus(goal, status: .failed)
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
                            Label("Не выполнена", systemImage: "xmark.circle.fill")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(AppColors.red.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
                        }
                    }

                    if goal.status != .new {
                        Button {
                            viewModel.setStatus(goal, status: .new)
                        } label: {
                            Text("Сбросить статус")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle(goal.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                        .foregroundStyle(AppColors.accent)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            GoalFormView(mode: .edit(goal), viewModel: viewModel)
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(AppColors.textSecondary)
            Spacer()
            Text(value)
                .foregroundStyle(AppColors.textPrimary)
        }
        .font(.subheadline)
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMMM yyyy"
        return f.string(from: date)
    }

    private func formattedDateTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMM yyyy, HH:mm"
        return f.string(from: date)
    }
}
