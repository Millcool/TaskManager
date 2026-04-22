import SwiftUI
import SwiftData

struct DailyGoalsRequiredView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var todayGoals: [Goal]
    @State private var newGoalName: String = ""
    @FocusState private var nameFocused: Bool

    init() {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        let dayPeriod = GoalPeriod.day.rawValue
        _todayGoals = Query(
            filter: #Predicate<Goal> { goal in
                goal.periodRaw == dayPeriod && goal.periodStartDate >= start && goal.periodStartDate < end
            },
            sort: \Goal.createdAt
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.accent.opacity(0.18), AppColors.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                header

                ScrollView {
                    VStack(spacing: 16) {
                        inputCard

                        if !todayGoals.isEmpty {
                            goalsList
                        }
                    }
                    .padding(.horizontal, AppTheme.horizontalPadding)
                }

                if !todayGoals.isEmpty {
                    doneButton
                        .padding(.horizontal, AppTheme.horizontalPadding)
                        .padding(.bottom, 12)
                }
            }
            .padding(.top, 32)
        }
        .onAppear {
            if todayGoals.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    nameFocused = true
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "target")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(AppColors.accent)

            Text("Поставь цели на день")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text("Нельзя пропустить день без целей. Запиши хотя бы одну.")
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Новая цель на сегодня")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)

            TextField("Например: завершить раздел ВКР", text: $newGoalName, axis: .vertical)
                .lineLimit(1...3)
                .textFieldStyle(.plain)
                .padding(12)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                .focused($nameFocused)
                .submitLabel(.done)
                .onSubmit(addGoal)

            Button(action: addGoal) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                    Text("Добавить цель")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(trimmedName.isEmpty ? AppColors.neutral.opacity(0.35) : AppColors.accent)
                .foregroundStyle(.white.opacity(trimmedName.isEmpty ? 0.6 : 1))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
            }
        }
        .padding(14)
        .background(AppColors.cardBackground.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }

    private var goalsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Цели на сегодня")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)

            ForEach(todayGoals, id: \.id) { goal in
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color(hex: goal.colorHex))
                        .frame(width: 8, height: 8)
                    Text(goal.name)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer()
                    Button {
                        delete(goal)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(AppColors.neutral)
                    }
                }
                .padding(12)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
            }
        }
    }

    private var doneButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Готово")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
        }
    }

    private var trimmedName: String {
        newGoalName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func addGoal() {
        let name = trimmedName
        guard !name.isEmpty else {
            nameFocused = true
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            return
        }
        let start = Calendar.current.startOfDay(for: Date())
        let nextSortOrder = (todayGoals.map(\.sortOrder).max() ?? -1) + 1
        let goal = Goal(
            name: name,
            period: .day,
            periodStartDate: start,
            sortOrder: nextSortOrder
        )
        modelContext.insert(goal)
        try? modelContext.save()
        newGoalName = ""
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func delete(_ goal: Goal) {
        modelContext.delete(goal)
        try? modelContext.save()
    }
}
