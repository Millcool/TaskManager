import SwiftUI

struct DateRangePickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("От")
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .labelsHidden()
                    .tint(AppColors.accent)
            }
            HStack {
                Text("До")
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .labelsHidden()
                    .tint(AppColors.accent)
            }
        }
        .padding(AppTheme.cardPadding)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }
}
