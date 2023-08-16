//
//  UnitsManager.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 15.08.2023.
//

import Foundation
import Combine

protocol UnitsManager {
    var currentMeasurementSystem: Locale.MeasurementSystem { get }
    var didUpdateLocale: AnyPublisher<Void, Never> { get }

    func formattedString(fromTemperature temperature: Double?) -> String
}

final class UnitsManagerImpl: ObservableObject, UnitsManager {
    // MARK: - PROPERTIES

    @Published private(set) var currentMeasurementSystem: Locale.MeasurementSystem = Locale.current.measurementSystem
    var didUpdateLocale: AnyPublisher<Void, Never> {
        $currentMeasurementSystem
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    private let temperatureFormatter = MeasurementFormatter()
    private var temperatureUnit: UnitTemperature?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - INIT

    init() {
        bindUserLocale()
        temperatureUnit = currentTemperatureUnit(with: currentMeasurementSystem)
    }

    // MARK: - PUBLIC FUNCTIONS

    func formattedString(fromTemperature temperature: Double?) -> String {
        guard let temperature, let temperatureUnit else {
            return "--"
        }

        let measurment = Measurement(value: temperature.rounded(), unit: temperatureUnit)

        return temperatureFormatter.string(from: measurment)
    }

    // MARK: - PRIVATE FUNCTIONS

    private func bindUserLocale() {
        NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .sink { [weak self] _ in
                self?.updateLocale(measurementSystem: Locale.current.measurementSystem)
            }
            .store(in: &cancellables)
    }

    private func updateLocale(measurementSystem: Locale.MeasurementSystem) {
        temperatureUnit = currentTemperatureUnit(with: measurementSystem)
        currentMeasurementSystem = measurementSystem
    }

    private func currentTemperatureUnit(with measurementSystem: Locale.MeasurementSystem) -> UnitTemperature {
        if case .metric = measurementSystem {
            return .celsius
        }

        return .fahrenheit
    }
}
