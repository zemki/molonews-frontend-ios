//
//  ArticleMapper.swift
//  DataLayer
//

import Domain
import Foundation

extension Components.Schemas.ArticleList {
    func toArticle() -> Article {
        Article(
            id: id ?? 0,
            title: title,
            abstract: abstract?.toMarkdown() ?? "",
            date: date,
            address: address ?? "",
            link: link,
            isHot: isHot ?? false,
            tags: tags.map { articleTags in
                articleTags.map { articleTag in
                    articleTag.toTag()
                }
            } ?? [],
            imageUrlString: imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet),
            source: source ?? 0,
            bookmarked: bookmarked ?? false,
            archived: archived ?? false,
            imageSource: imageSource,
            organizationId: organization ?? 0,
            organizationName: organizationName ?? "",
            organizationType: OrganizationType(rawValue: organizationType ?? "") ?? .news,
            organizationLogoUrlString: organizationImage?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet),
            areas: area,
            watchedCount: requestCount,
            bookmarkedCount: bookmarkedCount
        )
    }
}

extension Components.Schemas.ArticleRetrieveSerializerV4 {
    func toArticle() -> Article {
        Article(
            id: id ?? 0,
            title: title,
            abstract: abstract?.toMarkdown() ?? "",
            date: date,
            address: address ?? "",
            link: link,
            isHot: isHot ?? false,
            tags: tags.map { articleTags in
                articleTags.map { articleTag in
                    articleTag.toTag()
                }
            } ?? [],
            imageUrlString: imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet),
            source: source ?? 0,
            content: content ?? "",
            bookmarked: bookmarked ?? false,
            archived: archived ?? false,
            imageSource: imageSource,
            organizationId: organization ?? 0,
            organizationName: organizationName ?? "",
            organizationType: OrganizationType(rawValue: organizationType ?? "") ?? .news,
            organizationLogoUrlString: organizationImage?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet),
            areas: area,
            watchedCount: nil,
            bookmarkedCount: nil,
            isPublished: published ?? true
        )
    }
}

extension Components.Schemas.ArticleBookmarkedArchived {
    func toArticle() -> Article {
        Article(
            id: id ?? 0,
            title: title,
            abstract: abstract?.toMarkdown() ?? "",
            date: date,
            imageUrlString: imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet),
            bookmarked: bookmarked ?? false,
            archived: archived ?? false
        )
    }
}
