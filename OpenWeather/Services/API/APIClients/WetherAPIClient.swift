//
//  WetherAPIClient.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation

protocol WeatherAPIClient {
    func fetchCurrentWeather() async -> Result<WeatherResponse, GeneralError>
}

final class WeatherAPIClientImpl: HTTPClient, WeatherAPIClient {
    func fetchCurrentWeather() async -> Result<WeatherResponse, GeneralError> {
        await sendRequest(endpoint: WeatherEndpoint.getCurrentWeather)
    }
}
