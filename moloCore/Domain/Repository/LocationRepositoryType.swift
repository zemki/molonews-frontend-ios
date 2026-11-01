//
//  LocationRepositoryType.swift
//  Domain
//

import Foundation

public protocol LocationRepositoryType {
    func fetchAreas(for latitude: Double, longitude: Double, distance: Int) async throws -> Result<[Domain.Area], RepositoryError>
    func storeAreaSelection(for deviceId: String, latitude: Double, longitude: Double, distance: Int) async throws -> Result<Void, RepositoryError>

    func getCurrentGPSLocation() async throws -> Result<(latitude: Double, longitude: Double), RepositoryError>
    func geocodeLocationFromAddress(_ address: String) async throws -> Result<Domain.MoloLocation, RepositoryError>
    func reverseGeocodeByLocation(latitude: Double, longitude: Double) async throws -> Result<Domain.MoloLocation, RepositoryError>
}
