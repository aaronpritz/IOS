import Foundation

/// A user-logged condition report for a dive site
struct SiteCondition: Identifiable, Codable {
    var id = UUID()
    var siteName: String
    var date: Date
    var waterTemp: Double?          // °F stored
    var visibility: Int?            // feet stored
    var currentStrength: CurrentLevel
    var surfaceConditions: SurfaceLevel
    var entryNotes: String
    var exitNotes: String
    var hazards: String
    var tips: String
    var overallRating: Int          // 1-5

    enum CurrentLevel: String, Codable, CaseIterable {
        case none = "None"
        case mild = "Mild"
        case moderate = "Moderate"
        case strong = "Strong"
        case extreme = "Extreme"

        var icon: String {
            switch self {
            case .none: return "water.waves"
            case .mild: return "water.waves"
            case .moderate: return "wind"
            case .strong: return "wind"
            case .extreme: return "tornado"
            }
        }
    }

    enum SurfaceLevel: String, Codable, CaseIterable {
        case calm = "Calm"
        case slight = "Slight Chop"
        case moderate = "Moderate"
        case rough = "Rough"
        case veryRough = "Very Rough"
    }

    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }

    static var example: SiteCondition {
        SiteCondition(
            siteName: "Blue Corner",
            date: Date(),
            waterTemp: 82,
            visibility: 80,
            currentStrength: .mild,
            surfaceConditions: .calm,
            entryNotes: "Giant stride from boat. Easy entry.",
            exitNotes: "Ladder exit. Wait for boat to stabilize.",
            hazards: "Mild surge near the wall at 60ft.",
            tips: "Stay close to the reef to avoid current.",
            overallRating: 4
        )
    }
}
