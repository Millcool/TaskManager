import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                TabView(selection: $viewModel.currentPage) {
                    welcomePage.tag(0)
                    notificationPage.tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentPage)

                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? AppColors.accent : AppColors.neutral)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)

                // Button
                Button {
                    if viewModel.isLastPage {
                        viewModel.completeOnboarding()
                        hasCompletedOnboarding = true
                    } else {
                        withAnimation {
                            viewModel.nextPage()
                        }
                    }
                } label: {
                    Text(viewModel.isLastPage ? "Начать" : "Далее")
                        .accentButtonStyle()
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
                .padding(.bottom, 40)
            }
        }
    }

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Image(systemName: "target")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.accent)

            Text("Task Manager")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text("Ваш личный менеджер целей.\nСтавьте цели на день, неделю, месяц и год.\nОтслеживайте прогресс и достигайте большего.")
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var notificationPage: some View {
        VStack(spacing: 24) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.accent)

            Text("Уведомления")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text("Разрешите уведомления, чтобы получать\nнапоминания о планировании целей\nи не забывать о важном.")
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                Task {
                    await viewModel.requestNotifications()
                }
            } label: {
                Label("Разрешить уведомления", systemImage: "bell")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.accent)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(AppColors.accent.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }
}
