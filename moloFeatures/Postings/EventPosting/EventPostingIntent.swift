//
//  EventPostingIntent.swift
//  Postings
//

import Foundation
import Domain

enum EventPostingIntent {
    case willAppear
    case onClickToDetails(title: String, description: String)
    case onClickToPreview
    case onClickPrevious
    case onClickDateSelection
    case onClickLocationSelection
    case onImageSelected(imageData: Data, filename: String)
    case onImageSourceSet(name: String)
    case storeEventData(venue: String, link: String, ticketLink: String, tags: Set<Int>)
    case onClickSubmit(asDraft: Bool = false)
    case onClose
}
