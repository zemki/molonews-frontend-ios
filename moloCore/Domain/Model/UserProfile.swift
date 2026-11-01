//
//  UserProfile.swift
//  Domain
//

import Foundation

public struct UserProfile: Equatable {
    public let organizationId: Int
    public let username: String
    public let firstName: String
    public let lastName: String
    public let description: String
    public let imageUrl: String
    public let email: String
    public let displayName: String
    public let area: Area?
    public let homepage: String
    public let imageData: Data?

    public init(
        organizationId: Int = 0,
        username: String = "",
        firstName: String = "",
        lastName: String = "",
        description: String = "",
        imageUrl: String = "",
        email: String = "",
        displayName: String = "",
        area: Area? = nil,
        homepage: String = "",
        imageData: Data? = nil
    ) {
        self.organizationId = organizationId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.description = description
        self.imageUrl = imageUrl
        self.email = email
        self.displayName = displayName
        self.area = area
        self.homepage = homepage
        self.imageData = imageData
    }
}
