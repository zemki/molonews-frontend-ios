//
//  EventListIntent.swift
//  EventList
//

import Foundation

public enum EventListIntent {
    case loadEvents(searchString: String = "")
    case loadMoreEvents(offset: Int)
    case pullToRefresh
    case onClickEvent(id: Int)
    case onClickOrganization(id: Int)
    case onClickDeletePosting(id: Int)
}
