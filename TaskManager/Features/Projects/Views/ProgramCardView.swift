import SwiftUI

struct ProgramCardView: View {
    let program: PhdProgram
    let university: University?

    @State private var store = PhdApplicationStore.shared

    private var status: PhdApplicationStatus { store.status(for: program.id) }
    private var urgency: PhdApplicationUrgency { PhdApplicationIndicator.urgency(for: program) }

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
                    statusBadge
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
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .stroke(cardStroke, lineWidth: cardStrokeWidth)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var statusBadge: some View {
        if status.isApplied {
            HStack(spacing: 3) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.caption2)
                Text("Подано")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(AppColors.green)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(AppColors.green.opacity(0.16))
            .clipShape(Capsule())
        } else if urgency != .none, urgency != .closed, let color = urgency.highlightColor {
            Text(urgency.label)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(color)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(color.opacity(0.16))
                .clipShape(Capsule())
        }
    }

    private var cardBackground: Color {
        if status.isApplied {
            return AppColors.green.opacity(0.12)
        }
        if let color = urgency.highlightColor, urgency != .closed {
            return color.opacity(urgency.backgroundOpacity)
        }
        return AppColors.cardBackground.opacity(0.5)
    }

    private var cardStroke: Color {
        if status.isApplied { return AppColors.green }
        if let color = urgency.highlightColor, urgency != .closed { return color }
        return AppColors.cardStroke
    }

    private var cardStrokeWidth: CGFloat {
        if status.isApplied { return 2 }
        switch urgency {
        case .urgent: return 2
        case .soon: return 1.5
        default: return 1
        }
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
