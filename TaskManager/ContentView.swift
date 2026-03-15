import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            GoalsTabView()
                .tabItem {
                    Label("Цели", systemImage: "target")
                }

            StatisticsTabView()
                .tabItem {
                    Label("Статистика", systemImage: "chart.bar.fill")
                }

            SettingsTabView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(AppColors.accent)
    }
}
