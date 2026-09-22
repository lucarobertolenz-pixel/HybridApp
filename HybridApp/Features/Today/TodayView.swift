import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var healthKitManager = HealthKitManager.shared
    @Query(sort: \RunSession.date, order: .reverse) private var runs: [RunSession]

    @State private var observer: HealthKitObserver?
    @State private var isImporting = false
    @State private var authorizationError: String?

    var body: some View {
        NavigationStack {
            List {
                if let authorizationError {
                    Section {
                        Text(authorizationError)
                            .foregroundStyle(.orange)
                    }
                }
                Section("Läufe") {
                    if runs.isEmpty {
                        Text(isImporting ? "Läufe werden geladen…" : "Noch keine Läufe importiert.")
                            .foregroundStyle(Theme.secondaryText)
                    } else {
                        ForEach(runs) { run in
                            RunRow(run: run)
                        }
                    }
                }
            }
            .navigationTitle("Heute")
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .task {
                await setUpHealthKit()
            }
        }
    }

    private func setUpHealthKit() async {
        do {
            try await healthKitManager.requestAuthorization()
            let importer = WorkoutImporter(healthStore: healthKitManager.healthStore, modelContext: modelContext)
            isImporting = true
            try await importer.importNewRunningWorkouts()
            isImporting = false
            let observer = HealthKitObserver(healthStore: healthKitManager.healthStore, modelContext: modelContext)
            observer.start()
            self.observer = observer
        } catch {
            authorizationError = "Health-Zugriff nicht möglich: \(error.localizedDescription)"
            isImporting = false
        }
    }
}

private struct RunRow: View {
    let run: RunSession

    private var dateText: String {
        run.date.formatted(date: .abbreviated, time: .shortened)
    }

    private var distanceText: String {
        String(format: "%.1f km", run.distanceMeters / 1000)
    }

    private var durationText: String {
        let minutes = Int(run.duration) / 60
        let seconds = Int(run.duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateText)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
            HStack {
                Text(distanceText)
                Text("·")
                Text(durationText)
                if let hr = run.averageHeartRate {
                    Text("·")
                    Text("\(Int(hr)) bpm")
                }
            }
            .font(.headline)
        }
        .padding(.vertical, 4)
    }
}
