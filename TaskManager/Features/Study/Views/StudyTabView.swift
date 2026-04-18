import SwiftUI

struct StudyTabView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.verticalSpacing) {
                    headerCard

                    ForEach(PhdProgramsDataProvider.universities, id: \.id) { university in
                        universitySection(university)
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .background(AppColors.background)
            .navigationTitle("Учебные материалы")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "books.vertical.fill")
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
                Text("Теория по вступительным")
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Text("Выберите программу, тему и читайте вопросы с ответами")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .cardStyle()
    }

    private func universitySection(_ university: University) -> some View {
        let programs = PhdProgramsDataProvider.programs(for: university)
        return VStack(alignment: .leading, spacing: 8) {
            Text(university.shortName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.leading, 4)

            VStack(spacing: 8) {
                ForEach(programs, id: \.id) { program in
                    NavigationLink(destination: StudyProgramDetailView(program: program)) {
                        StudyProgramRowView(program: program)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct StudyProgramRowView: View {
    let program: PhdProgram

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "graduationcap")
                .font(.body)
                .foregroundStyle(AppColors.accent)
                .frame(width: 32, height: 32)
                .background(AppColors.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 3) {
                Text(program.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                Text("\(program.code) · \(program.fieldOfStudy)")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppColors.neutral)
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }
}
