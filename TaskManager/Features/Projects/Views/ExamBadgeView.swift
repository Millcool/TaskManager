import SwiftUI

struct ExamBadgeView: View {
    let exam: EntranceExam
    @Binding var activeLink: SafariLink?

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

            if hasLinks {
                HStack(spacing: 8) {
                    if let infoURL = exam.infoURL.flatMap(URL.init) {
                        linkButton(
                            title: "Страница",
                            systemImage: "globe",
                            url: infoURL
                        )
                    }
                    if let pdfURL = exam.programPdfURL.flatMap(URL.init) {
                        linkButton(
                            title: "Программа PDF",
                            systemImage: "doc.richtext",
                            url: pdfURL
                        )
                    }
                }
                .padding(.top, 4)
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

    private var hasLinks: Bool {
        exam.infoURL != nil || exam.programPdfURL != nil
    }

    private func linkButton(title: String, systemImage: String, url: URL) -> some View {
        Button {
            activeLink = SafariLink(url: url)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.caption2)
                Text(title)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(badgeColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.15))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
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
