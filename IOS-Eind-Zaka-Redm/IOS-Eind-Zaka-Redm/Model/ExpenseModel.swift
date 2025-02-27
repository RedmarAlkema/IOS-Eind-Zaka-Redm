import Foundation
import CoreLocation

import Foundation

struct Expense: Identifiable, Codable {
    var id: UUID = UUID()
    var amount: Double
    var currency: String
    var description: String
    var date: Date
}
