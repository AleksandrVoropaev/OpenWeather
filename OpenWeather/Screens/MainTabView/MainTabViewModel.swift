//
//  MainTabViewModel.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation
import Combine

extension MainTabView {
    @MainActor final class ViewModel: ObservableObject {
        let forecastViewModel: ForecastView.ViewModel
        let searchViewModel: SearchView.ViewModel

        @Published var selectedTab = 1

        private var cancellables = Set<AnyCancellable>()

        init(apiClient: WeatherAPIClient = WeatherAPIClientImpl()) {
            forecastViewModel = .init(apiClient: apiClient)
            searchViewModel = .init(apiClient: apiClient)

            prepareBindings()
        }

        private func prepareBindings() {
            searchViewModel.$selectedItem
                .print()
                .sink { [weak self] in
                    self?.forecastViewModel.userLocation = $0

                    guard $0 != nil else { return }

                    self?.selectedTab = 1
                }
                .store(in: &cancellables)
        }
    }
}
