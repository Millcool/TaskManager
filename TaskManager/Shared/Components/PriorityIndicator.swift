import SwiftUI

struct PriorityIndicator: View {
    let priority: GoalPriority

    private var color: Color {
        switch priority {
        case .high: return AppColors.red
        case .medium: return AppColors.accent
        case .low: return AppColors.neutral
        }
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(index <= (2 - priority.sortOrder) ? color : color.opacity(0.2))
                    .frame(width: 3, height: CGFloat(6 + index * 3))
            }
        }
    }
}
