//
//  LocationSelectionState.swift
//  LocationSelection
//

import Foundation
import Domain

enum LocationSelectionState {
    case idle
    case loading
    case postingAddressLocated(postingLocation: PostingLocation)
    case located(name: String, radius: Double, latitude: Double, longitude: Double, areas: [Area])
}
