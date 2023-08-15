//
//  SearchViewModel.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation
import Combine

extension SearchView {
    @MainActor final class ViewModel: ObservableObject {
        // MARK: - PROPERTIES

        @Published var geoItems: [GeoItem] = []
        @Published var isLoading = false
        @Published var error: GeneralError?

        @Published var searchText: String = ""
        @Published private(set) var selectedItem: GeoItem? = nil

        private let apiClient: WeatherAPIClient
        private var cancellables = Set<AnyCancellable>()

        // MARK: - INIT

        init(apiClient: WeatherAPIClient = WeatherAPIClientImpl()) {
            self.apiClient = apiClient

            bindSearchText()
        }

        // MARK: - PUBLIC FUNCTIONS

        func didSelect(_ item: GeoItem) {
            selectedItem = item
        }

        // MARK: - PRIVATE FUNCTIONS

        private func bindSearchText() {
            $searchText
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                .removeDuplicates()
                .compactMap { $0 }
                .sink { [weak self] text in
                    if text.isEmpty {
                        self?.geoItems = []
                    } else {
                        self?.search(query: text)
                    }
                }
                .store(in: &cancellables)
        }

        private func search(query: String) {
            isLoading = true
            Task {
                let result = await apiClient.fetchGeoItems(query: query)
                switch result {
                case .success(let response):
                    geoItems = response
                case .failure(let error):
                    self.error = error
                }

                isLoading = false
            }
        }
    }
}
