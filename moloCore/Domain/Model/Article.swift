//
//  Article.swift
//  Repository
//

import Foundation

public struct Article {
    public var id: Int
    public var title: String
    public var abstract: String
    public var date: Date?
    public var address: String
    public var link: String?
    public var isHot: Bool
    public var tags: [Tag]
    public var imageUrlString: String?
    public var content: String
    public var bookmarked: Bool
    public var archived: Bool
    public var imageSource: String?
    public var organizationId: Int
    public var source: Int
    public var organizationName: String
    public var organizationType: OrganizationType
    public var organizationLogoUrlString: String?
    public var nearby: Bool
    public var areas: [Int]
    public var watchedCount: Int?
    public var bookmarkedCount: Int?
    public var isPublished: Bool

    public init(
        id: Int = 0,
        title: String = "",
        abstract: String = "",
        date: Date? = nil,
        address: String = "",
        link: String? = nil,
        isHot: Bool = false,
        tags: [Tag] = [],
        imageUrlString: String? = nil,
        source: Int = 0,
        content: String = "",
        bookmarked: Bool = false,
        archived: Bool = false,
        imageSource: String? = nil,
        organizationId: Int = 0,
        organizationName: String = "",
        organizationType: OrganizationType = .unknown,
        organizationLogoUrlString: String? = nil,
        nearby: Bool = false,
        areas: [Int] = [],
        watchedCount: Int? = nil,
        bookmarkedCount: Int? = nil,
        isPublished: Bool = true
    ) {
        self.id = id
        self.title = title
        self.abstract = abstract
        self.date = date
        self.address = address
        self.link = link
        self.isHot = isHot
        self.tags = tags
        self.imageUrlString = imageUrlString
        self.source = source
        self.content = content
        self.bookmarked = bookmarked
        self.archived = archived
        self.imageSource = imageSource
        self.organizationId = organizationId
        self.organizationName = organizationName
        self.organizationType = organizationType
        self.organizationLogoUrlString = organizationLogoUrlString
        self.nearby = nearby
        self.areas = areas
        self.watchedCount = watchedCount
        self.bookmarkedCount = bookmarkedCount
        self.isPublished = isPublished
    }
}
