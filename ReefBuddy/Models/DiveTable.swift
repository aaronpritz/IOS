import Foundation

/// Recreational dive table data (based on standard no-decompression limits)
/// These are simplified recreational limits — always use your dive computer for actual diving
struct DiveTableEntry: Identifiable {
    let id = UUID()
    let depthFeet: Int
    let depthMeters: Int
    let noDecoLimit: Int      // minutes
    let pressureGroup: String // letter after max time
}

struct DiveTableData {
    /// Standard recreational no-decompression limits
    /// Based on commonly used recreational dive tables
    static let entries: [DiveTableEntry] = [
        DiveTableEntry(depthFeet: 35,  depthMeters: 10, noDecoLimit: 205, pressureGroup: "L"),
        DiveTableEntry(depthFeet: 40,  depthMeters: 12, noDecoLimit: 140, pressureGroup: "L"),
        DiveTableEntry(depthFeet: 50,  depthMeters: 15, noDecoLimit: 80,  pressureGroup: "K"),
        DiveTableEntry(depthFeet: 60,  depthMeters: 18, noDecoLimit: 55,  pressureGroup: "K"),
        DiveTableEntry(depthFeet: 70,  depthMeters: 21, noDecoLimit: 40,  pressureGroup: "J"),
        DiveTableEntry(depthFeet: 80,  depthMeters: 24, noDecoLimit: 30,  pressureGroup: "I"),
        DiveTableEntry(depthFeet: 90,  depthMeters: 27, noDecoLimit: 25,  pressureGroup: "I"),
        DiveTableEntry(depthFeet: 100, depthMeters: 30, noDecoLimit: 20,  pressureGroup: "H"),
        DiveTableEntry(depthFeet: 110, depthMeters: 33, noDecoLimit: 16,  pressureGroup: "G"),
        DiveTableEntry(depthFeet: 120, depthMeters: 36, noDecoLimit: 13,  pressureGroup: "F"),
        DiveTableEntry(depthFeet: 130, depthMeters: 40, noDecoLimit: 10,  pressureGroup: "E"),
    ]

    /// Surface interval time to drop one pressure group (approximate minutes)
    static let surfaceIntervalPerGroup = 30 // rough average

    /// Get no-deco limit for a given depth in feet
    static func noDecoLimit(forDepthFeet depth: Int) -> Int? {
        // Find the entry at or deeper than the planned depth
        let entry = entries.first(where: { $0.depthFeet >= depth })
        return entry?.noDecoLimit
    }

    /// Get no-deco limit for a given depth in meters
    static func noDecoLimit(forDepthMeters depth: Int) -> Int? {
        let entry = entries.first(where: { $0.depthMeters >= depth })
        return entry?.noDecoLimit
    }
}
