import Foundation

/// A dive achievement / badge that can be unlocked
struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: Category
    let check: ([Dive]) -> Bool

    enum Category: String, CaseIterable {
        case milestones = "Milestones"
        case depth = "Depth"
        case exploration = "Exploration"
        case dedication = "Dedication"
        case wildlife = "Wildlife"
        case social = "Social"

        var icon: String {
            switch self {
            case .milestones: return "flag.fill"
            case .depth: return "arrow.down.to.line"
            case .exploration: return "globe"
            case .dedication: return "flame.fill"
            case .wildlife: return "fish.fill"
            case .social: return "person.2.fill"
            }
        }
    }

    func isUnlocked(dives: [Dive]) -> Bool {
        check(dives)
    }

    // MARK: - All Achievements

    static let all: [Achievement] = [
        // Milestones
        Achievement(id: "first-dive", name: "First Splash", description: "Log your first dive", icon: "drop.fill", category: .milestones) { $0.count >= 1 },
        Achievement(id: "10-dives", name: "Getting Hooked", description: "Log 10 dives", icon: "10.circle.fill", category: .milestones) { $0.count >= 10 },
        Achievement(id: "25-dives", name: "Quarter Century", description: "Log 25 dives", icon: "25.circle.fill", category: .milestones) { $0.count >= 25 },
        Achievement(id: "50-dives", name: "Half Centurion", description: "Log 50 dives", icon: "50.circle.fill", category: .milestones) { $0.count >= 50 },
        Achievement(id: "100-dives", name: "Century Diver", description: "Log 100 dives", icon: "star.circle.fill", category: .milestones) { $0.count >= 100 },
        Achievement(id: "250-dives", name: "Dive Master", description: "Log 250 dives", icon: "crown.fill", category: .milestones) { $0.count >= 250 },
        Achievement(id: "500-dives", name: "Legend of the Deep", description: "Log 500 dives", icon: "trophy.fill", category: .milestones) { $0.count >= 500 },

        // Depth
        Achievement(id: "deep-30", name: "30 Footer", description: "Dive to 30 feet / 10 meters", icon: "arrow.down", category: .depth) { dives in
            dives.contains { $0.maxDepth >= 30 }
        },
        Achievement(id: "deep-60", name: "Deep Diver", description: "Dive to 60 feet / 18 meters", icon: "arrow.down.circle", category: .depth) { dives in
            dives.contains { $0.maxDepth >= 60 }
        },
        Achievement(id: "deep-100", name: "Triple Digits", description: "Dive to 100 feet / 30 meters", icon: "arrow.down.circle.fill", category: .depth) { dives in
            dives.contains { $0.maxDepth >= 100 }
        },
        Achievement(id: "deep-130", name: "Recreational Limit", description: "Dive to 130 feet / 40 meters", icon: "exclamationmark.triangle.fill", category: .depth) { dives in
            dives.contains { $0.maxDepth >= 130 }
        },

        // Exploration
        Achievement(id: "3-locations", name: "Explorer", description: "Dive in 3 different locations", icon: "map.fill", category: .exploration) { dives in
            Set(dives.map(\.location)).count >= 3
        },
        Achievement(id: "5-locations", name: "Globetrotter", description: "Dive in 5 different locations", icon: "globe.americas.fill", category: .exploration) { dives in
            Set(dives.map(\.location)).count >= 5
        },
        Achievement(id: "10-locations", name: "World Diver", description: "Dive in 10 different locations", icon: "globe.europe.africa.fill", category: .exploration) { dives in
            Set(dives.map(\.location)).count >= 10
        },
        Achievement(id: "10-sites", name: "Site Collector", description: "Dive at 10 different sites", icon: "mappin.circle.fill", category: .exploration) { dives in
            Set(dives.map(\.diveSite)).count >= 10
        },
        Achievement(id: "repeat-site", name: "Local Regular", description: "Dive the same site 5+ times", icon: "repeat.circle.fill", category: .exploration) { dives in
            let counts = Dictionary(grouping: dives, by: \.diveSite).mapValues(\.count)
            return counts.values.contains { $0 >= 5 }
        },

        // Dedication
        Achievement(id: "hour-underwater", name: "Hour Under", description: "Accumulate 60 minutes of bottom time", icon: "clock.fill", category: .dedication) { dives in
            dives.reduce(0) { $0 + $1.bottomTime } >= 60
        },
        Achievement(id: "10-hours", name: "Ten Hours Deep", description: "Accumulate 600 minutes of bottom time", icon: "timer.circle.fill", category: .dedication) { dives in
            dives.reduce(0) { $0 + $1.bottomTime } >= 600
        },
        Achievement(id: "24-hours", name: "Full Day Below", description: "Accumulate 1440 minutes (24 hours) underwater", icon: "hourglass.circle.fill", category: .dedication) { dives in
            dives.reduce(0) { $0 + $1.bottomTime } >= 1440
        },
        Achievement(id: "5-star", name: "Perfect Dive", description: "Log a 5-star rated dive", icon: "star.fill", category: .dedication) { dives in
            dives.contains { $0.rating == 5 }
        },
        Achievement(id: "week-streak", name: "Week Warrior", description: "Dive on 7 different days in a month", icon: "calendar.badge.clock", category: .dedication) { dives in
            let cal = Calendar.current
            let byMonth = Dictionary(grouping: dives) { cal.dateComponents([.year, .month], from: $0.date) }
            return byMonth.values.contains { monthDives in
                Set(monthDives.map { cal.component(.day, from: $0.date) }).count >= 7
            }
        },

        // Wildlife
        Achievement(id: "first-sighting", name: "Sharp Eyes", description: "Log your first species sighting", icon: "eye.fill", category: .wildlife) { dives in
            dives.contains { ($0.speciesSightings?.count ?? 0) > 0 }
        },
        Achievement(id: "10-species", name: "Naturalist", description: "Spot 10 different species across all dives", icon: "leaf.fill", category: .wildlife) { dives in
            let allIDs = dives.flatMap { $0.speciesSightings ?? [] }.map(\.speciesID)
            return Set(allIDs).count >= 10
        },
        Achievement(id: "25-species", name: "Marine Biologist", description: "Spot 25 different species across all dives", icon: "graduationcap.fill", category: .wildlife) { dives in
            let allIDs = dives.flatMap { $0.speciesSightings ?? [] }.map(\.speciesID)
            return Set(allIDs).count >= 25
        },
        Achievement(id: "school-sighting", name: "School's In", description: "Log a school-sized sighting", icon: "fish.fill", category: .wildlife) { dives in
            dives.flatMap { $0.speciesSightings ?? [] }.contains { $0.count == .school }
        },

        // Social
        Achievement(id: "first-buddy", name: "Buddy System", description: "Log a dive with a buddy", icon: "person.2.fill", category: .social) { dives in
            dives.contains { !$0.buddyName.isEmpty }
        },
        Achievement(id: "3-buddies", name: "Social Diver", description: "Dive with 3 different buddies", icon: "person.3.fill", category: .social) { dives in
            Set(dives.filter { !$0.buddyName.isEmpty }.map(\.buddyName)).count >= 3
        },
        Achievement(id: "loyal-buddy", name: "Dive Partners", description: "Dive with the same buddy 10+ times", icon: "heart.fill", category: .social) { dives in
            let counts = Dictionary(grouping: dives.filter { !$0.buddyName.isEmpty }, by: \.buddyName).mapValues(\.count)
            return counts.values.contains { $0 >= 10 }
        },
        Achievement(id: "first-photo", name: "Shutterbug", description: "Add a photo to a dive", icon: "camera.fill", category: .social) { dives in
            dives.contains { ($0.photoFilenames?.count ?? 0) > 0 }
        },
    ]

    static var byCategory: [(category: Category, achievements: [Achievement])] {
        Category.allCases.map { cat in
            (cat, all.filter { $0.category == cat })
        }
    }
}
