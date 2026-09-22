import Foundation
import SwiftData

@Model
final class AthleteStatusSnapshot {
    var date: Date
    var metricsJSON: String
    var signals: [String]

    init(date: Date, metricsJSON: String, signals: [String] = []) {
        self.date = date
        self.metricsJSON = metricsJSON
        self.signals = signals
    }
}
