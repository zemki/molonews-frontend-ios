//
//  EventCategoryListIntent.swift
//  EventList
//

import Foundation

public enum EventCategoryListIntent {
    case loadEventCategories(searchString: String = "")
    case loadMoreEventsForCategory(id: Int, offset: Int, searchString: String)
    case pullToRefresh(searchString: String)
    case onClickEvent(id: Int)
    case onClickOrganization(id: Int)
}
