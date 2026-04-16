import SwiftUI

struct ExamBadgeView: View {
    let exam: EntranceExam

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundStyle(badgeColor)
                Text(exam.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text(exam.type.rawValue)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(badgeColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(badgeColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 4))

            if !exam.details.isEmpty {
                Text(exam.details)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            if let maxScore = exam.maxScore {
                Text("Макс. балл: \(maxScore)")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(AppColors.cardBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }

    private var iconName: String {
        switch exam.type {
        case .written: "pencil.line"
        case .oral: "person.wave.2"
        case .test: "checklist"
        case .interview: "bubble.left.and.bubble.right"
        case .portfolio: "doc.text"
        }
    }

    private var badgeColor: Color {
        switch exam.type {
        case .written: AppColors.accent
        case .oral: AppColors.green
        case .test: Color(hex: "#F59E0B")
        case .interview: Color(hex: "#3B82F6")
        case .portfolio: Color(hex: "#EC4899")
        }
    }
}
