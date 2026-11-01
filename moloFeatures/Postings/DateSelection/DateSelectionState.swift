//
//  DateSelectionState.swift
//  Postings
//

import Foundation

enum DateSelectionState {
    case idle
    case loading
    case success(start: Date?, end: Date?)
}
