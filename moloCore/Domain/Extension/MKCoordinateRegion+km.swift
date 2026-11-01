//
//  MKCoordinateRegion+km.swift
//  Domain
//

import Foundation
import MapKit

public extension MKCoordinateRegion {
    static func region(center: CLLocationCoordinate2D, radiusInKm: Double) -> MKCoordinateRegion {
        let latitudeDelta = (radiusInKm / 111.0) * 2
        let longitudeDelta = (radiusInKm / (111.0 * cos(center.latitude * .pi / 180))) * 2
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        return MKCoordinateRegion(center: center, span: span)
    }
}
