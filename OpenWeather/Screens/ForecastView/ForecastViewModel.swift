//
//  ForecastViewModel.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation
import Combine

extension ForecastView {
    enum PresentationError: Error {
        case location(LocationError)
        case network
    }

    @MainActor final class ViewModel: ObservableObject {
        @Published var weather: WeatherResponse?
        @Published var error: PresentationError?

        @Published var userLocation: GeoItem?
        
        private let apiClient: WeatherAPIClient
        private let locationService: LocationService
        private var cancellables = Set<AnyCancellable>()

        init(apiClient: WeatherAPIClient = WeatherAPIClientImpl(),
             locationService: LocationService = LocationServiceImpl()
        ) {
            self.apiClient = apiClient
            self.locationService = locationService

            bindLocationService()
            bindUserLocation()
        }

        func refreshForecast() {
            userLocation = nil
            weather = nil

            if case.success(.some(let location)) = locationService.location {
                Task {
                    weather = nil
                    error = nil
                    await fetchForecast(latitude: location.latitude, longitude: location.longitude)
                }
            }
        }

        private func fetchForecast(latitude: Double, longitude: Double) async {
            let weather = await apiClient.fetchCurrentWeather(latitude: latitude, longitude: longitude)

            switch weather {
            case .success(let weather):
                self.weather = weather
                self.error = nil
            case .failure(let error):
                print(error)
                self.weather = nil
                self.error = .network
            }
        }

        private func bindLocationService() {
            locationService.locationPublisher
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] result in
                    guard let self else { return }

                    switch result {
                    case .success(.none):
                        break
                    case .success(.some(let location)):
                        Task {
                            await self.fetchForecast(latitude: location.latitude, longitude: location.longitude)
                        }
                    case .failure(let error):
                        self.weather = nil
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
