import Foundation

struct DiveSite: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let country: String
    let region: DiveRegion
    let description: String
    let maxDepthFeet: Int
    let difficulty: DiveDifficulty
    let highlights: [String]
    let bestMonths: String
    let waterTempRangeFahrenheit: String
    let visibilityFeet: String
    let rating: Double // 1.0 - 5.0

    enum DiveRegion: String, CaseIterable {
        case caribbean = "Caribbean"
        case southeastAsia = "Southeast Asia"
        case pacific = "Pacific"
        case redSea = "Red Sea"
        case americas = "Americas"
    }

    enum DiveDifficulty: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"

        var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "orange"
            case .advanced: return "red"
            }
        }
    }

    static let allSites: [DiveSite] = [
        // Caribbean
        DiveSite(
            name: "Blue Hole",
            location: "Lighthouse Reef",
            country: "Belize",
            region: .caribbean,
            description: "A giant marine sinkhole off the coast of Belize. The perfectly circular hole is over 980 feet across and 410 feet deep. Famous for its crystal-clear waters and stalactite formations at depth.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Stalactites", "Reef sharks", "Giant grouper", "Wall diving"],
            bestMonths: "Apr - Jun",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "100+ ft",
            rating: 4.7
        ),
        DiveSite(
            name: "Palancar Reef",
            location: "Cozumel",
            country: "Mexico",
            region: .caribbean,
            description: "One of the world's top dive sites with dramatic swim-throughs, tunnels, and massive coral formations. Strong currents make for exciting drift diving along colorful walls.",
            maxDepthFeet: 80,
            difficulty: .intermediate,
            highlights: ["Drift diving", "Swim-throughs", "Sea turtles", "Eagle rays"],
            bestMonths: "Mar - Jun",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "80-100 ft",
            rating: 4.8
        ),
        DiveSite(
            name: "Bloody Bay Wall",
            location: "Little Cayman",
            country: "Cayman Islands",
            region: .caribbean,
            description: "One of the most spectacular wall dives in the Caribbean. The wall drops from 20 feet to over 6,000 feet. Pristine coral, sponges, and abundant marine life.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Wall dive", "Sponge gardens", "Turtles", "Pristine coral"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "100+ ft",
            rating: 4.6
        ),

        // Southeast Asia
        DiveSite(
            name: "USS Liberty Wreck",
            location: "Tulamben, Bali",
            country: "Indonesia",
            region: .southeastAsia,
            description: "A WWII cargo ship torpedoed in 1942, now lying just off the beach in shallow water. Covered in coral and teeming with fish. One of the most accessible wreck dives in the world.",
            maxDepthFeet: 100,
            difficulty: .beginner,
            highlights: ["Wreck diving", "Shore entry", "Coral growth", "Pygmy seahorses"],
            bestMonths: "Apr - Nov",
            waterTempRangeFahrenheit: "78-82°F",
            visibilityFeet: "50-100 ft",
            rating: 4.5
        ),
        DiveSite(
            name: "Blue Corner",
            location: "Palau",
            country: "Palau",
            region: .southeastAsia,
            description: "Considered one of the best dive sites on Earth. A submerged reef corner where strong currents bring in huge schools of fish, sharks, and pelagics. Hook in and enjoy the show.",
            maxDepthFeet: 90,
            difficulty: .advanced,
            highlights: ["Grey reef sharks", "Napoleon wrasse", "Strong currents", "Hook diving"],
            bestMonths: "Oct - May",
            waterTempRangeFahrenheit: "80-84°F",
            visibilityFeet: "80-100 ft",
            rating: 4.9
        ),
        DiveSite(
            name: "Richelieu Rock",
            location: "Surin Islands",
            country: "Thailand",
            region: .southeastAsia,
            description: "A horseshoe-shaped pinnacle covered in purple soft corals. Famous as one of the best places in the world to see whale sharks, plus incredible macro life.",
            maxDepthFeet: 115,
            difficulty: .intermediate,
            highlights: ["Whale sharks", "Soft corals", "Seahorses", "Macro life"],
            bestMonths: "Feb - May",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "50-80 ft",
            rating: 4.8
        ),

        // Pacific
        DiveSite(
            name: "Great Barrier Reef",
            location: "Cairns / Ribbon Reefs",
            country: "Australia",
            region: .pacific,
            description: "The world's largest coral reef system, stretching over 1,400 miles. Home to incredible biodiversity including over 1,500 species of fish and 400 types of coral.",
            maxDepthFeet: 100,
            difficulty: .beginner,
            highlights: ["Coral gardens", "Clownfish", "Manta rays", "Giant clams"],
            bestMonths: "Jun - Oct",
            waterTempRangeFahrenheit: "73-84°F",
            visibilityFeet: "50-100 ft",
            rating: 4.7
        ),
        DiveSite(
            name: "Navy Pier",
            location: "Exmouth",
            country: "Australia",
            region: .pacific,
            description: "A working navy pier that's considered one of Australia's best shore dives. The pier pilings create an artificial reef attracting huge schools of fish and large marine life.",
            maxDepthFeet: 40,
            difficulty: .beginner,
            highlights: ["Wobbegong sharks", "Giant grouper", "Octopus", "Nudibranchs"],
            bestMonths: "Mar - Oct",
            waterTempRangeFahrenheit: "70-80°F",
            visibilityFeet: "30-65 ft",
            rating: 4.6
        ),

        // Red Sea
        DiveSite(
            name: "Ras Mohammed",
            location: "Sharm el-Sheikh",
            country: "Egypt",
            region: .redSea,
            description: "A national park at the southern tip of the Sinai Peninsula. Shark Reef and Yolanda Reef offer stunning wall dives, massive fan corals, and the remains of a cargo ship.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Wall diving", "Barracuda schools", "Fan corals", "Yolanda wreck cargo"],
            bestMonths: "Mar - May, Sep - Nov",
            waterTempRangeFahrenheit: "70-82°F",
            visibilityFeet: "65-100 ft",
            rating: 4.7
        ),
        DiveSite(
            name: "SS Thistlegorm",
            location: "Strait of Gubal",
            country: "Egypt",
            region: .redSea,
            description: "A WWII British cargo ship sunk in 1941. One of the world's top wreck dives, with motorcycles, trucks, locomotives, and ammunition still visible inside the holds.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["WWII wreck", "Motorcycles & trucks", "Penetration diving", "Batfish schools"],
            bestMonths: "Mar - May, Sep - Nov",
            waterTempRangeFahrenheit: "72-82°F",
            visibilityFeet: "50-80 ft",
            rating: 4.8
        ),

        // Americas
        DiveSite(
            name: "Cenote Dos Ojos",
            location: "Riviera Maya",
            country: "Mexico",
            region: .americas,
            description: "A stunning freshwater cenote with crystal-clear visibility. Two connected sinkholes (\"Two Eyes\") with dramatic light beams, stalactites, and halocline effects.",
            maxDepthFeet: 33,
            difficulty: .beginner,
            highlights: ["Crystal clear water", "Light beams", "Stalactites", "Halocline"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "77°F",
            visibilityFeet: "100+ ft",
            rating: 4.7
        ),
        DiveSite(
            name: "Molokini Crater",
            location: "Maui",
            country: "USA",
            region: .americas,
            description: "A partially submerged volcanic crater forming a natural crescent-shaped reef. The back wall drops to 350 feet with pelagic visitors, while inside is calm with great vis.",
            maxDepthFeet: 100,
            difficulty: .beginner,
            highlights: ["Volcanic crater", "Manta rays", "White-tip sharks", "Calm conditions"],
            bestMonths: "Apr - Nov",
            waterTempRangeFahrenheit: "75-80°F",
            visibilityFeet: "100-150 ft",
            rating: 4.5
        ),
    ]

    static func sites(for region: DiveRegion) -> [DiveSite] {
        allSites.filter { $0.region == region }
    }
}
