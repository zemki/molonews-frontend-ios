//
//  EventListState.swift
//  EventList
//

import Domain
import Foundation

public enum EventListState {
    case idle
    case loading
    case success(events: [Domain.Event], count: Int, searchString: String)
}
