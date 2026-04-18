import SwiftUI

struct StudyTopicDetailView: View {
    let topic: StudyTopic
    @State private var expandedQuestionIds: Set<UUID> = []

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.verticalSpacing) {
                summaryCard

                VStack(spacing: 10) {
                    ForEach(topic.questions, id: \.id) { question in
                        StudyQuestionCard(
                            question: question,
                            isExpanded: expandedQuestionIds.contains(question.id),
                            onToggle: { toggle(question.id) }
                        )
                    }
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(AppColors.background)
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Тема")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.accent)
            Text(topic.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textPrimary)
            Text(topic.summary)
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func toggle(_ id: UUID) {
        if expandedQuestionIds.contains(id) {
            expandedQuestionIds.remove(id)
        } else {
            expandedQuestionIds.insert(id)
        }
    }
}

struct StudyQuestionCard: View {
    let question: StudyQuestion
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onToggle) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppColors.accent)

                    Text(question.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(AppColors.neutral)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    answerBlock

                    if let examples = question.examples, !examples.isEmpty {
                        examplesBlock(examples)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }

    private var answerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Ответ")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.accent)
            Text(question.answer)
                .font(.footnote)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func examplesBlock(_ examples: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Пример")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(Color(hex: "#10B981"))
            Text(examples)
                .font(.footnote)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(hex: "#10B981").opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
