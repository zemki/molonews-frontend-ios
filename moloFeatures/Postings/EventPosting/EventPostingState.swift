//
//  EventPostingState.swift
//  Postings
//

import Domain
import Foundation

enum EventPostingState {
    case idle
    case loading
    case firstStep(event: PostingEvent)
    case secondStep(event: PostingEvent)
    case previewStep(event: PostingEvent)
}
