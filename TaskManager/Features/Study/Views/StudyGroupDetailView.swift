import SwiftUI

struct StudyGroupDetailView: View {
    let group: StudyGroup

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.verticalSpacing) {
                headerCard

                VStack(spacing: 10) {
                    ForEach(group.topics, id: \.id) { topic in
                        NavigationLink(destination: StudyTopicDetailView(topic: topic)) {
                            StudyTopicRowView(topic: topic)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(AppColors.background)
        .navigationTitle(group.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: group.iconSystemName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(
                    LinearGradient(
                        colors: [AppColors.accent, Color(hex: "#10B981")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text(group.title)
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Text(group.subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .cardStyle()
    }
}

struct StudyTopicRowView: View {
    let topic: StudyTopic

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)
                Text(topic.summary)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 4) {
                    Image(systemName: "questionmark.circle")
                        .font(.caption2)
                    Text("\(topic.questions.count) вопросов")
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundStyle(AppColors.accent)
                .padding(.top, 4)
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
