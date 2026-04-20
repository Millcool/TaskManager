import SwiftUI

struct GoalRowView: View {
    let goal: Goal
    var isTaskOfTheDay: Bool = false

    private func formatEstimate(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes) мин" }
        let hours = Double(minutes) / 60
        if hours == hours.rounded() {
            return "\(Int(hours)) ч"
        }
        return String(format: "%.1f ч", hours)
    }

    private var statusColor: Color {
        switch goal.status {
        case .new: return AppColors.neutral
        case .completed: return AppColors.green
        case .failed: return AppColors.red
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: goal.colorHex))
                .frame(width: 4, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if isTaskOfTheDay {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(AppColors.accent)
                    }
                    Text(goal.name)
                        .font(.body)
                        .fontWeight(isTaskOfTheDay ? .bold : .medium)
                        .foregroundStyle(AppColors.textPrimary)
                        .strikethrough(goal.status == .completed, color: AppColors.textSecondary)
                }

                HStack(spacing: 8) {
                    if let category = goal.category {
                        Text(category.name)
                            .font(.caption2)
                            .foregroundStyle(Color(hex: category.colorHex))
                    }

                    if let minutes = goal.estimatedMinutes {
                        HStack(spacing: 2) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text(formatEstimate(minutes))
                                .font(.caption2)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(AppColors.textSecondary)
                    }

                    if goal.parent != nil {
                        HStack(spacing: 2) {
                            Image(systemName: "link")
                                .font(.caption2)
                            Text(goal.parent?.name ?? "")
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }

            Spacer()

            PriorityIndicator(priority: goal.priority)

            StatusBadge(status: goal.status)
        }
        .padding(AppTheme.cardPadding)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(
                    isTaskOfTheDay ? AppColors.accent.opacity(0.5) : AppColors.cardStroke,
                    lineWidth: isTaskOfTheDay ? 1.5 : 1
                )
        )
        .shadow(
            color: isTaskOfTheDay ? AppColors.accent.opacity(0.15) : .clear,
            radius: 8,
            x: 0,
            y: 2
        )
    }
}
