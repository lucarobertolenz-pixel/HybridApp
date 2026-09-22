import Foundation
@preconcurrency import HealthKit
import SwiftData

/// Lädt Laufworkouts aus HealthKit, reichert sie mit Pulsdaten an und speichert
/// sie dedupliziert (über healthKitUUID) als RunSession in SwiftData.
@MainActor
final class WorkoutImporter {
    private let healthStore: HKHealthStore
    private let modelContext: ModelContext

    init(healthStore: HKHealthStore, modelContext: ModelContext) {
        self.healthStore = healthStore
        self.modelContext = modelContext
    }

    func importNewRunningWorkouts() async throws {
        let workouts = try await fetchRunningWorkouts()
        for workout in workouts {
            guard !runSessionExists(for: workout.uuid) else { continue }
            let session = try await buildRunSession(from: workout)
            modelContext.insert(session)
        }
        try modelContext.save()
    }

    private func runSessionExists(for uuid: UUID) -> Bool {
        let descriptor = FetchDescriptor<RunSession>(
            predicate: #Predicate { $0.healthKitUUID == uuid }
        )
        return ((try? modelContext.fetchCount(descriptor)) ?? 0) > 0
    }

    private func fetchRunningWorkouts() async throws -> [HKWorkout] {
        try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForWorkouts(with: .running)
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: (samples as? [HKWorkout]) ?? [])
            }
            healthStore.execute(query)
        }
    }

    private func buildRunSession(from workout: HKWorkout) async throws -> RunSession {
        let heartRateSamples = try await fetchHeartRateSamples(start: workout.startDate, end: workout.endDate)
        let averageHeartRate = averageValue(of: heartRateSamples)
        let splits = buildSplits(from: workout, heartRateSamples: heartRateSamples)
        let distanceMeters = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
        let elevation = workout.metadata?[HKMetadataKeyElevationAscended] as? HKQuantity
        return RunSession(
            healthKitUUID: workout.uuid,
            date: workout.startDate,
            duration: workout.duration,
            distanceMeters: distanceMeters,
            averageHeartRate: averageHeartRate,
            elevationGainMeters: elevation?.doubleValue(for: .meter()),
            splits: splits,
            category: .uncategorized,
            heartRateSource: heartRateSource(from: heartRateSamples)
        )
    }

    private func fetchHeartRateSamples(start: Date, end: Date) async throws -> [HKQuantitySample] {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return [] }
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
            let query = HKSampleQuery(
                sampleType: heartRateType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: (samples as? [HKQuantitySample]) ?? [])
            }
            healthStore.execute(query)
        }
    }

    private func averageValue(of samples: [HKQuantitySample]) -> Double? {
        guard !samples.isEmpty else { return nil }
        let unit = HKUnit.count().unitDivided(by: .minute())
        let sum = samples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: unit) }
        return sum / Double(samples.count)
    }

    /// Näherung: Apple Watch liefert Puls über den optischen Handgelenksensor;
    /// andere Gerätenamen (z. B. Brustgurt-Apps) werden als externe Quelle gewertet.
    /// Feinere Einordnung folgt in der Analyse-Engine (Phase 2, siehe UpdateAgentRunning.md).
    private func heartRateSource(from samples: [HKQuantitySample]) -> HeartRateSource {
        guard let device = samples.first?.device else { return .unknown }
        if let model = device.model, model.localizedCaseInsensitiveContains("watch") {
            return .wristOptical
        }
        return .chestStrap
    }

    /// Phase 1: grobe 1-km-Splits aus Gesamtdistanz/-dauer. Echte GPS-Split-Grenzen
    /// und Ausreisser-Erkennung (> 20 % Tempoabweichung) folgen mit der Routenauswertung in Phase 2.
    private func buildSplits(from workout: HKWorkout, heartRateSamples: [HKQuantitySample]) -> [RunSplit] {
        guard let totalDistance = workout.totalDistance?.doubleValue(for: .meter()), totalDistance > 0 else {
            return []
        }
        let splitCount = max(1, Int(totalDistance / 1000))
        let splitDuration = workout.duration / Double(splitCount)
        return (0..<splitCount).map { index in
            let splitStart = workout.startDate.addingTimeInterval(Double(index) * splitDuration)
            let splitEnd = splitStart.addingTimeInterval(splitDuration)
            let hrInSplit = heartRateSamples.filter { $0.startDate >= splitStart && $0.startDate < splitEnd }
            return RunSplit(
                index: index,
                distanceMeters: min(1000, totalDistance - Double(index) * 1000),
                duration: splitDuration,
                averageHeartRate: averageValue(of: hrInSplit),
                isPaceOutlier: false
            )
        }
    }
}
