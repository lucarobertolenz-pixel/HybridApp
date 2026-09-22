import Foundation
import SwiftData

enum GoalDistance: String, Codable, CaseIterable {
    case tenK
    case halfMarathon
    case marathon
}

@Model
final class Goal {
    var distance: GoalDistance
    var date: Date
    var targetTimeSeconds: Double?

    init(distance: GoalDistance, date: Date, targetTimeSeconds: Double? = nil) {
        self.distance = distance
        self.date = date
        self.targetTimeSeconds = targetTimeSeconds
    }
}
