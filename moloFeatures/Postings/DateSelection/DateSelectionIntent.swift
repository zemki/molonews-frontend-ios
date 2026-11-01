//
//  DateSelectionIntent.swift
//  Postings
//

import Foundation

enum DateSelectionIntent {
    case willAppear
    case onDateSelectionSubmit(start: Date, end: Date)
    case onDateSelectionCancel
}
