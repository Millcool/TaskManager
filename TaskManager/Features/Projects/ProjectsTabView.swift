import SwiftUI

struct ProjectsTabView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.verticalSpacing) {
                    NavigationLink(destination: PhdProgramsListView()) {
                        HStack(spacing: 14) {
                            Image(systemName: "graduationcap.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(
                                    LinearGradient(
                                        colors: [AppColors.accent, Color(hex: "#7C3AED")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Аспирантура")
                                    .font(.headline)
                                    .foregroundStyle(AppColors.textPrimary)
                                Text("Программы аспирантуры в России")
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.textSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(AppColors.neutral)
                        }
                        .cardStyle()
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
                .padding(.top, 8)
            }
            .background(AppColors.background)
            .navigationTitle("Проекты")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
