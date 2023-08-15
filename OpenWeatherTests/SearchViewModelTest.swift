//
//  SearchViewModelTest.swift
//  OpenWeatherTests
//
//  Created by Oleksandr Voropayev on 15.08.2023.
//

import XCTest
@testable import OpenWeather

final class SearchViewModelTest: XCTestCase {
    @MainActor func testSearchSuccess() throws {
        let viewModel = SearchView.ViewModel(apiClient: WeatherAPIClientMock())

        viewModel.searchText = "A"

        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "Test after 0.6 seconds")], timeout: 0.6)

        XCTAssertFalse(viewModel.geoItems.isEmpty)
        XCTAssertEqual(viewModel.geoItems.first?.displayName, "Altstadt, Bavaria, DE")
        XCTAssertNil(viewModel.error)
    }

    @MainActor func testSearchFailure() throws {
        let viewModel = SearchView.ViewModel(apiClient: WeatherAPIClientUnhappyMock())

        viewModel.searchText = "A"

        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "Test after 0.6 seconds")], timeout: 0.6)

        XCTAssertTrue(viewModel.geoItems.isEmpty)
        XCTAssertNotNil(viewModel.error)
    }
}

private class WeatherAPIClientMock: WeatherAPIClient {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async -> Result<WeatherResponse, GeneralError> {
        fatalError("Not implemented")
    }

    func fetchGeoItems(query: String) async -> Result<[GeoItem], GeneralError> {
        return .success(GeoItem.mocksArray)
    }
}

private class WeatherAPIClientUnhappyMock: WeatherAPIClient {
    func fetchCurrentWeather(latitude: Double, longitude: Double) async -> Result<WeatherResponse, GeneralError> {
        fatalError("Not implemented")
    }

    func fetchGeoItems(query: String) async -> Result<[GeoItem], GeneralError> {
        return .failure(.unknown)
    }
}
