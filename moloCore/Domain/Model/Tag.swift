//
//  Tag.swift
//  Repository
//

import Foundation

public struct Tag: Equatable, Hashable {
    public var id: Int
    public var name: String
    public var isSelected: Bool
    public var color: String

    public init(
        id: Int,
        name: String = "",
        isSelected: Bool = true,
        color: String = ""
    ) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
        self.color = color
    }
}

public extension Tag {
    static var mock: Tag {
        Tag(id: 1, name: "Mock Tag Name", isSelected: true, color: "#FFFFFF")
    }
}
