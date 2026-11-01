//
//  SearchItem.swift
//  Domain
//

import Foundation

public struct SearchItem: Codable, Identifiable {
    public let id = UUID()
    public var query: String

    public init(query: String) {
        self.query = query
    }
}

public enum SearchType {
    case articles,
         events
}
