import SwiftUI
import SwiftData

@main
struct TaskManagerApp: App {
    let container: ModelContainer
    @AppStorage("appTheme") private var appTheme = "dark"

    init() {
        do {
            let config = ModelConfiguration(
                "TaskManager",
                cloudKitDatabase: .automatic
            )
            container = try ModelContainer(
                for: Goal.self, Category.self, GoalReminder.self,
                migrationPlan: MigrationPlan.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
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
    }
}
