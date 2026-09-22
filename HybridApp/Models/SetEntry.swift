import Foundation
import SwiftData

@Model
final class SetEntry {
    var exercise: Exercise?
    var reps: Int
    var weightKg: Double
    var rpe: Double?

    init(exercise: Exercise? = nil, reps: Int, weightKg: Double, rpe: Double? = nil) {
        self.exercise = exercise
        self.reps = reps
        self.weightKg = weightKg
        self.rpe = rpe
    }
}
