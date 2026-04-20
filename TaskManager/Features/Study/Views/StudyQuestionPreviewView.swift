import SwiftUI

struct StudyQuestionPreviewView: View {
    let preview: StudyQuestionPreview
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.verticalSpacing) {
                    if !preview.context.isEmpty {
                        Text(preview.context)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.accent)
                    }

                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.accent)
                        Text(preview.question)
                            .font(.headline)
                            .foregroundStyle(AppColors.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    answerBlock

                    if let examples = preview.examples, !examples.isEmpty {
                        examplesBlock(examples)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AppTheme.horizontalPadding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(AppColors.background)
            .navigationTitle("Вопрос дня")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var answerBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Ответ")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.accent)
            Text(preview.answer)
                .font(.body)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }

    private func examplesBlock(_ examples: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Пример")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color(hex: "#10B981"))
            Text(examples)
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(hex: "#10B981").opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }
}
