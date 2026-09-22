import SwiftUI
import SwiftData

@main
struct HybridAppApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(
                for: Schema([
                    RunSession.self,
                    Exercise.self,
                    SetEntry.self,
                    StrengthSession.self,
                    CheckIn.self,
                    ReferenceValues.self,
                    Zones.self,
                    PlannedWorkout.self,
                    AthleteStatusSnapshot.self,
                    Goal.self,
                ])
            )
        } catch {
            fatalError("SwiftData ModelContainer konnte nicht erstellt werden: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppShell()
        }
        .modelContainer(modelContainer)
    }
}
