import Foundation
import SwiftData

enum PlannedWorkoutType: String, Codable {
    case easy
    case subThreshold
    case threshold
    case vo2max
    case longRun
    case competition
    case strength
    case rest
}

enum PlannedWorkoutStatus: String, Codable {
    case planned
    case completed
    case missed
    case moved
}

@Model
final class PlannedWorkout {
    var date: Date
    var type: PlannedWorkoutType
    var structureJSON: String
    var targetPaceDescription: String?
    var targetHeartRateDescription: String?
    var status: PlannedWorkoutStatus
    var linkedRunSessionID: PersistentIdentifier?

    init(
        date: Date,
        type: PlannedWorkoutType,
        structureJSON: String,
        targetPaceDescription: String? = nil,
        targetHeartRateDescription: String? = nil,
        status: PlannedWorkoutStatus = .planned,
        linkedRunSessionID: PersistentIdentifier? = nil
    ) {
        self.date = date
        self.type = type
        self.structureJSON = structureJSON
        self.targetPaceDescription = targetPaceDescription
        self.targetHeartRateDescription = targetHeartRateDescription
        self.status = status
        self.linkedRunSessionID = linkedRunSessionID
    }
}
