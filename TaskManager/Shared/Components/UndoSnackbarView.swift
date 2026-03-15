import SwiftUI

struct UndoSnackbarView: View {
    let goalName: String
    let onUndo: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "trash")
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)

            Text("«\(goalName)» удалена")
                .font(.subheadline)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)

            Spacer()

            Button {
                onUndo()
            } label: {
                Text("Отменить")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.accent)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        .padding(.horizontal, AppTheme.horizontalPadding)
    }
}
