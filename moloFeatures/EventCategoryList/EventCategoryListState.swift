//
//  EventCategoryListState.swift
//  EventList
//

import Domain
import Foundation

public enum EventCategoryListState {
    case idle
    case loading
    case success(categories: [Domain.Category], searchString: String)
}
