//
//  TagMapper.swift
//  DataLayer
//

import Domain
import Foundation

extension Components.Schemas.ArticleTagsSerializerV4 {
    func toTag() -> Tag {
        Tag(
            id: id ?? 0,
            name: name,
            isSelected: selected ?? false,
            color: color ?? ""
        )
    }
}

extension Components.Schemas.EventTags {
    func toTag() -> Tag {
        Tag(
            id: id ?? 0,
            name: name,
            isSelected: selected ?? false,
            color: color ?? ""
        )
    }
}

extension Components.Schemas.TagPreferenceTag {
    func toTag() -> Tag {
        Tag(
            id: id,
            name: name,
            isSelected: selected,
            color: color
        )
    }
}

extension Components.Schemas.TagSerializerId {
    func toTag() -> Tag {
        Tag(id: id ?? 0)
    }
}
