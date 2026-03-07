import Foundation

struct Certification: Identifiable, Codable {
    var id = UUID()
    var name: String
    var agency: CertAgency
    var dateObtained: Date
    var certNumber: String

    enum CertAgency: String, Codable, CaseIterable {
        case padi = "PADI"
        case ssi = "SSI"
        case naui = "NAUI"
        case sdi = "SDI"
        case bsac = "BSAC"
        case other = "Other"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateObtained)
    }

    static let commonCerts: [String] = [
        "Open Water Diver",
        "Advanced Open Water",
        "Rescue Diver",
        "Divemaster",
        "Enriched Air Nitrox",
        "Deep Diver",
        "Night Diver",
        "Wreck Diver",
        "Underwater Navigation",
        "Peak Performance Buoyancy",
        "Dry Suit Diver",
        "Search & Recovery",
    ]
}
