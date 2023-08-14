//
//  WetherAPIClient.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation

protocol WeatherAPIClient {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async -> Result<WeatherResponse, GeneralError>
    func fetchGeoItems(query: String) async -> Result<[GeoItem], GeneralError>
}

final class WeatherAPIClientImpl: HTTPClient, WeatherAPIClient {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async -> Result<WeatherResponse, GeneralError> {
        await sendRequest(endpoint: WeatherEndpoint.getCurrentWeather(latitude: latitude, longitude: longitude))
    }

    func fetchGeoItems(query: String) async -> Result<[GeoItem], GeneralError> {
        await sendRequest(endpoint: WeatherEndpoint.getGeoItems(query: query))
    }
}
