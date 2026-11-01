//
//  MoloLocation.swift
//  Domain
//

import Foundation

public struct MoloLocation {
    public var name: String
    public var street: String
    public var zip: String
    public var town: String
    public var latitude: Double
    public var longitude: Double
    public var radius: Double?

    public init(
        name: String?,
        street: String? = nil,
        zip: String? = nil,
        town: String? = nil,
        latitude: Double,
        longitude: Double,
        radius: Double? = nil
    ) {
        self.name = name ?? ""
        self.street = street ?? ""
        self.zip = zip ?? ""
        self.town = town ?? ""
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
}
