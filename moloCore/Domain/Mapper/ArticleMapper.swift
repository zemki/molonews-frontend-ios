//
//  ArticleMapper.swift
//  Domain
//

import Foundation

public extension Article {
    func toArticlePosting() -> PostingArticle {
        PostingArticle(
            id: id,
            imageURLString: imageUrlString,
            title: title,
            content: abstract,
            link: link ?? "",
            imageSource: imageSource ?? "",
            tags: Set(tags.map { tag in
                tag.id
            }),
            published: true
        )
    }
}
