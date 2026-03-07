import Foundation

/// A single dive log entry
/// All measurements stored internally in Imperial units (feet, °F)
struct Dive: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var location: String
    var diveSite: String
    var maxDepth: Double      // stored in feet
    var bottomTime: Int       // in minutes
    var waterTemp: Double?    // stored in °F
    var visibility: Int?      // stored in feet
    var buddyName: String
    var notes: String
    var rating: Int           // 1-5 stars

    // Phase 5 additions
    var currentStrength: CurrentStrength?
    var entryType: EntryType?

    // Phase 7 - Photos
    var photoFilenames: [String]?

    // Phase 9 - Species Log
    var speciesSightings: [SpeciesSighting]?

    enum CurrentStrength: String, Codable, CaseIterable {
        case none = "None"
        case mild = "Mild"
        case moderate = "Moderate"
        case strong = "Strong"
    }

    enum EntryType: String, Codable, CaseIterable {
        case shore = "Shore"
        case boat = "Boat"
        case pier = "Pier / Dock"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var bottomTimeDisplay: String {
        "\(bottomTime) min"
    }

    static var example: Dive {
        Dive(
            date: Date(),
            location: "Bali, Indonesia",
            diveSite: "Blue Corner",
            maxDepth: 80,
            bottomTime: 48,
            waterTemp: 82,
            visibility: 65,
            buddyName: "Alex",
            notes: "Amazing coral formations and saw a manta ray!",
            rating: 5,
            currentStrength: .mild,
            entryType: .boat
        )
    }

    static var sampleDives: [Dive] {
        [
            Dive(
                date: Date(),
                location: "Bali, Indonesia",
                diveSite: "Blue Corner",
                maxDepth: 80,
                bottomTime: 48,
                waterTemp: 82,
                visibility: 65,
                buddyName: "Alex",
                notes: "Amazing coral formations and saw a manta ray!",
                rating: 5,
                currentStrength: .mild,
                entryType: .boat
            ),
            Dive(
                date: Date().addingTimeInterval(-86400),
                location: "Bali, Indonesia",
                diveSite: "USS Liberty Wreck",
                maxDepth: 60,
                bottomTime: 55,
                waterTemp: 81,
                visibility: 50,
                buddyName: "Sam",
                notes: "Great wreck dive, lots of fish life around the hull.",
                rating: 4,
                currentStrength: .none,
                entryType: .shore
            ),
            Dive(
                date: Date().addingTimeInterval(-172800),
                location: "Cozumel, Mexico",
                diveSite: "Palancar Reef",
                maxDepth: 72,
                bottomTime: 42,
                waterTemp: 79,
                visibility: 100,
                buddyName: "Jordan",
                notes: "Crystal clear water. Saw a nurse shark resting under a ledge.",
                rating: 5,
                currentStrength: .moderate,
                entryType: .boat
            ),
            Dive(
                date: Date().addingTimeInterval(-604800),
                location: "Red Sea, Egypt",
                diveSite: "Ras Mohammed",
                maxDepth: 100,
                bottomTime: 35,
                waterTemp: 75,
                visibility: 80,
                buddyName: "Chris",
                notes: "Strong current but incredible wall dive with huge fans.",
                rating: 4,
                currentStrength: .strong,
                entryType: .boat
            )
        ]
    }
}
