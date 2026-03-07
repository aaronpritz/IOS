import Foundation

/// A dive buddy contact
struct DiveBuddy: Identifiable, Codable {
    var id = UUID()
    var name: String
    var certLevel: String       // e.g. "AOW", "Rescue", "Divemaster"
    var phone: String
    var email: String
    var notes: String
    var isFavorite: Bool

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    static var example: DiveBuddy {
        DiveBuddy(
            name: "Alex Rivera",
            certLevel: "AOW",
            phone: "+1 555-0123",
            email: "alex@example.com",
            notes: "Great underwater photographer",
            isFavorite: true
        )
    }
}
