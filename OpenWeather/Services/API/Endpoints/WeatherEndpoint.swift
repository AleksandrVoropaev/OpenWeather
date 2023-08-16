//
//  WeatherEndpoint.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation

enum WeatherEndpoint {
    case getCurrentWeather(latitude: Double, longitude: Double, system: Locale.MeasurementSystem)
    case getGeoItems(query: String)
}

extension WeatherEndpoint: Endpoint {
    var host: String {
        "api.openweathermap.org"
    }

    var path: String {
        switch self {
        case .getCurrentWeather:
            return "/data/2.5/weather"
        case .getGeoItems:
            return "/geo/1.0/direct"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var header: [String : String]? {
        [
            "Content-Type": "application/json;charset=utf-8"
        ]
    }

    var body: [String : String]? {
        nil
    }

    var query: [String : String?]? {
        switch self {
        case .getCurrentWeather(let latitude, let longitude, let system):
            return [
                "lat": String(latitude),
                "lon": String(longitude),
                "units": units(for: system),
                "lang": "en",
                "appid": apiKey
            ]
        case .getGeoItems(let query):
            return [
                "q": query,
                "limit": "20",
                "appid": apiKey
            ]
        }
    }
}

private enum Constants {
    static let apiKey: String = apiKey // Insert your API key here
}

extension WeatherEndpoint {
    func units(for system: Locale.MeasurementSystem) -> String {
        switch system {
        case .metric: return "metric"
        default: return "imperial"
        }
    }
}
