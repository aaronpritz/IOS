import Foundation

/// Fetches weather and marine data from the free Open-Meteo API
class WeatherService {
    static let shared = WeatherService()

    private let weatherBaseURL = "https://api.open-meteo.com/v1/forecast"
    private let marineBaseURL = "https://marine-api.open-meteo.com/v1/marine"

    /// Fetch current weather and marine conditions for a location
    func fetchWeather(latitude: Double, longitude: Double, locationName: String) async throws -> DiveWeather {
        async let weatherData = fetchCurrentWeather(latitude: latitude, longitude: longitude)
        async let marineData = fetchMarineConditions(latitude: latitude, longitude: longitude)

        let weather = try await weatherData
        let marine = try? await marineData // Marine data is optional (not available for all locations)

        return DiveWeather(
            locationName: locationName,
            fetchedAt: Date(),
            current: weather,
            marine: marine
        )
    }

    private func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> DiveWeather.CurrentWeather {
        var components = URLComponents(string: weatherBaseURL)!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m,is_day,uv_index,cloud_cover,surface_pressure"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.serverError
        }

        let decoded = try JSONDecoder().decode(OpenMeteoWeatherResponse.self, from: data)
        let current = decoded.current

        return DiveWeather.CurrentWeather(
            temperature: current.temperature_2m,
            apparentTemperature: current.apparent_temperature,
            humidity: Int(current.relative_humidity_2m),
            windSpeed: current.wind_speed_10m,
            windDirection: Int(current.wind_direction_10m),
            weatherCode: Int(current.weather_code),
            isDay: current.is_day == 1,
            uvIndex: current.uv_index,
            cloudCover: Int(current.cloud_cover),
            pressure: current.surface_pressure
        )
    }

    private func fetchMarineConditions(latitude: Double, longitude: Double) async throws -> DiveWeather.MarineConditions {
        var components = URLComponents(string: marineBaseURL)!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "wave_height,wave_period,wave_direction,ocean_temperature")
        ]

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherError.serverError
        }

        let decoded = try JSONDecoder().decode(OpenMeteoMarineResponse.self, from: data)
        let current = decoded.current

        return DiveWeather.MarineConditions(
            waveHeight: current.wave_height,
            wavePeriod: current.wave_period,
            waveDirection: Int(current.wave_direction),
            waterTemperature: current.ocean_temperature
        )
    }

    enum WeatherError: LocalizedError {
        case invalidURL
        case serverError
        case decodingError

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL"
            case .serverError: return "Weather service unavailable"
            case .decodingError: return "Failed to read weather data"
            }
        }
    }
}

// MARK: - Open-Meteo API Response Models

private struct OpenMeteoWeatherResponse: Codable {
    let current: CurrentData

    struct CurrentData: Codable {
        let temperature_2m: Double
        let relative_humidity_2m: Double
        let apparent_temperature: Double
        let weather_code: Double
        let wind_speed_10m: Double
        let wind_direction_10m: Double
        let is_day: Double
        let uv_index: Double
        let cloud_cover: Double
        let surface_pressure: Double
    }
}

private struct OpenMeteoMarineResponse: Codable {
    let current: CurrentData

    struct CurrentData: Codable {
        let wave_height: Double
        let wave_period: Double
        let wave_direction: Double
        let ocean_temperature: Double
    }
}
