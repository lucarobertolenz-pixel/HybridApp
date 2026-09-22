import Foundation
import SwiftData

enum RunCategory: String, Codable, CaseIterable {
    case easy
    case subThreshold
    case threshold
    case vo2max
    case longRun
    case competition
    case uncategorized
}

enum HeartRateSource: String, Codable {
    case wristOptical
    case chestStrap
    case unknown
}

struct RunSplit: Codable, Hashable {
    let index: Int
    let distanceMeters: Double
    let duration: TimeInterval
    let averageHeartRate: Double?
    let isPaceOutlier: Bool
}

@Model
final class RunSession {
    @Attribute(.unique) var healthKitUUID: UUID
    var date: Date
    var duration: TimeInterval
    var distanceMeters: Double
    var averageHeartRate: Double?
    var elevationGainMeters: Double?
    var splits: [RunSplit]
    var category: RunCategory
    var rpe: Int?
    var heartRateSource: HeartRateSource
    var note: String?

    init(
        healthKitUUID: UUID,
        date: Date,
        duration: TimeInterval,
        distanceMeters: Double,
        averageHeartRate: Double? = nil,
        elevationGainMeters: Double? = nil,
        splits: [RunSplit] = [],
        category: RunCategory = .uncategorized,
        rpe: Int? = nil,
        heartRateSource: HeartRateSource = .unknown,
        note: String? = nil
    ) {
        self.healthKitUUID = healthKitUUID
        self.date = date
        self.duration = duration
        self.distanceMeters = distanceMeters
        self.averageHeartRate = averageHeartRate
        self.elevationGainMeters = elevationGainMeters
        self.splits = splits
        self.category = category
        self.rpe = rpe
        self.heartRateSource = heartRateSource
        self.note = note
    }
}
