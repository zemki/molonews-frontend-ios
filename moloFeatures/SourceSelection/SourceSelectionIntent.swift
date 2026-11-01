//
//  SourceSelectionIntent.swift
//  SourceSelection
//

import Foundation

enum SourceSelectionIntent {
    case toggleNews(id: Int)
    case toggleOfficial(id: Int)
    case toggleCollective(id: Int)
    case onClickOrganization(id: Int)
    case onClickBack
}
