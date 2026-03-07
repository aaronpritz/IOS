import Foundation

/// Weather data for a dive location
struct DiveWeather: Codable {
    let locationName: String
    let fetchedAt: Date
    let current: CurrentWeather
    let marine: MarineConditions?

    struct CurrentWeather: Codable {
        let temperature: Double      // °C
        let apparentTemperature: Double // °C
        let humidity: Int            // %
        let windSpeed: Double        // km/h
        let windDirection: Int       // degrees
        let weatherCode: Int
        let isDay: Bool
        let uvIndex: Double
        let cloudCover: Int          // %
        let pressure: Double         // hPa
    }

    struct MarineConditions: Codable {
        let waveHeight: Double       // meters
        let wavePeriod: Double       // seconds
        let waveDirection: Int       // degrees
        let waterTemperature: Double // °C
    }

    // Weather code to description
    var weatherDescription: String {
        switch current.weatherCode {
        case 0: return "Clear Sky"
        case 1: return "Mainly Clear"
        case 2: return "Partly Cloudy"
        case 3: return "Overcast"
        case 45, 48: return "Foggy"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 66, 67: return "Freezing Rain"
        case 71, 73, 75: return "Snow"
        case 77: return "Snow Grains"
        case 80, 81, 82: return "Rain Showers"
        case 85, 86: return "Snow Showers"
        case 95: return "Thunderstorm"
        case 96, 99: return "Thunderstorm with Hail"
        default: return "Unknown"
        }
    }

    var weatherIcon: String {
        switch current.weatherCode {
        case 0: return current.isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1: return current.isDay ? "sun.min.fill" : "moon.fill"
        case 2: return current.isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 3: return "cloud.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 61, 63, 65: return "cloud.rain.fill"
        case 66, 67: return "cloud.sleet.fill"
        case 71, 73, 75, 77: return "cloud.snow.fill"
        case 80, 81, 82: return "cloud.heavyrain.fill"
        case 85, 86: return "cloud.snow.fill"
        case 95, 96, 99: return "cloud.bolt.rain.fill"
        default: return "questionmark.circle"
        }
    }

    /// Dive condition rating based on weather
    var diveConditionRating: DiveCondition {
        var score = 100

        // Wind penalty
        if current.windSpeed > 40 { score -= 40 }
        else if current.windSpeed > 25 { score -= 20 }
        else if current.windSpeed > 15 { score -= 10 }

        // Rain penalty
        if [61, 63, 65, 80, 81, 82].contains(current.weatherCode) { score -= 20 }
        if [95, 96, 99].contains(current.weatherCode) { score -= 50 }

        // Wave penalty
        if let marine = marine {
            if marine.waveHeight > 2.5 { score -= 30 }
            else if marine.waveHeight > 1.5 { score -= 15 }
            else if marine.waveHeight > 1.0 { score -= 5 }
        }

        if score >= 80 { return .excellent }
        if score >= 60 { return .good }
        if score >= 40 { return .fair }
        return .poor
    }

    enum DiveCondition: String {
        case excellent = "Excellent"
        case good = "Good"
        case fair = "Fair"
        case poor = "Poor"

        var color: String {
            switch self {
            case .excellent: return "green"
            case .good: return "cyan"
            case .fair: return "orange"
            case .poor: return "red"
            }
        }

        var icon: String {
            switch self {
            case .excellent: return "checkmark.seal.fill"
            case .good: return "hand.thumbsup.fill"
            case .fair: return "exclamationmark.triangle.fill"
            case .poor: return "xmark.octagon.fill"
            }
        }
    }

    /// Wind direction as compass bearing
    var windDirectionCompass: String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((Double(current.windDirection) + 11.25) / 22.5) % 16
        return directions[index]
    }
}
