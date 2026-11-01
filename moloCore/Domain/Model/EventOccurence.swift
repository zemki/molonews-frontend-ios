//
//  EventOccurence.swift
//  Domain
//

import Foundation

public struct EventOccurrence {
    public var index: Int?
    public var startDate: Date?
    public var endDate: Date?

    public init(
        index: Int? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.index = index
        self.startDate = startDate
        self.endDate = endDate
    }
}

public extension EventOccurrence {
    static var mock: EventOccurrence {
        EventOccurrence(
            index: 1,
            startDate: Date(),
            endDate: Date()
        )
    }
}
