import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding(AppTheme.cardPadding)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                    .stroke(AppColors.cardStroke, lineWidth: 1)
            )
    }

    func accentButtonStyle() -> some View {
        self
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppColors.accent)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
    }
}
