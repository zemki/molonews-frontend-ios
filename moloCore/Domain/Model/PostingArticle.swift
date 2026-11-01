//
//  PostingArticle.swift
//  Domain
//

import Foundation

public struct PostingArticle {
    public var id: Int?
    public var imageData: Data?
    public var imageFilename: String
    public var imageURLString: String?
    public var title: String
    public var content: String
    public var link: String
    public var imageSource: String
    public var tags: Set<Int>
    public var published: Bool
    public var userProfile: UserProfile
    public var categories: [Domain.Category]

    public init(
        id: Int? = nil,
        imageData: Data? = nil,
        imageFilename: String = "",
        imageURLString: String? = nil,
        title: String = "",
        content: String = "",
        link: String = "",
        imageSource: String = "",
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
        self.imageSource = imageSource
        self.tags = tags
        self.published = published
        self.userProfile = userProfile
        self.categories = categories
    }
}
