import Foundation
import SwiftData

enum MuscleGroup: String, Codable, CaseIterable {
    case legs
    case back
    case chest
    case shoulders
    case arms
    case core
    case fullBody
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case compound
    case isolation
    case plyometric
    case mobility
}

@Model
final class Exercise {
    @Attribute(.unique) var name: String
    var muscleGroup: MuscleGroup
    var category: ExerciseCategory

    init(name: String, muscleGroup: MuscleGroup, category: ExerciseCategory) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.category = category
    }
}
