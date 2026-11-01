//
//  Area.swift
//  Domain
//

import Foundation

public struct Area: Hashable {
    public var id: Int
    public var name: String
    public var longitude: String
    public var latitude: String

    public init(
        id: Int,
        name: String,
        longitude: String,
        latitude: String
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
