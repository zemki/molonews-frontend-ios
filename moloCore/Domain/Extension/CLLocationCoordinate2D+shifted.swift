//
//  CLLocationCoordinate2D+shifted.swift
//  Domain
//

import CoreLocation
import Foundation

public extension CLLocationCoordinate2D {
    func shifted(latitudeOffsetKm: Double) -> CLLocationCoordinate2D {
        let deltaLat = latitudeOffsetKm / 111.0
        return CLLocationCoordinate2D(latitude: latitude + deltaLat, longitude: longitude)
    }
}
