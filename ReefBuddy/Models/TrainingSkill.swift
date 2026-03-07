import Foundation

/// A dive skill that can be practiced and tracked
struct TrainingSkill: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: SkillCategory
    var practiceLog: [SkillPractice]
    var targetPractices: Int      // how many times to practice before "mastered"
    var notes: String

    enum SkillCategory: String, Codable, CaseIterable {
        case buoyancy = "Buoyancy"
        case navigation = "Navigation"
        case rescue = "Rescue"
        case equipment = "Equipment"
        case photography = "Photography"
        case specialty = "Specialty"

        var icon: String {
            switch self {
            case .buoyancy: return "arrow.up.and.down"
            case .navigation: return "compass.drawing"
            case .rescue: return "cross.circle"
            case .equipment: return "wrench.and.screwdriver"
            case .photography: return "camera"
            case .specialty: return "star.circle"
            }
        }
    }

    var practiceCount: Int { practiceLog.count }

    var progress: Double {
        guard targetPractices > 0 else { return 0 }
        return min(Double(practiceCount) / Double(targetPractices), 1.0)
    }

    var isMastered: Bool { practiceCount >= targetPractices }

    var lastPracticed: Date? { practiceLog.last?.date }

    var lastPracticedDisplay: String {
        guard let date = lastPracticed else { return "Never" }
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }

    static var defaultSkills: [TrainingSkill] {
        [
            // Buoyancy
            TrainingSkill(name: "Hover in Place", category: .buoyancy, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Fin Pivot", category: .buoyancy, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Controlled Descent", category: .buoyancy, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Neutral Buoyancy Swimming", category: .buoyancy, practiceLog: [], targetPractices: 10, notes: ""),
            TrainingSkill(name: "Frog Kick", category: .buoyancy, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Back Kick", category: .buoyancy, practiceLog: [], targetPractices: 5, notes: ""),

            // Navigation
            TrainingSkill(name: "Compass Navigation", category: .navigation, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Natural Navigation", category: .navigation, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Square Pattern", category: .navigation, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Out-and-Back", category: .navigation, practiceLog: [], targetPractices: 3, notes: ""),

            // Rescue
            TrainingSkill(name: "Tired Diver Tow", category: .rescue, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Unresponsive Diver Surface", category: .rescue, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Alternate Air Source Use", category: .rescue, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "CESA (Emergency Ascent)", category: .rescue, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Weight Ditch & Recovery", category: .rescue, practiceLog: [], targetPractices: 3, notes: ""),

            // Equipment
            TrainingSkill(name: "Mask Clear", category: .equipment, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Mask Removal & Replace", category: .equipment, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Regulator Recovery", category: .equipment, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "BCD Remove & Replace (Surface)", category: .equipment, practiceLog: [], targetPractices: 2, notes: ""),
            TrainingSkill(name: "Weight Belt Remove & Replace", category: .equipment, practiceLog: [], targetPractices: 2, notes: ""),
            TrainingSkill(name: "SMB Deployment", category: .equipment, practiceLog: [], targetPractices: 5, notes: ""),

            // Photography
            TrainingSkill(name: "Macro Photography", category: .photography, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Wide Angle Composition", category: .photography, practiceLog: [], targetPractices: 5, notes: ""),
            TrainingSkill(name: "Manual White Balance", category: .photography, practiceLog: [], targetPractices: 3, notes: ""),

            // Specialty
            TrainingSkill(name: "Night Dive Procedures", category: .specialty, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Drift Dive Technique", category: .specialty, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Deep Dive Planning", category: .specialty, practiceLog: [], targetPractices: 3, notes: ""),
            TrainingSkill(name: "Wreck Penetration Basics", category: .specialty, practiceLog: [], targetPractices: 2, notes: ""),
        ]
    }
}

/// A single practice session for a skill
struct SkillPractice: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var confidence: ConfidenceLevel
    var note: String

    enum ConfidenceLevel: String, Codable, CaseIterable {
        case learning = "Learning"
        case improving = "Improving"
        case comfortable = "Comfortable"
        case confident = "Confident"

        var icon: String {
            switch self {
            case .learning: return "1.circle.fill"
            case .improving: return "2.circle.fill"
            case .comfortable: return "3.circle.fill"
            case .confident: return "4.circle.fill"
            }
        }

        var color: String {
            switch self {
            case .learning: return "red"
            case .improving: return "orange"
            case .comfortable: return "yellow"
            case .confident: return "green"
            }
        }
    }
}
