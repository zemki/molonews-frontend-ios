//
//  PagedEvents.swift
//  moloCore
//

import Foundation

public struct PagedEvents {
    public var count: Int
    public var next: String?
    public var previous: String?
    public var results: [Event]
    public var forceReload: Bool = false

    public init(
        count: Int,
        next: String?,
        previous: String?,
        results: [Event]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
