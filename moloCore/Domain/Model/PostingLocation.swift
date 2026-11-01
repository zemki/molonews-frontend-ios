//
//  PostingLocation.swift
//  Domain
//

import Foundation

public struct PostingLocation {
    public var street: String
    public var town: String
    public var zipCode: String
    public var eventLocation: String
    public var latitude: Double
    public var longitude: Double

    public var addressDescription: String {
        if street.isEmpty, zipCode.isEmpty, town.isEmpty {
            return ""
        }

        let town = [zipCode, town].compactMap { $0 }.joined(separator: " ")
        let result = [street, town].compactMap { $0 }.joined(separator: ", ")

        return result
    }

    public init(
        street: String = "",
        town: String = "",
        zipCode: String = "",
        eventLocation: String = "",
        latitude: Double = .zero,
        longitude: Double = .zero
    ) {
        self.street = street
        self.town = town
        self.zipCode = zipCode
        self.eventLocation = eventLocation
        self.latitude = latitude
        self.longitude = longitude
    }
}
