//
//  LocationMap.swift
//  Atoms
//

import Assets
import Dimensions
import MapKit
import SwiftUI

public struct LocationMap: View {
    private let location: CLLocationCoordinate2D
    private let height: CGFloat
    private let onClickMap: () -> Void

    @State private var position: MapCameraPosition

    public init(location: CLLocationCoordinate2D, distance: Double = 1000, height: CGFloat = 300, onClickMap: @escaping () -> Void) {
        self.location = location
        self.height = height
        self.onClickMap = onClickMap

        position = .camera(
            .init(centerCoordinate: location, distance: distance)
        )
    }

    public var body: some View {
        Map(position: $position, interactionModes: .zoom) {
            Marker(coordinate: location) {}
        }
        .mapControlVisibility(.hidden)
        .frame(height: height)
        .clipShape(.rect(cornerRadius: .cornerRadiusMedium))
        .onTapGesture {
            onClickMap()
        }
    }
}
