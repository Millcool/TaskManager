import SwiftUI
import SwiftData

@main
struct TaskManagerApp: App {
    let container: ModelContainer
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("appTheme") private var appTheme = "dark"

    init() {
        do {
            let config = ModelConfiguration(
                "TaskManager",
                cloudKitDatabase: .automatic
            )
            container = try ModelContainer(
                for: Goal.self, Category.self, GoalReminder.self, Rule.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        BackupScheduler.register(modelContainer: container)
    }

    private var colorScheme: ColorScheme? {
        switch appTheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme)
        }
        .modelContainer(container)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                BackupScheduler.scheduleNext()
            case .active:
                Task { @MainActor in
                    await BackupScheduler.runIfDue(container: container)
                }
            default:
                break
            }
        }
    }
}
