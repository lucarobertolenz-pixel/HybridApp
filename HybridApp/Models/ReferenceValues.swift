import Foundation
import SwiftData

enum ReferenceValueConfidence: String, Codable {
    case high
    case medium
    case low
}

@Model
final class ReferenceValues {
    var date: Date
    var lt2PaceSecondsPerKm: Double
    var lt2HeartRate: Int
    var lt1HeartRate: Int
    var maxHeartRate: Int
    var vo2max: Double?
    var source: String
    var confidence: ReferenceValueConfidence

    init(
        date: Date,
        lt2PaceSecondsPerKm: Double,
        lt2HeartRate: Int,
        lt1HeartRate: Int,
        maxHeartRate: Int,
        vo2max: Double? = nil,
        source: String,
        confidence: ReferenceValueConfidence
    ) {
        self.date = date
        self.lt2PaceSecondsPerKm = lt2PaceSecondsPerKm
        self.lt2HeartRate = lt2HeartRate
        self.lt1HeartRate = lt1HeartRate
        self.maxHeartRate = maxHeartRate
        self.vo2max = vo2max
        self.source = source
        self.confidence = confidence
    }
}
