//
//  TopicSelectionIntent.swift
//  Account
//

import Foundation

public enum TopicSelectionIntent {
    case loadSelection
    case toggleArticleTopic(id: Int, in: Int)
    case toggleEventTopic(id: Int, in: Int)
    case onClickBack
}
