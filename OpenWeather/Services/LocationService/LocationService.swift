//
//  LocationService.swift
//  OpenWeather
//
//  Created by Oleksandr Voropayev on 14.08.2023.
//

import Foundation
import CoreLocation
import Combine

// MARK: - PROTOCOL LocationService

protocol LocationService {
    typealias Location = (latitude: Double, longitude: Double)

    var location: Result<Location?, LocationError> { get }
    var locationPublisher: Published<Result<Location?, LocationError>>.Publisher { get }

    func start()
    func updateLocation()
    func stop()
}

// MARK: - ENUM LocationError

enum LocationError: Error {
    case permissionDenied
    case locationNotFound
}

final class LocationServiceImpl: NSObject, LocationService {
    // MARK: - PROPERTIES

    @Published private(set) var location: Result<Location?, LocationError> = .success(nil)
    var locationPublisher: Published<Result<Location?, LocationError>>.Publisher {
        $location
    }

    private let locationManager = CLLocationManager()

    // MARK: - INIT

    init(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers) {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.pausesLocationUpdatesAutomatically = true
    }

    // MARK: - PUBLIC FUNCTIONS

    func start() {
        performIfAuthorised { [weak self] in
            self?.locationManager.startMonitoringSignificantLocationChanges()
        }
    }

    func updateLocation() {
        performIfAuthorised { [weak self] in
            self?.locationManager.requestLocation()
        }
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - PRIVATE FUNCTIONS

    private func performIfAuthorised(_ block: @escaping ()->()) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            block()
        default:
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
}

// MARK: - DELEGATE

extension LocationServiceImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if case .denied = (error as? CLError)?.code {
            location = .failure(.permissionDenied)
        } else {
            location = .failure(.locationNotFound)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.first.map {
            location = .success(($0.coordinate.latitude, $0.coordinate.longitude))
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .notDetermined, .restricted:
            location = .failure(.permissionDenied)
        @unknown default:
            location = .failure(.permissionDenied)
        }
    }
}

