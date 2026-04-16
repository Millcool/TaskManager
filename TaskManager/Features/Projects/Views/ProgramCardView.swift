import SwiftUI

struct ProgramCardView: View {
    let program: PhdProgram
    let university: University?

    var body: some View {
        NavigationLink(destination: ProgramDetailView(program: program, university: university)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(program.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.textPrimary)
                            .multilineTextAlignment(.leading)
                        Text(program.code + " • " + program.fieldOfStudy)
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(AppColors.neutral)
                        .padding(.top, 2)
                }

                HStack(spacing: 8) {
                    badge(icon: "person.2.fill", text: "Бюджет: \(program.budgetPlaces)", color: AppColors.green)
                    if program.paidPlaces > 0 {
                        badge(icon: "banknote", text: "Платных: \(program.paidPlaces)", color: Color(hex: "#F59E0B"))
                    }
                    Spacer()
                    Text("\(program.durationYears) г.")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                if let tuition = program.tuitionPerYear {
                    HStack {
                        Text(formatCurrency(tuition) + " ₽/год")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                        if let score = program.passingScoreLastYear {
                            Spacer()
                            Text("Проходной: \(score)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(AppColors.accent)
                        }
                    }
                } else if let score = program.passingScoreLastYear {
                    Text("Проходной балл: \(score)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.accent)
                }
            }
            .padding(12)
            .background(AppColors.cardBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .stroke(AppColors.cardStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func badge(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
