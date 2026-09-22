import Foundation
import SwiftData

@Model
final class StrengthSession {
    var date: Date
    @Relationship(deleteRule: .cascade) var sets: [SetEntry]
    var rpe: Double?
    var note: String?

    init(date: Date, sets: [SetEntry] = [], rpe: Double? = nil, note: String? = nil) {
        self.date = date
        self.sets = sets
        self.rpe = rpe
        self.note = note
    }
}
