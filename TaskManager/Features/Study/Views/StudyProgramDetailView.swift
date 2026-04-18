import SwiftUI

struct StudyProgramDetailView: View {
    let program: PhdProgram

    private var groups: [StudyGroup] {
        StudyDataProvider.groups(for: program)
    }

    private var universityName: String {
        PhdProgramsDataProvider.university(for: program)?.shortName ?? "Вуз"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.verticalSpacing) {
                headerCard

                if groups.isEmpty {
                    emptyCard
                } else {
                    VStack(spacing: 10) {
                        ForEach(groups, id: \.id) { group in
                            NavigationLink(destination: StudyGroupDetailView(group: group)) {
                                StudyGroupRowView(group: group)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(AppColors.background)
        .navigationTitle("Темы")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(universityName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
            Text(program.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textPrimary)
            Text("\(program.code) · \(program.fieldOfStudy)")
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private var emptyCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "text.book.closed")
                .font(.title2)
                .foregroundStyle(AppColors.textSecondary)
            Text("Для этой программы пока нет теории")
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(AppColors.cardBackground.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }
}

struct StudyGroupRowView: View {
    let group: StudyGroup

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: group.iconSystemName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(
                    LinearGradient(
                        colors: [AppColors.accent, Color(hex: "#10B981")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(group.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
                Text(group.subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.leading)
                Text("\(group.topics.count) тем")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.accent)
                    .padding(.top, 2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppColors.neutral)
        }
        .padding(14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }
}
