import Foundation
import SwiftData

struct ZoneDefinition: Codable, Hashable {
    let name: String
    let paceLowerSecondsPerKm: Double?
    let paceUpperSecondsPerKm: Double?
    let heartRateLower: Int?
    let heartRateUpper: Int?
}

@Model
final class Zones {
    var validFrom: Date
    var definitions: [ZoneDefinition]

    init(validFrom: Date, definitions: [ZoneDefinition]) {
        self.validFrom = validFrom
        self.definitions = definitions
    }
}
