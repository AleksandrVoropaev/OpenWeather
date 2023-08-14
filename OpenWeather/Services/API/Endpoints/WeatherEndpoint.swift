//
//  WeatherEndpoint.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation

enum WeatherEndpoint {
    case getCurrentWeather
}

extension WeatherEndpoint: Endpoint {
    var host: String {
        "api.openweathermap.org"
    }

    var path: String {
        switch self {
        case .getCurrentWeather:
            return "/data/2.5/weather"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var header: [String : String]? {
        [
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Bearer \(Constants.apiKey)"
        ]
    }

    var body: [String : String]? {
        nil
    }

    var query: [String : String?]? {
        switch self {
        case .getCurrentWeather:
            return [
                "lat": "latitude",
                "lon": "longitude"
            ]
        }
    }
}

private enum Constants {
    static let apiKey: String = apiKey // Insert your API key here
}
