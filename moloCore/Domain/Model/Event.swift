//
//  Event.swift
//  Domain
//

import Foundation

public struct Event {
    public var id: Int
    public var title: String
    public var abstract: String
    public var eventDate: Date?
    public var eventStartDate: Date?
    public var eventEndDate: Date?
    public var town: String?
    public var street: String?
    public var zipCode: String?
    public var longitude: Double?
    public var latitude: Double?
    public var link: String?
    public var tags: [Tag]
    public var organizationid: Int
    public var organizationType: OrganizationType?
    public var organizationName: String?
    public var organizationLogoUrlString: String?
    public var content: String
    public var bookmarked: Bool
    public var imageSource: String?
    public var imageUrl: String
    public var eventLocation: String?
    public var eventOccurences: [EventOccurrence]
    public var ticketUrl: String?
    public var watchedCount: Int?
    public var bookmarkedCount: Int?
    public var isPublished: Bool

    public init(
        id: Int,
        title: String,
        abstract: String,
        eventDate: Date?,
        eventStartDate: Date?,
        eventEndDate: Date?,
        town: String?,
        street: String?,
        zipCode: String?,
        longitude: Double? = nil,
        latitude: Double? = nil,
        link: String? = nil,
        tags: [Tag] = [],
        organizationid: Int,
        imageUrl: String,
        eventLocation: String?,
        content: String,
        bookmarked: Bool = false,
        imageSource: String? = nil,
        organizationName: String?,
        organizationLogoUrlString: String?,
        organizationType: OrganizationType? = nil,
        eventOccurences: [EventOccurrence] = [],
        ticketUrl: String? = nil,
        watchedCount: Int? = nil,
        bookmarkedCount: Int? = nil,
        isPublished: Bool = true
    ) {
        self.id = id
        self.title = title
        self.abstract = abstract
        self.eventDate = eventDate
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        self.town = town
        self.street = street
        self.zipCode = zipCode
        self.longitude = longitude
        self.latitude = latitude
        self.link = link
        self.tags = tags
        self.imageUrl = imageUrl
        self.eventLocation = eventLocation
        self.content = content
        self.bookmarked = bookmarked
        self.imageSource = imageSource
        self.organizationid = organizationid
        self.organizationName = organizationName
        self.organizationLogoUrlString = organizationLogoUrlString
        self.organizationType = organizationType
        self.eventOccurences = eventOccurences
        self.ticketUrl = ticketUrl
        self.watchedCount = watchedCount
        self.bookmarkedCount = bookmarkedCount
        self.isPublished = isPublished
    }
}

public extension Event {
    static var mock: Event {
        Event(
            id: 1,
            title: "Mock Event Title",
            abstract: "This is a sample event abstract.",
            eventDate: Date(),
            eventStartDate: Date(),
            eventEndDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            town: "Sample Town",
            street: "123 Sample Street",
            zipCode: "12345",
            longitude: 12.345678,
            latitude: 98.765432,
            link: "https://example.com",
            tags: [Tag.mock],
            organizationid: 42,
            imageUrl: "https://example.com/image.jpg",
            eventLocation: "Sample Venue",
            content: "<p>This is the full HTML content of the event.</p>",
            bookmarked: false,
            imageSource: "Sample Source",
            organizationName: "Sample Organization",
            organizationLogoUrlString: "https://example.com/logo.png",
            organizationType: .official,
            eventOccurences: [EventOccurrence.mock],
            ticketUrl: "https://tickets.example.com",
            watchedCount: 5,
            bookmarkedCount: 0,
            isPublished: true
        )
    }
}
