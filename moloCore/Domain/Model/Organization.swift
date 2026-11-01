//
//  Organization.swift
//  Domain
//

import Foundation

public struct Organization: Hashable {
    public var id: Int
    public var name: String
    public var description: String
    public var type: OrganizationType
    public var imageUrlString: String
    public var isSelected: Bool

    public init(id: Int, name: String, description: String? = nil, type: OrganizationType, imageUrlString: String, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.description = description ?? ""
        self.type = type
        self.imageUrlString = imageUrlString
        self.isSelected = isSelected
    }
}
