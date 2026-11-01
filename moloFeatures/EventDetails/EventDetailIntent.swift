//
//  ArticleDetailIntent.swift
//  Explore
//

import Foundation
import Domain

public enum EventDetailIntent {
    case loadEventDetails
    case onClickOrganization(id: Int)
    case onClickBack
    case onClickShare
    case onClickBookmark
    case onClickTickets(url: String)
    case onClickWebsite(url: String)
    case onClickMore
    case onClickReport
    case onClickMap(lat: Double, long: Double, title: String)
    case onClickSaveInCalendar
}
