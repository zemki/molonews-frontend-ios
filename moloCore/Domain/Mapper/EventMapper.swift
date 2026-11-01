//
//  EventMapper.swift
//  Domain
//

import Foundation

public extension Event {
    func toEventPosting() -> PostingEvent {
        PostingEvent(
            id: id,
            imageURLString: imageUrl,
            title: title,
            content: content,
            link: link ?? "",
            location: PostingLocation(
                street: street ?? "",
                town: town ?? "",
                zipCode: zipCode ?? "",
                eventLocation: eventLocation ?? "",
                latitude: latitude ?? .zero,
                longitude: longitude ?? .zero
            ),
            imageSource: imageSource ?? "",
            startDate: eventStartDate ?? Date(),
            endDate: eventEndDate ?? Date(),
            tags: Set(tags.map { tag in
                tag.id
            }),
            published: isPublished
        )
    }
}
