import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasCheckedForRestore") private var hasCheckedForRestore = false

    @State private var restoreCandidate: BackupFileManager.BackupFile?
    @State private var showRestorePrompt = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .sheet(isPresented: $showRestorePrompt) {
            if let backup = restoreCandidate {
                RestorePromptView(latestBackup: backup) {
                    hasCheckedForRestore = true
                }
            }
        }
        .onAppear {
            checkForRestore()
        }
    }

    private func checkForRestore() {
        guard !hasCheckedForRestore else { return }
        let goalsDescriptor = FetchDescriptor<Goal>()
        let rulesDescriptor = FetchDescriptor<Rule>()
        let goalsCount = (try? modelContext.fetchCount(goalsDescriptor)) ?? 0
        let rulesCount = (try? modelContext.fetchCount(rulesDescriptor)) ?? 0

        if goalsCount == 0 && rulesCount == 0,
           let latest = BackupCoordinator.shared.latestBackup() {
            restoreCandidate = latest
            showRestorePrompt = true
        } else {
            hasCheckedForRestore = true
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

            RulesTabView()
                .tabItem {
                    Label("Правила", systemImage: "list.bullet.rectangle.fill")
                }

            ProjectsTabView()
                .tabItem {
                    Label("Проекты", systemImage: "folder.fill")
                }

            StudyTabView()
                .tabItem {
                    Label("Учеба", systemImage: "books.vertical.fill")
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
