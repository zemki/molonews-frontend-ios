//
//  WebContentState.swift
//  WebContent
//

import Domain
import Foundation

enum WebContentState {
    case idle
    case success(url: String)
}
