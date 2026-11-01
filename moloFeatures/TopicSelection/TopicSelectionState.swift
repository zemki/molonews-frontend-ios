//
//  TopicSelectionState.swift
//  Account
//

import Domain
import Foundation

enum TopicSelectionState {
    case idle
    case loading
    case success(articleCategories: [Domain.Category], eventCategories: [Domain.Category])
}
