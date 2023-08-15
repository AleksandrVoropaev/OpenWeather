//
//  ForecastViewModel.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation
import Combine

extension ForecastView {
    @MainActor final class ViewModel: ObservableObject {
        // MARK: - PROPERTIES

        @Published var weather: WeatherResponse?
        @Published var error: PresentationError?
        @Published var userLocation: GeoItem?
        
        private let apiClient: WeatherAPIClient
        private let locationService: LocationService
        private var cancellables = Set<AnyCancellable>()

        // MARK: - INIT

        init(apiClient: WeatherAPIClient = WeatherAPIClientImpl(),
             locationService: LocationService = LocationServiceImpl()
        ) {
            self.apiClient = apiClient
            self.locationService = locationService

            bindLocationService()
            bindUserLocation()
        }

        // MARK: - PUBLIC FUNCTIONS

        func refreshForecast() {
            locationService.updateLocation()
        }

        // MARK: - PRIVATE FUNCTIONS

        private func fetchForecast(latitude: Double, longitude: Double) async {
            let weather = await apiClient.fetchCurrentWeather(latitude: latitude, longitude: longitude)

            switch weather {
            case .success(let weather):
                self.weather = weather
                self.error = nil
            case .failure:
                self.weather = nil
                self.error = .network
            }
        }

        private func bindLocationService() {
            locationService.locationPublisher
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] result in
                    guard let self else { return }

                    self.userLocation = nil
                    self.error = nil
                    self.weather = nil

                    switch result {
                    case .success(.none):
                        break
                    case .success(.some(let location)):
                        Task {
                            await self.fetchForecast(latitude: location.latitude, longitude: location.longitude)
                        }
                    case .failure(let error):
                        self.error = .location(error)
                    }
                }
                .store(in: &cancellables)

            locationService.start()
        }

        private func bindUserLocation() {
            $userLocation
                .compactMap { $0 }
                .map { ($0.latitude, $0.longitude) }
                .sink { [weak self] location in
                    Task {
                        await self?.fetchForecast(latitude: location.0, longitude: location.1)
                    }
                }
                .store(in: &cancellables)
        }
    }
}

extension ForecastView {
    enum PresentationError: Error, LocalizedError {
        case location(LocationError)
        case network

        var errorDescription: String? {
            switch self {
            case .location: return "Location error"
            case .network: return "Network error"
            }
        }
    }
}
