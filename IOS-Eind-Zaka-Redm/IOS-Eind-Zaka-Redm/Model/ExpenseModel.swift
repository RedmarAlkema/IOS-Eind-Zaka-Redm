import Foundation
import CoreLocation

struct Expense: Identifiable, Codable {
    var id: UUID = UUID()
    var amount: Double
    var currency: String
    var description: String
    var date: Date
    var location: LocationData?

    struct LocationData: Codable {
        var latitude: Double
        var longitude: Double

        func toCoordinate() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, amount, currency, description, date, location
    }
}
