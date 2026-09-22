import Foundation
import HealthKit
import SwiftData

/// Beobachtet HealthKit im Hintergrund und importiert neue Laufworkouts automatisch,
/// sobald sie in Apple Health erscheinen (z. B. Sync von Garmin/Coros).
@MainActor
final class HealthKitObserver {
    private let healthStore: HKHealthStore
    private let modelContext: ModelContext
    private var observerQuery: HKObserverQuery?

    init(healthStore: HKHealthStore, modelContext: ModelContext) {
        self.healthStore = healthStore
        self.modelContext = modelContext
    }

    func start() {
        let query = HKObserverQuery(sampleType: .workoutType(), predicate: nil) { [weak self] _, completionHandler, error in
            guard let self, error == nil else {
                completionHandler()
                return
            }
            Task { @MainActor in
                let importer = WorkoutImporter(healthStore: self.healthStore, modelContext: self.modelContext)
                try? await importer.importNewRunningWorkouts()
                completionHandler()
            }
        }
        observerQuery = query
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: .workoutType(), frequency: .immediate) { _, _ in }
    }

    func stop() {
        if let observerQuery {
            healthStore.stop(observerQuery)
        }
    }
}
