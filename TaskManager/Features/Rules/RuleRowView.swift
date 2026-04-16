import SwiftUI

struct RuleRowView: View {
    let rule: Rule

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Rectangle()
                .fill(Color(hex: rule.colorHex))
                .frame(width: 4)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    if rule.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption2)
                            .foregroundStyle(AppColors.accent)
                    }
                    Text(rule.title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(2)
                }

                if !rule.content.isEmpty {
                    Text(rule.content)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppColors.neutral)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }
}
