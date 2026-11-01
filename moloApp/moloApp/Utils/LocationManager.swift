//
//  LocationManager.swift
//  moloApp
//

import CoreLocation
import Foundation
import SwiftUI

@MainActor
final class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()
    private lazy var managerDelegate = LocationDelegateProxy(
        onAuthStatusChanged: { [weak self] status in
            Task { @MainActor in
                self?.authorizationStatus = status
            }
        },
        onLocationsChanged: { [weak self] locations in
            guard let newLocation = locations.last else {
                return
            }

            Task { @MainActor in
                self?.location = newLocation
            }
        },
        onError: { error in
            Task { @MainActor in
                NotificationCenter.default.post(name: .locationErrorNotification, object: error)
            }
        }
    )

    func requestAccess() {
        manager.delegate = managerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }

    func determineLocation() {
        manager.startUpdatingLocation()
    }

    func stopDetermination() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
}

final class LocationDelegateProxy: NSObject, CLLocationManagerDelegate {
    var onAuthStatusChanged: @Sendable (CLAuthorizationStatus) -> Void
    var onLocationsChanged: @Sendable ([CLLocation]) -> Void
    var onError: @Sendable (Error)
        -> Void

    init(
        onAuthStatusChanged: @escaping @Sendable (CLAuthorizationStatus) -> Void,
        onLocationsChanged: @escaping @Sendable ([CLLocation]) -> Void,
        onError: @escaping @Sendable (Error) -> Void
    ) {
        self.onAuthStatusChanged = onAuthStatusChanged
        self.onLocationsChanged = onLocationsChanged
        self.onError = onError
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onAuthStatusChanged(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocationsChanged(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onError(error)
    }
}
