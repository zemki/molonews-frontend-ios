//
//  PagedArticles.swift
//  Model
//

import Foundation

public struct PagedArticles {
    public var count: Int
    public var next: String?
    public var previous: String?
    public var results: [Article]
    public var forceReload: Bool = false

    public init(
        count: Int,
        next: String?,
        previous: String?,
        results: [Article]
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
