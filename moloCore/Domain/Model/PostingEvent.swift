//
//  PostingEvent.swift
//  Domain
//

import Foundation

public struct PostingEvent {
    public var id: Int?
    public var imageData: Data?
    public var imageFilename: String
    public var imageURLString: String?
    public var title: String
    public var content: String
    public var link: String
    public var location: PostingLocation
    public var imageSource: String
    public var startDate: Date?
    public var endDate: Date?
    public var ticketUrl: String
    public var tags: Set<Int>
    public var published: Bool
    public var userProfile: UserProfile
    public var categories: [Domain.Category]

    public var dateDescription: String {
        var dateString = ""

        if let startDate {
            dateString.append(startDate.formatted(.germanDateTime))
        }

        if startDate != nil, endDate != nil {
            dateString.append(" - ")
        }

        if let endDate {
            dateString.append(endDate.formatted(.germanDateTime))
        }

        return dateString
    }

    public init(
        id: Int? = nil,
        imageData: Data? = nil,
        imageFilename: String = "",
        imageURLString: String? = nil,
        title: String = "",
        content: String = "",
        link: String = "",
        location: PostingLocation = PostingLocation(),
        imageSource: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        ticketUrl: String = "",
        tags: Set<Int> = [],
        published: Bool = true,
        userProfile: UserProfile = UserProfile(),
        categories: [Domain.Category] = []
    ) {
        self.id = id
        self.imageData = imageData
        self.imageFilename = imageFilename
        self.imageURLString = imageURLString
        self.title = title
        self.content = content
        self.link = link
        self.location = location
        self.imageSource = imageSource
        self.startDate = startDate
        self.endDate = endDate
        self.ticketUrl = ticketUrl
        self.tags = tags
        self.published = published
        self.userProfile = userProfile
        self.categories = categories
    }
}
