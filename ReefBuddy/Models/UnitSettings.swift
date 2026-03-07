import SwiftUI

enum UnitSystem: String, Codable, CaseIterable {
    case imperial = "Imperial"
    case metric = "Metric"
}

/// Manages unit preferences and conversions between Imperial and Metric
class UnitSettings: ObservableObject {
    @AppStorage("unitSystem") var unitSystem: UnitSystem = .imperial

    // MARK: - Depth (stored in feet, displayed in feet or meters)

    func depthDisplay(_ feet: Double) -> String {
        switch unitSystem {
        case .imperial:
            return "\(Int(feet)) ft"
        case .metric:
            return "\(Int(feetToMeters(feet))) m"
        }
    }

    var depthUnit: String {
        unitSystem == .imperial ? "ft" : "m"
    }

    var depthRange: ClosedRange<Double> {
        unitSystem == .imperial ? 3...130 : 1...40
    }

    /// Convert display value to stored feet
    func toStoredDepth(_ displayValue: Double) -> Double {
        unitSystem == .imperial ? displayValue : metersToFeet(displayValue)
    }

    /// Convert stored feet to display value
    func toDisplayDepth(_ storedFeet: Double) -> Double {
        unitSystem == .imperial ? storedFeet : feetToMeters(storedFeet)
    }

    // MARK: - Temperature (stored in °F, displayed in °F or °C)

    func tempDisplay(_ fahrenheit: Double) -> String {
        switch unitSystem {
        case .imperial:
            return "\(Int(fahrenheit))°F"
        case .metric:
            return "\(Int(fahrenheitToCelsius(fahrenheit)))°C"
        }
    }

    var tempUnit: String {
        unitSystem == .imperial ? "°F" : "°C"
    }

    var tempRange: ClosedRange<Double> {
        unitSystem == .imperial ? 32...95 : 0...35
    }

    /// Convert display value to stored °F
    func toStoredTemp(_ displayValue: Double) -> Double {
        unitSystem == .imperial ? displayValue : celsiusToFahrenheit(displayValue)
    }

    /// Convert stored °F to display value
    func toDisplayTemp(_ storedF: Double) -> Double {
        unitSystem == .imperial ? storedF : fahrenheitToCelsius(storedF)
    }

    // MARK: - Visibility (stored in feet, displayed in feet or meters)

    func visibilityDisplay(_ feet: Int) -> String {
        switch unitSystem {
        case .imperial:
            return "\(feet) ft"
        case .metric:
            return "\(Int(feetToMeters(Double(feet)))) m"
        }
    }

    var visibilityUnit: String {
        unitSystem == .imperial ? "ft" : "m"
    }

    var visibilityRange: ClosedRange<Int> {
        unitSystem == .imperial ? 3...165 : 1...50
    }

    /// Convert display value to stored feet
    func toStoredVisibility(_ displayValue: Int) -> Int {
        unitSystem == .imperial ? displayValue : Int(metersToFeet(Double(displayValue)))
    }

    /// Convert stored feet to display value
    func toDisplayVisibility(_ storedFeet: Int) -> Int {
        unitSystem == .imperial ? storedFeet : Int(feetToMeters(Double(storedFeet)))
    }

    // MARK: - Conversion Helpers

    private func feetToMeters(_ feet: Double) -> Double {
        feet * 0.3048
    }

    private func metersToFeet(_ meters: Double) -> Double {
        meters / 0.3048
    }

    private func fahrenheitToCelsius(_ f: Double) -> Double {
        (f - 32) * 5.0 / 9.0
    }

    private func celsiusToFahrenheit(_ c: Double) -> Double {
        c * 9.0 / 5.0 + 32
    }
}
