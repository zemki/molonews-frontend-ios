//
//  SearchState.swift
//  Search
//

import Domain
import Foundation

enum SearchState {
    case idle
    case loading
    case history(items: [SearchItem])
    case searchResults(query: String?)
}
