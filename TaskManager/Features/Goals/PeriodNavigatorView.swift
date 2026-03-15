import SwiftUI

struct PeriodNavigatorView: View {
    let title: String
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onToday: () -> Void

    var body: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.accent)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text(title)
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)
                .onTapGesture(perform: onToday)

            Spacer()

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.accent)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
    }
}
