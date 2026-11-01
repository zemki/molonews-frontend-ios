//
//  LocationRepository.swift
//  DataLayer
//

import Combine
import Domain
import FactoryKit
import Foundation
import MapKit
import OpenAPIRuntime
import OpenAPIURLSession

public actor LocationRepository: LocationRepositoryType {    
    @Injected(\.apiClient) private var client: MoloClient?

    let locationManager = LocationManager()

    public init() {}

    public func fetchAreas(for latitude: Double, longitude: Double, distance: Int) async throws -> Result<[Area], RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let query = Operations.AreaByDistance.Input.Query(
            longitude: String(longitude),
            latitude: String(latitude),
            distance: String(distance)
        )

        let response = try await client.api.areaByDistance(query: query)

        switch response {
        case let .ok(content):
            if try content.body.json.count > 0 {
                let areas = try content.body.json.results.map { area in
                    area.toArea()
                }
                return .success(areas)
            } else {
                return .failure(.serverError)
            }
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func storeAreaSelection(for deviceId: String, latitude: Double, longitude: Double,
                                   distance: Int) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersSetAreasByLocation.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersSetAreasByLocation.Input.Query(
            longitude: String(longitude),
            latitude: String(latitude),
            distance: String(distance)
        )

        let response = try await client.api.usersSetAreasByLocation(query: query, headers: headers)

        switch response {
        case .ok:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func getCurrentGPSLocation() async throws -> Result<(latitude: Double, longitude: Double), RepositoryError> {
        do {
            let coordinate = try await locationManager.requestCurrentCoordinates()
            return .success((latitude: coordinate.latitude, longitude: coordinate.longitude))
        } catch {
            return .failure(.notFound)
        }
    }

    public func geocodeLocationFromAddress(_ address: String) async throws -> Result<Domain.MoloLocation, RepositoryError> {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.geocodeAddressString(address)
        
        guard let placemark = placemarks.first else {
            return .failure(.notFound)
        }

        guard let coordinate = placemark.location?.coordinate else {
            return .failure(.notFound)
        }
        
        let street = [placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
        let zip = placemark.postalCode
        let town = placemark.locality

        return .success(MoloLocation(name: address, street: street, zip: zip, town: town, latitude: coordinate.latitude, longitude: coordinate.longitude))
    }

    public func reverseGeocodeByLocation(latitude: Double, longitude: Double) async throws -> Result<Domain.MoloLocation, RepositoryError> {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(location)

        if placemarks.count <= 0 {
            return .failure(.notFound)
        }

        return .success(MoloLocation(name: placemarks.first?.locality, latitude: latitude, longitude: longitude))
    }
}
