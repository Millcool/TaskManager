import SwiftUI

struct StatusBadge: View {
    let status: GoalStatus

    private var color: Color {
        switch status {
        case .new: return AppColors.neutral
        case .completed: return AppColors.green
        case .failed: return AppColors.red
        }
    }

    private var icon: String {
        switch status {
        case .new: return "circle"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(status.title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .clipShape(Capsule())
    }
}
