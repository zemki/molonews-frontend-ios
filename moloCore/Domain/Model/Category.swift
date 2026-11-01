//
//  Category.swift
//  moloCore
//

import Foundation

public struct Category {
    public var id: Int?
    public var name: String
    public var order: Int?
    public var eventCount: Int
    public var tags: [Tag]
    public var events: [Event] = []

    public init(
        id: Int?,
        name: String,
        order: Int?,
        eventCount: Int = 0,
        tags: [Tag],
        events: [Event] = []
    ) {
        self.id = id
        self.name = name
        self.order = order
        self.eventCount = eventCount
        self.tags = tags
        self.events = events
    }
}
