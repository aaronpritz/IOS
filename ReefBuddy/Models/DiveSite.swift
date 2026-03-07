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
    var latitude: Double = 0
    var longitude: Double = 0

    enum DiveRegion: String, CaseIterable {
        case caribbean = "Caribbean"
        case southeastAsia = "Southeast Asia"
        case pacific = "Pacific"
        case redSea = "Red Sea"
        case americas = "Americas"
        case mediterranean = "Mediterranean"
        case indianOcean = "Indian Ocean"
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
        // ═══════════════════════════════════════════
        // CARIBBEAN (15 sites)
        // ═══════════════════════════════════════════
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
            rating: 4.7,
            latitude: 17.3161, longitude: -87.5347
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
            rating: 4.8,
            latitude: 20.3500, longitude: -87.0333
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
            rating: 4.6,
            latitude: 19.7000, longitude: -80.0667
        ),
        DiveSite(
            name: "Shark Wall",
            location: "Roatan",
            country: "Honduras",
            region: .caribbean,
            description: "A dramatic wall dive where Caribbean reef sharks patrol the deep blue. The wall starts at 30 feet and drops to thousands. Huge barrel sponges and gorgonians line the edge.",
            maxDepthFeet: 110,
            difficulty: .intermediate,
            highlights: ["Reef sharks", "Wall dive", "Barrel sponges", "Gorgonians"],
            bestMonths: "Mar - Sep",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "80-120 ft",
            rating: 4.5,
            latitude: 16.3200, longitude: -86.5400
        ),
        DiveSite(
            name: "Bianca C Wreck",
            location: "St. George's",
            country: "Grenada",
            region: .caribbean,
            description: "The 'Titanic of the Caribbean.' This 600-foot Italian cruise liner sank in 1961 and sits at 165 feet. The largest wreck in the Caribbean, covered in coral and frequented by large pelagics.",
            maxDepthFeet: 165,
            difficulty: .advanced,
            highlights: ["Massive wreck", "Pelagics", "Coral encrusted", "Deep dive"],
            bestMonths: "Jan - May",
            waterTempRangeFahrenheit: "78-83°F",
            visibilityFeet: "40-80 ft",
            rating: 4.6,
            latitude: 12.0500, longitude: -61.7500
        ),
        DiveSite(
            name: "Salt Pier",
            location: "Kralendijk",
            country: "Bonaire",
            region: .caribbean,
            description: "Dive under a working salt loading pier where massive pilings are covered in orange cup corals, sponges, and attract seahorses, frogfish, and octopus. One of the best shore dives in the world.",
            maxDepthFeet: 60,
            difficulty: .beginner,
            highlights: ["Shore dive", "Seahorses", "Frogfish", "Orange cup coral"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "60-100 ft",
            rating: 4.7,
            latitude: 12.0800, longitude: -68.2800
        ),
        DiveSite(
            name: "Thunderball Grotto",
            location: "Exuma Cays",
            country: "Bahamas",
            region: .caribbean,
            description: "Made famous by the James Bond film. A stunning underwater cave with light beams streaming through openings. Schools of tropical fish swirl inside the grotto.",
            maxDepthFeet: 15,
            difficulty: .beginner,
            highlights: ["Light beams", "Cave snorkel", "Tropical fish", "Film location"],
            bestMonths: "Nov - Jul",
            waterTempRangeFahrenheit: "75-84°F",
            visibilityFeet: "60-100 ft",
            rating: 4.4,
            latitude: 23.8600, longitude: -76.3000
        ),
        DiveSite(
            name: "Kittiwake Wreck",
            location: "Seven Mile Beach",
            country: "Cayman Islands",
            region: .caribbean,
            description: "A 251-foot US Navy submarine rescue vessel deliberately sunk in 2011. Sitting in just 65 feet of water, it's fully penetrable with multiple decks and chambers to explore.",
            maxDepthFeet: 65,
            difficulty: .intermediate,
            highlights: ["Wreck penetration", "Shallow wreck", "Marine growth", "Multi-deck"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "80-100 ft",
            rating: 4.5,
            latitude: 19.3600, longitude: -81.3900
        ),
        DiveSite(
            name: "Shark's Cove",
            location: "North Shore, Oahu",
            country: "USA",
            region: .caribbean,
            description: "A lava rock formation creating a protected cove perfect for diving. Swim-throughs, tunnels, and lava tubes teeming with eels, octopus, and nudibranchs.",
            maxDepthFeet: 45,
            difficulty: .beginner,
            highlights: ["Lava tubes", "Octopus", "Nudibranchs", "Shore dive"],
            bestMonths: "May - Sep",
            waterTempRangeFahrenheit: "75-80°F",
            visibilityFeet: "30-60 ft",
            rating: 4.3,
            latitude: 21.6500, longitude: -158.0640
        ),
        DiveSite(
            name: "Tobago Cays",
            location: "Grenadines",
            country: "St. Vincent",
            region: .caribbean,
            description: "A cluster of small uninhabited islands with pristine reefs. Sea turtles are almost guaranteed on every dive. Crystal clear waters and healthy hard coral gardens.",
            maxDepthFeet: 50,
            difficulty: .beginner,
            highlights: ["Sea turtles", "Pristine reef", "Crystal water", "Uninhabited islands"],
            bestMonths: "Jan - May",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "60-100 ft",
            rating: 4.5,
            latitude: 12.6300, longitude: -61.3600
        ),
        DiveSite(
            name: "The Hilma Hooker",
            location: "Kralendijk",
            country: "Bonaire",
            region: .caribbean,
            description: "A 236-foot cargo vessel that sank under mysterious circumstances in 1984. Sitting upright in 100 feet of sand, it's one of the Caribbean's most photogenic wrecks.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Intact wreck", "Upright position", "Sponge covered", "Night dive"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "60-100 ft",
            rating: 4.6,
            latitude: 12.1500, longitude: -68.2700
        ),
        DiveSite(
            name: "Stingray City",
            location: "North Sound",
            country: "Cayman Islands",
            region: .caribbean,
            description: "A shallow sandbar where dozens of southern stingrays gather. Interact with gentle rays in crystal-clear waist-deep water — one of the most unique dive experiences anywhere.",
            maxDepthFeet: 12,
            difficulty: .beginner,
            highlights: ["Stingray interaction", "Shallow water", "Sandy bottom", "Family friendly"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "60-100 ft",
            rating: 4.7,
            latitude: 19.3800, longitude: -81.3000
        ),

        // ═══════════════════════════════════════════
        // SOUTHEAST ASIA (15 sites)
        // ═══════════════════════════════════════════
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
            rating: 4.5,
            latitude: -8.2756, longitude: 115.5958
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
            rating: 4.9,
            latitude: 7.1334, longitude: 134.2218
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
            rating: 4.8,
            latitude: 9.3600, longitude: 98.0200
        ),
        DiveSite(
            name: "Barracuda Point",
            location: "Sipadan Island",
            country: "Malaysia",
            region: .southeastAsia,
            description: "One of the world's top dive sites. A coral wall dropping 2,000 feet into the abyss. Famous for massive tornado-like formations of barracuda and enormous schools of jackfish.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Barracuda tornado", "Jackfish school", "White-tip sharks", "Sea turtles"],
            bestMonths: "Apr - Dec",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "60-130 ft",
            rating: 4.9,
            latitude: 4.1149, longitude: 118.6292
        ),
        DiveSite(
            name: "Tubbataha Reef",
            location: "Sulu Sea",
            country: "Philippines",
            region: .southeastAsia,
            description: "A UNESCO World Heritage Site and one of the Philippines' premier dive destinations. Remote atolls with pristine walls, huge pelagics, and some of the healthiest reefs in the Coral Triangle.",
            maxDepthFeet: 130,
            difficulty: .intermediate,
            highlights: ["UNESCO site", "Hammerheads", "Manta rays", "Pristine walls"],
            bestMonths: "Mar - Jun",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "80-130 ft",
            rating: 4.8,
            latitude: 8.9300, longitude: 119.9000
        ),
        DiveSite(
            name: "Manta Point",
            location: "Nusa Penida, Bali",
            country: "Indonesia",
            region: .southeastAsia,
            description: "A cleaning station where oceanic manta rays come to be groomed by cleaner wrasse. Mantas with wingspans up to 16 feet glide overhead. Strong currents and cold upwellings.",
            maxDepthFeet: 60,
            difficulty: .intermediate,
            highlights: ["Oceanic mantas", "Cleaning station", "Strong current", "Mola mola (seasonal)"],
            bestMonths: "Jul - Nov",
            waterTempRangeFahrenheit: "68-78°F",
            visibilityFeet: "30-80 ft",
            rating: 4.7,
            latitude: -8.7400, longitude: 115.4500
        ),
        DiveSite(
            name: "Sail Rock",
            location: "Koh Phangan",
            country: "Thailand",
            region: .southeastAsia,
            description: "A massive underwater pinnacle rising from 130 feet to break the surface. A vertical chimney swim-through and regular whale shark sightings make this the Gulf of Thailand's best dive.",
            maxDepthFeet: 130,
            difficulty: .intermediate,
            highlights: ["Whale sharks", "Chimney swim-through", "Pinnacle", "Barracuda"],
            bestMonths: "Mar - Oct",
            waterTempRangeFahrenheit: "79-84°F",
            visibilityFeet: "30-65 ft",
            rating: 4.5,
            latitude: 9.9500, longitude: 100.0500
        ),
        DiveSite(
            name: "Raja Ampat — Cape Kri",
            location: "Raja Ampat",
            country: "Indonesia",
            region: .southeastAsia,
            description: "Holds the world record for most fish species counted on a single dive (374). The Coral Triangle's crown jewel with unmatched biodiversity, pristine reefs, and dramatic currents.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["World-record biodiversity", "Pristine reef", "Schools of fish", "Wobbegong sharks"],
            bestMonths: "Oct - Apr",
            waterTempRangeFahrenheit: "80-84°F",
            visibilityFeet: "50-100 ft",
            rating: 4.9,
            latitude: -0.5500, longitude: 130.6800
        ),
        DiveSite(
            name: "Coron Wrecks",
            location: "Coron, Palawan",
            country: "Philippines",
            region: .southeastAsia,
            description: "A fleet of Japanese WWII warships sunk by US bombers in 1944. At least 12 wrecks in a small area ranging from 30 to 130 feet, many penetrable. A wreck diver's paradise.",
            maxDepthFeet: 130,
            difficulty: .intermediate,
            highlights: ["WWII wrecks", "Fleet of ships", "Penetration", "Historical"],
            bestMonths: "Nov - May",
            waterTempRangeFahrenheit: "78-84°F",
            visibilityFeet: "30-60 ft",
            rating: 4.6,
            latitude: 11.9900, longitude: 120.2000
        ),
        DiveSite(
            name: "Komodo — Batu Bolong",
            location: "Komodo National Park",
            country: "Indonesia",
            region: .southeastAsia,
            description: "A tiny rock pinnacle surrounded by ripping currents. Every inch is covered in soft corals. Schools of fusiliers, trevally, and Napoleon wrasse swirl around the rock. Demanding but rewarding.",
            maxDepthFeet: 100,
            difficulty: .advanced,
            highlights: ["Strong current", "Soft coral covered", "Napoleon wrasse", "Trevally"],
            bestMonths: "Apr - Nov",
            waterTempRangeFahrenheit: "75-82°F",
            visibilityFeet: "30-80 ft",
            rating: 4.7,
            latitude: -8.5300, longitude: 119.4900
        ),

        // ═══════════════════════════════════════════
        // PACIFIC (14 sites)
        // ═══════════════════════════════════════════
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
            rating: 4.7,
            latitude: -16.5000, longitude: 145.7800
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
            rating: 4.6,
            latitude: -21.8100, longitude: 114.1600
        ),
        DiveSite(
            name: "SS President Coolidge",
            location: "Espiritu Santo",
            country: "Vanuatu",
            region: .pacific,
            description: "A 654-foot luxury liner turned WWII troop transport. The largest accessible wreck dive in the world. Shore entry leads to multiple decks with Jeeps, helmets, chandeliers, and 'The Lady' statue.",
            maxDepthFeet: 240,
            difficulty: .advanced,
            highlights: ["Massive wreck", "WWII artifacts", "The Lady statue", "Shore entry"],
            bestMonths: "Apr - Oct",
            waterTempRangeFahrenheit: "76-82°F",
            visibilityFeet: "40-100 ft",
            rating: 4.8,
            latitude: -15.5200, longitude: 167.1700
        ),
        DiveSite(
            name: "Yongala Wreck",
            location: "Townsville",
            country: "Australia",
            region: .pacific,
            description: "A 350-foot passenger ship that sank in 1911. Now an artificial reef teeming with bull sharks, sea snakes, giant trevally, and marble rays. Considered Australia's best wreck dive.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Bull sharks", "Sea snakes", "Marble rays", "Giant trevally"],
            bestMonths: "Jun - Jan",
            waterTempRangeFahrenheit: "72-82°F",
            visibilityFeet: "30-65 ft",
            rating: 4.8,
            latitude: -19.3100, longitude: 147.6200
        ),
        DiveSite(
            name: "Rainbow Reef",
            location: "Taveuni",
            country: "Fiji",
            region: .pacific,
            description: "Known as the 'Soft Coral Capital of the World.' The Great White Wall is covered entirely in white soft coral, creating an ethereal underwater landscape. Strong currents bring nutrients.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Soft coral capital", "White Wall", "Drift diving", "Vibrant colors"],
            bestMonths: "Apr - Oct",
            waterTempRangeFahrenheit: "76-82°F",
            visibilityFeet: "60-100 ft",
            rating: 4.7,
            latitude: -16.8200, longitude: -179.8800
        ),
        DiveSite(
            name: "Poor Knights Islands",
            location: "Tutukaka",
            country: "New Zealand",
            region: .pacific,
            description: "Jacques Cousteau rated this in his top 10. Volcanic arches, caves, and tunnels with subtropical and temperate species mixing. Blue maomao, nudibranchs, and massive kelp forests.",
            maxDepthFeet: 130,
            difficulty: .intermediate,
            highlights: ["Arches & caves", "Blue maomao", "Kelp forests", "Subtropical mix"],
            bestMonths: "Feb - Jun",
            waterTempRangeFahrenheit: "60-72°F",
            visibilityFeet: "50-100 ft",
            rating: 4.6,
            latitude: -35.4700, longitude: 174.7400
        ),
        DiveSite(
            name: "Jellyfish Lake",
            location: "Eil Malk Island",
            country: "Palau",
            region: .pacific,
            description: "A marine lake containing millions of golden jellyfish that have lost their sting. Snorkel among pulsing clouds of jellyfish in an otherworldly experience found nowhere else on Earth.",
            maxDepthFeet: 15,
            difficulty: .beginner,
            highlights: ["Millions of jellyfish", "Stingless", "Unique ecosystem", "Snorkeling"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "82-86°F",
            visibilityFeet: "20-40 ft",
            rating: 4.6,
            latitude: 7.1610, longitude: 134.3760
        ),
        DiveSite(
            name: "Rangiroa — Tiputa Pass",
            location: "Tuamotu Archipelago",
            country: "French Polynesia",
            region: .pacific,
            description: "One of the largest atolls in the world. The Tiputa pass funnels ocean water through a narrow channel bringing dolphins, grey reef sharks, hammerheads, and mantas.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Dolphins", "Hammerheads", "Drift pass", "Grey reef sharks"],
            bestMonths: "Jul - Oct",
            waterTempRangeFahrenheit: "77-82°F",
            visibilityFeet: "80-130 ft",
            rating: 4.8,
            latitude: -14.9700, longitude: -147.6300
        ),
        DiveSite(
            name: "Manta Night Dive",
            location: "Kailua-Kona, Big Island",
            country: "USA",
            region: .pacific,
            description: "Lights attract plankton, which attract giant oceanic manta rays that barrel roll inches from divers' faces. One of the most magical night dives on the planet.",
            maxDepthFeet: 35,
            difficulty: .beginner,
            highlights: ["Manta rays", "Night dive", "Plankton attraction", "Close encounters"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "75-80°F",
            visibilityFeet: "50-80 ft",
            rating: 4.9,
            latitude: 19.8100, longitude: -156.0600
        ),

        // ═══════════════════════════════════════════
        // RED SEA (12 sites)
        // ═══════════════════════════════════════════
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
            rating: 4.7,
            latitude: 27.7300, longitude: 34.2600
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
            rating: 4.8,
            latitude: 27.8100, longitude: 33.9200
        ),
        DiveSite(
            name: "The Brothers Islands",
            location: "Open Red Sea",
            country: "Egypt",
            region: .redSea,
            description: "Two remote islands in the open Red Sea. Massive walls covered in soft corals plunge into deep blue. Hammerheads, oceanic white-tips, and thresher sharks are regular visitors.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Hammerheads", "Oceanic white-tips", "Remote", "Pristine walls"],
            bestMonths: "May - Aug",
            waterTempRangeFahrenheit: "75-82°F",
            visibilityFeet: "65-130 ft",
            rating: 4.8,
            latitude: 26.3200, longitude: 34.8500
        ),
        DiveSite(
            name: "Elphinstone Reef",
            location: "Marsa Alam",
            country: "Egypt",
            region: .redSea,
            description: "A cigar-shaped reef in the open water famous for oceanic white-tip shark encounters. Walls draped in soft coral and gorgonians. Strong currents bring big pelagics.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Oceanic white-tips", "Soft coral walls", "Pelagics", "Strong currents"],
            bestMonths: "Apr - Nov",
            waterTempRangeFahrenheit: "72-82°F",
            visibilityFeet: "65-100 ft",
            rating: 4.7,
            latitude: 25.3000, longitude: 34.8600
        ),
        DiveSite(
            name: "Abu Dabbab",
            location: "Marsa Alam",
            country: "Egypt",
            region: .redSea,
            description: "A sandy bay where dugongs (sea cows) come to feed on seagrass. Also home to giant green turtles and guitar sharks. One of the few places in the world to dive with dugongs.",
            maxDepthFeet: 60,
            difficulty: .beginner,
            highlights: ["Dugongs", "Sea turtles", "Guitar sharks", "Seagrass bay"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "72-82°F",
            visibilityFeet: "40-65 ft",
            rating: 4.5,
            latitude: 25.3400, longitude: 34.8300
        ),
        DiveSite(
            name: "Daedalus Reef",
            location: "Open Red Sea",
            country: "Egypt",
            region: .redSea,
            description: "An isolated reef in the deep Red Sea accessible only by liveaboard. Huge walls, schooling hammerheads, and thresher sharks in crystal-clear pelagic waters.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Hammerheads", "Thresher sharks", "Liveaboard only", "Crystal water"],
            bestMonths: "May - Aug",
            waterTempRangeFahrenheit: "75-82°F",
            visibilityFeet: "80-130 ft",
            rating: 4.7,
            latitude: 24.9300, longitude: 35.8700
        ),
        DiveSite(
            name: "Jackson Reef",
            location: "Strait of Tiran",
            country: "Egypt",
            region: .redSea,
            description: "The northernmost reef in the Strait of Tiran. A vibrant coral garden on a submerged plateau with a shipwreck on top. Currents attract pelagics and dense fish life.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Coral plateau", "Shipwreck on reef", "Current diving", "Dense fish life"],
            bestMonths: "Mar - Nov",
            waterTempRangeFahrenheit: "70-82°F",
            visibilityFeet: "65-100 ft",
            rating: 4.5,
            latitude: 27.9600, longitude: 34.4600
        ),

        // ═══════════════════════════════════════════
        // AMERICAS (15 sites)
        // ═══════════════════════════════════════════
        DiveSite(
            name: "Cenote Dos Ojos",
            location: "Riviera Maya",
            country: "Mexico",
            region: .americas,
            description: "A stunning freshwater cenote with crystal-clear visibility. Two connected sinkholes ('Two Eyes') with dramatic light beams, stalactites, and halocline effects.",
            maxDepthFeet: 33,
            difficulty: .beginner,
            highlights: ["Crystal clear water", "Light beams", "Stalactites", "Halocline"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "77°F",
            visibilityFeet: "100+ ft",
            rating: 4.7,
            latitude: 20.3300, longitude: -87.3900
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
            rating: 4.5,
            latitude: 20.6317, longitude: -156.4958
        ),
        DiveSite(
            name: "Galapagos — Darwin's Arch",
            location: "Darwin Island",
            country: "Ecuador",
            region: .americas,
            description: "Arguably the best big animal dive on Earth. Massive schools of hammerhead sharks, whale sharks, dolphins, and marine iguanas. Remote and only accessible by liveaboard.",
            maxDepthFeet: 100,
            difficulty: .advanced,
            highlights: ["Hammerhead schools", "Whale sharks", "Marine iguanas", "Dolphins"],
            bestMonths: "Jun - Nov",
            waterTempRangeFahrenheit: "65-75°F",
            visibilityFeet: "30-65 ft",
            rating: 4.9,
            latitude: 1.6700, longitude: -92.0000
        ),
        DiveSite(
            name: "Blue Heron Bridge",
            location: "Riviera Beach, FL",
            country: "USA",
            region: .americas,
            description: "A world-class muck diving site under a bridge in Florida. Seahorses, frogfish, octopus, batfish, and dozens of rare critters in waist-deep water. Best at high tide slack.",
            maxDepthFeet: 18,
            difficulty: .beginner,
            highlights: ["Seahorses", "Frogfish", "Muck diving", "Shore entry"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "72-84°F",
            visibilityFeet: "15-40 ft",
            rating: 4.6,
            latitude: 26.7800, longitude: -80.0500
        ),
        DiveSite(
            name: "Cenote Angelita",
            location: "Tulum",
            country: "Mexico",
            region: .americas,
            description: "A deep cenote with a surreal hydrogen sulfide cloud at 100 feet that looks like an underwater river. Trees and branches poke through the 'river' creating an otherworldly scene.",
            maxDepthFeet: 200,
            difficulty: .advanced,
            highlights: ["Underwater river", "Hydrogen sulfide cloud", "Surreal scenery", "Deep dive"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "77°F",
            visibilityFeet: "100+ ft",
            rating: 4.7,
            latitude: 20.2600, longitude: -87.4100
        ),
        DiveSite(
            name: "Cocos Island",
            location: "Pacific Ocean",
            country: "Costa Rica",
            region: .americas,
            description: "A remote Pacific island 340 miles offshore. Schooling hammerheads, whale sharks, mantas, dolphins, and Galapagos sharks. Often called 'Shark Island.' Liveaboard only.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Hammerhead schools", "Whale sharks", "Remote island", "Liveaboard only"],
            bestMonths: "Jun - Nov",
            waterTempRangeFahrenheit: "75-82°F",
            visibilityFeet: "50-100 ft",
            rating: 4.9,
            latitude: 5.5300, longitude: -87.0600
        ),
        DiveSite(
            name: "Tiger Beach",
            location: "West End",
            country: "Bahamas",
            region: .americas,
            description: "A shallow sandy flat where tiger sharks gather in numbers. Sit on the sand in 20 feet of water as 12-foot tiger sharks cruise overhead. The world's premier tiger shark dive.",
            maxDepthFeet: 25,
            difficulty: .advanced,
            highlights: ["Tiger sharks", "Lemon sharks", "Shallow water", "Close encounters"],
            bestMonths: "Oct - Jan",
            waterTempRangeFahrenheit: "76-82°F",
            visibilityFeet: "50-100 ft",
            rating: 4.7,
            latitude: 26.6000, longitude: -79.0100
        ),
        DiveSite(
            name: "Socorro — San Benedicto",
            location: "Revillagigedo",
            country: "Mexico",
            region: .americas,
            description: "Known as the 'Mexican Galapagos.' Giant Pacific manta rays with 20-foot wingspans are so friendly they seek out diver contact. Humpback whales, dolphins, and hammerheads.",
            maxDepthFeet: 100,
            difficulty: .advanced,
            highlights: ["Giant mantas", "Humpback whales", "Dolphins", "Hammerheads"],
            bestMonths: "Nov - Jun",
            waterTempRangeFahrenheit: "70-80°F",
            visibilityFeet: "65-130 ft",
            rating: 4.8,
            latitude: 19.3000, longitude: -110.8000
        ),
        DiveSite(
            name: "Monterey Bay",
            location: "Monterey, CA",
            country: "USA",
            region: .americas,
            description: "California's premier cold-water dive destination. Kelp forests, harbor seals, sea otters, and nudibranchs. The marine sanctuary supports incredible biodiversity in temperate waters.",
            maxDepthFeet: 100,
            difficulty: .intermediate,
            highlights: ["Kelp forests", "Sea otters", "Harbor seals", "Nudibranchs"],
            bestMonths: "Aug - Nov",
            waterTempRangeFahrenheit: "50-60°F",
            visibilityFeet: "20-50 ft",
            rating: 4.4,
            latitude: 36.6200, longitude: -121.9000
        ),

        // ═══════════════════════════════════════════
        // MEDITERRANEAN (8 sites)
        // ═══════════════════════════════════════════
        DiveSite(
            name: "Blue Hole (Gozo)",
            location: "Dwejra",
            country: "Malta",
            region: .mediterranean,
            description: "A natural limestone arch and inland sea creating a stunning entry into deep blue Mediterranean waters. Swim through the arch to a dramatic drop-off with grouper, barracuda, and octopus.",
            maxDepthFeet: 130,
            difficulty: .intermediate,
            highlights: ["Natural arch", "Inland sea entry", "Grouper", "Dramatic drop-off"],
            bestMonths: "May - Nov",
            waterTempRangeFahrenheit: "62-79°F",
            visibilityFeet: "65-130 ft",
            rating: 4.6,
            latitude: 36.0500, longitude: 14.1900
        ),
        DiveSite(
            name: "Zenobia Wreck",
            location: "Larnaca",
            country: "Cyprus",
            region: .mediterranean,
            description: "A 580-foot Swedish ferry that sank on her maiden voyage in 1980. Lying on her side in 138 feet, she's one of the best wreck dives in the Mediterranean. Trucks still chained to the deck.",
            maxDepthFeet: 138,
            difficulty: .intermediate,
            highlights: ["Massive wreck", "Penetration", "Trucks on deck", "Ambient light"],
            bestMonths: "Apr - Nov",
            waterTempRangeFahrenheit: "64-82°F",
            visibilityFeet: "65-100 ft",
            rating: 4.7,
            latitude: 34.9000, longitude: 33.6600
        ),
        DiveSite(
            name: "Nereo Cave",
            location: "Capo Caccia, Sardinia",
            country: "Italy",
            region: .mediterranean,
            description: "The largest underwater cave in the Mediterranean. A series of chambers with red coral, lobsters, and dramatic light effects. Multiple entrances at different depths.",
            maxDepthFeet: 100,
            difficulty: .advanced,
            highlights: ["Largest Med cave", "Red coral", "Light effects", "Lobsters"],
            bestMonths: "May - Oct",
            waterTempRangeFahrenheit: "60-77°F",
            visibilityFeet: "50-100 ft",
            rating: 4.5,
            latitude: 40.5600, longitude: 8.1600
        ),
        DiveSite(
            name: "El Bajón",
            location: "Lanzarote",
            country: "Spain",
            region: .mediterranean,
            description: "Two underwater mountains rising from the sandy bottom. The site is famous for angel sharks resting on the sand, huge schools of barracuda, and passing eagle rays.",
            maxDepthFeet: 90,
            difficulty: .intermediate,
            highlights: ["Angel sharks", "Barracuda schools", "Eagle rays", "Underwater mountains"],
            bestMonths: "Year-round",
            waterTempRangeFahrenheit: "64-75°F",
            visibilityFeet: "50-100 ft",
            rating: 4.4,
            latitude: 28.8600, longitude: -13.8100
        ),

        // ═══════════════════════════════════════════
        // INDIAN OCEAN (8 sites)
        // ═══════════════════════════════════════════
        DiveSite(
            name: "Aliwal Shoal",
            location: "Umkomaas",
            country: "South Africa",
            region: .indianOcean,
            description: "A fossilized sand dune reef with ragged-tooth sharks, hammerheads, and the annual sardine run. Tiger sharks and oceanic blacktips visit seasonally. Exhilarating shark diving.",
            maxDepthFeet: 80,
            difficulty: .intermediate,
            highlights: ["Ragged-tooth sharks", "Sardine run", "Tiger sharks", "Fossil reef"],
            bestMonths: "Jun - Nov",
            waterTempRangeFahrenheit: "65-77°F",
            visibilityFeet: "30-65 ft",
            rating: 4.6,
            latitude: -30.2700, longitude: 30.8400
        ),
        DiveSite(
            name: "Mnemba Atoll",
            location: "Zanzibar",
            country: "Tanzania",
            region: .indianOcean,
            description: "A small atoll off Zanzibar's northeast coast. Crystal-clear waters with healthy hard corals, green turtles, dolphins, and seasonal humpback whales. The best diving in East Africa.",
            maxDepthFeet: 80,
            difficulty: .beginner,
            highlights: ["Sea turtles", "Dolphins", "Pristine coral", "Humpback whales"],
            bestMonths: "Oct - Mar",
            waterTempRangeFahrenheit: "77-84°F",
            visibilityFeet: "50-100 ft",
            rating: 4.5,
            latitude: -5.8200, longitude: 39.3800
        ),
        DiveSite(
            name: "Maldives — Hanifaru Bay",
            location: "Baa Atoll",
            country: "Maldives",
            region: .indianOcean,
            description: "A UNESCO Biosphere Reserve where up to 200 manta rays congregate to feed on plankton. During peak season, mantas chain-feed in a mesmerizing underwater ballet.",
            maxDepthFeet: 40,
            difficulty: .beginner,
            highlights: ["Manta feeding", "200+ mantas", "UNESCO site", "Plankton blooms"],
            bestMonths: "Jun - Nov",
            waterTempRangeFahrenheit: "80-84°F",
            visibilityFeet: "30-65 ft",
            rating: 4.8,
            latitude: 5.1300, longitude: 72.9400
        ),
        DiveSite(
            name: "Tofo Beach",
            location: "Inhambane",
            country: "Mozambique",
            region: .indianOcean,
            description: "One of the best places in the world to see whale sharks and manta rays year-round. Sandy bottom dives with gentle giants gliding overhead in warm tropical waters.",
            maxDepthFeet: 80,
            difficulty: .beginner,
            highlights: ["Whale sharks", "Manta rays", "Year-round big animals", "Warm water"],
            bestMonths: "Oct - Mar",
            waterTempRangeFahrenheit: "77-82°F",
            visibilityFeet: "30-65 ft",
            rating: 4.6,
            latitude: -23.8500, longitude: 35.5400
        ),
        DiveSite(
            name: "Protea Banks",
            location: "Shelly Beach",
            country: "South Africa",
            region: .indianOcean,
            description: "South Africa's wildest shark dive. A deep reef where bull sharks, tiger sharks, hammerheads, and Zambezi sharks patrol. Not for the faint of heart — challenging conditions and big predators.",
            maxDepthFeet: 130,
            difficulty: .advanced,
            highlights: ["Bull sharks", "Tiger sharks", "Hammerheads", "Adrenaline diving"],
            bestMonths: "Nov - Jun",
            waterTempRangeFahrenheit: "68-77°F",
            visibilityFeet: "15-50 ft",
            rating: 4.5,
            latitude: -30.8000, longitude: 30.4300
        ),
        DiveSite(
            name: "Aldabra Atoll",
            location: "Outer Islands",
            country: "Seychelles",
            region: .indianOcean,
            description: "A UNESCO World Heritage Site and one of the most remote atolls in the Indian Ocean. Pristine coral, manta rays, whale sharks, and giant tortoises on land. Expedition-level diving.",
            maxDepthFeet: 100,
            difficulty: .advanced,
            highlights: ["UNESCO site", "Pristine reef", "Mantas", "Giant tortoises"],
            bestMonths: "Mar - May, Oct - Nov",
            waterTempRangeFahrenheit: "77-82°F",
            visibilityFeet: "50-100 ft",
            rating: 4.7,
            latitude: -9.4200, longitude: 46.3500
        ),
    ]

    static func sites(for region: DiveRegion) -> [DiveSite] {
        allSites.filter { $0.region == region }
    }
}
