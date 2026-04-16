import SwiftUI

struct ProgramsTableRowView: View {
    let program: PhdProgram
    let university: University?

    @State private var store = PhdApplicationStore.shared

    private let columnSpacing: CGFloat = 14

    private var status: PhdApplicationStatus { store.status(for: program.id) }
    private var urgency: PhdApplicationUrgency { PhdApplicationIndicator.urgency(for: program) }

    var body: some View {
        NavigationLink(destination: ProgramDetailView(program: program, university: university)) {
            HStack(alignment: .top, spacing: columnSpacing) {
                statusStripe
                cell(width: 160, alignment: .leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(university?.shortName ?? "—")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.textPrimary)
                            .lineLimit(2)
                        if let city = university?.city {
                            Text(city)
                                .font(.caption2)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }

                cell(width: 220, alignment: .leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(program.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.textPrimary)
                            .lineLimit(2)
                        Text(program.fieldOfStudy)
                            .font(.caption2)
                            .foregroundStyle(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                }

                cell(width: 70, alignment: .leading) {
                    Text(program.code)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.textPrimary)
                }

                cell(width: 60, alignment: .trailing) {
                    numberPill(value: "\(program.budgetPlaces)", color: AppColors.green)
                }

                cell(width: 60, alignment: .trailing) {
                    numberPill(
                        value: "\(program.paidPlaces)",
                        color: program.paidPlaces > 0 ? Color(hex: "#F59E0B") : AppColors.neutral
                    )
                }

                cell(width: 100, alignment: .trailing) {
                    if let tuition = program.tuitionPerYear {
                        Text(formatCurrency(tuition))
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.textPrimary)
                    } else {
                        Text("—")
                            .font(.caption2)
                            .foregroundStyle(AppColors.neutral)
                    }
                }

                cell(width: 70, alignment: .trailing) {
                    if let score = program.passingScoreLastYear {
                        Text("\(score)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.accent)
                    } else {
                        Text("—")
                            .font(.caption2)
                            .foregroundStyle(AppColors.neutral)
                    }
                }

                cell(width: 60, alignment: .trailing) {
                    Text("\(program.durationYears) г.")
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                }

                cell(width: 150, alignment: .leading) {
                    Text(program.entranceExams.map(\.name).joined(separator: ", "))
                        .font(.caption2)
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(2)
                }

                cell(width: 130, alignment: .leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(program.applicationStartDate + " – " + program.applicationEndDate)
                            .font(.caption2)
                            .foregroundStyle(AppColors.textSecondary)
                            .lineLimit(1)
                        Text(program.examPeriod)
                            .font(.caption2)
                            .foregroundStyle(AppColors.neutral)
                            .lineLimit(1)
                    }
                }

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(AppColors.neutral)
                    .padding(.top, 2)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(rowBackground)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                    .stroke(rowStroke, lineWidth: rowStrokeWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var statusStripe: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(stripeColor)
            .frame(width: 4)
    }

    private var stripeColor: Color {
        if status.isApplied { return AppColors.green }
        if let color = urgency.highlightColor, urgency != .closed { return color }
        return Color.clear
    }

    private var rowBackground: Color {
        if status.isApplied {
            return AppColors.green.opacity(0.10)
        }
        if let color = urgency.highlightColor, urgency != .closed {
            return color.opacity(urgency.backgroundOpacity)
        }
        return AppColors.cardBackground
    }

    private var rowStroke: Color {
        if status.isApplied { return AppColors.green }
        if let color = urgency.highlightColor, urgency != .closed { return color }
        return AppColors.cardStroke
    }

    private var rowStrokeWidth: CGFloat {
        if status.isApplied { return 2 }
        switch urgency {
        case .urgent: return 2
        case .soon: return 1.5
        default: return 1
        }
    }

    private func cell<Content: View>(
        width: CGFloat,
        alignment: Alignment,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .frame(width: width, alignment: alignment)
    }

    private func numberPill(value: String, color: Color) -> some View {
        Text(value)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    private func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let formatted = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return formatted + " ₽"
    }
}

struct ProgramsTableHeaderView: View {
    private let columnSpacing: CGFloat = 14

    var body: some View {
        HStack(alignment: .center, spacing: columnSpacing) {
            headerCell("Вуз", width: 160, alignment: .leading)
            headerCell("Программа", width: 220, alignment: .leading)
            headerCell("Код", width: 70, alignment: .leading)
            headerCell("Бюджет", width: 60, alignment: .trailing)
            headerCell("Платных", width: 60, alignment: .trailing)
            headerCell("Цена/год", width: 100, alignment: .trailing)
            headerCell("Проход.", width: 70, alignment: .trailing)
            headerCell("Срок", width: 60, alignment: .trailing)
            headerCell("Экзамены", width: 150, alignment: .leading)
            headerCell("Сроки приёма", width: 130, alignment: .leading)
            Spacer().frame(width: 10)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.background)
    }

    private func headerCell(_ title: String, width: CGFloat, alignment: Alignment) -> some View {
        Text(title)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(AppColors.textSecondary)
            .textCase(.uppercase)
            .frame(width: width, alignment: alignment)
    }
}
