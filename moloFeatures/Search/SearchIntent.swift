//
//  SearchIntent.swift
//  Search
//

import Domain
import Foundation

enum SearchIntent {
    case willAppear
    case onStartSearch(query: String, force: Bool, type: SearchType)
    case backToHistory
    case onClickRemoveFromHistory(query: String)
    case onClickClearHistory
}
