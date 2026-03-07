import Foundation

/// A piece of dive equipment in the gear tracker
struct GearItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: Category
    var brand: String
    var model: String
    var serialNumber: String
    var purchaseDate: Date?
    var lastServiceDate: Date?
    var serviceIntervalMonths: Int?   // nil = no service reminders
    var totalDives: Int
    var notes: String
    var isRetired: Bool

    enum Category: String, Codable, CaseIterable {
        case regulator = "Regulator"
        case bcd = "BCD"
        case wetsuit = "Wetsuit"
        case drysuit = "Drysuit"
        case mask = "Mask"
        case fins = "Fins"
        case computer = "Dive Computer"
        case tank = "Tank"
        case light = "Light / Torch"
        case camera = "Camera / Housing"
        case weights = "Weights"
        case accessories = "Accessories"

        var icon: String {
            switch self {
            case .regulator: return "lungs.fill"
            case .bcd: return "figure.water.fitness"
            case .wetsuit: return "figure.dress.line.vertical.figure"
            case .drysuit: return "figure.dress.line.vertical.figure"
            case .mask: return "eyeglasses"
            case .fins: return "shoe.fill"
            case .computer: return "applewatch"
            case .tank: return "cylinder.fill"
            case .light: return "flashlight.on.fill"
            case .camera: return "camera.fill"
            case .weights: return "scalemass.fill"
            case .accessories: return "bag.fill"
            }
        }
    }

    /// Next service due date based on last service + interval
    var nextServiceDate: Date? {
        guard let last = lastServiceDate, let months = serviceIntervalMonths else { return nil }
        return Calendar.current.date(byAdding: .month, value: months, to: last)
    }

    /// Whether service is overdue
    var isServiceOverdue: Bool {
        guard let next = nextServiceDate else { return false }
        return next < Date()
    }

    /// Whether service is due within 30 days
    var isServiceDueSoon: Bool {
        guard let next = nextServiceDate else { return false }
        let thirtyDays = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        return next < thirtyDays && !isServiceOverdue
    }

    var serviceStatusText: String {
        guard let next = nextServiceDate else { return "No service schedule" }
        if isServiceOverdue {
            return "Service overdue!"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Next service: \(formatter.string(from: next))"
    }

    var serviceStatusColor: String {
        if isServiceOverdue { return "red" }
        if isServiceDueSoon { return "orange" }
        return "green"
    }

    var formattedPurchaseDate: String? {
        guard let date = purchaseDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    static var example: GearItem {
        GearItem(
            name: "Primary Regulator",
            category: .regulator,
            brand: "Scubapro",
            model: "MK25 EVO / S620 Ti",
            serialNumber: "SP-2024-1234",
            purchaseDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()),
            lastServiceDate: Calendar.current.date(byAdding: .month, value: -10, to: Date()),
            serviceIntervalMonths: 12,
            totalDives: 87,
            notes: "Annual service includes HP seat replacement.",
            isRetired: false
        )
    }
}
