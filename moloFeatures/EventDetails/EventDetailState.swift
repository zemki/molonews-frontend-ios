//
//  ArticleDetailState.swift
//  Explore
//

import Domain
import Foundation

enum EventDetailState {
    case idle
    case loading
    case success(event: Event)
}
