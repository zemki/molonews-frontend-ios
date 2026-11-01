//
//  CategoryMapper.swift
//  moloCore
//

import Domain
import Foundation

extension Components.Schemas.TagPreferenceCategory {
    func toCategory() -> Domain.Category {
        Category(
            id: id,
            name: name,
            order: order,
            eventCount: eventCount,
            tags: tags.map { eventTag in
                eventTag.toTag()
            }
        )
    }
}

extension Components.Schemas.TagPreferenceArticleCategory {
    func toCategory() -> Domain.Category {
        Category(
            id: id,
            name: name,
            order: order,
            tags: tags.map { eventTag in
                eventTag.toTag()
            }
        )
    }
}
