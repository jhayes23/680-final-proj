import Foundation

struct WateringReminder: Hashable, Identifiable {
    let id: UUID
    var refId: Int
    let nextWatering: Date
    let repeatWatering: Bool
}
