import Foundation
import SwiftData

@Model
final class CheckIn {
    var date: Date
    var fatigue: Int?
    var sleepQuality: Int?
    var hasPain: Bool
    var painLocation: String?
    var note: String?

    init(
        date: Date,
        fatigue: Int? = nil,
        sleepQuality: Int? = nil,
        hasPain: Bool = false,
        painLocation: String? = nil,
        note: String? = nil
    ) {
        self.date = date
        self.fatigue = fatigue
        self.sleepQuality = sleepQuality
        self.hasPain = hasPain
        self.painLocation = painLocation
        self.note = note
    }
}
