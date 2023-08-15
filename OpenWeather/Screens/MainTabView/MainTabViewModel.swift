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
        // MARK: - PROPERTIES

        let forecastViewModel: ForecastView.ViewModel
        let searchViewModel: SearchView.ViewModel

        private(set) var selectedTab = CurrentValueSubject<Tab, Never>(.forecast)

        private var cancellables = Set<AnyCancellable>()

        // MARK: - INIT

        init(apiClient: WeatherAPIClient = WeatherAPIClientImpl()) {
            forecastViewModel = .init(apiClient: apiClient)
            searchViewModel = .init(apiClient: apiClient)

            prepareBindings()
        }

        // MARK: - PRIVATE FUNCTIONS

        private func prepareBindings() {
            searchViewModel.$selectedItem
                .print()
                .sink { [weak self] in
                    self?.forecastViewModel.userLocation = $0

                    guard $0 != nil else { return }

                    self?.selectedTab.send(.forecast)
                }
                .store(in: &cancellables)
        }
    }
}
