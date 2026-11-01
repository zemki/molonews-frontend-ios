//
//  EventMapper.swift
//  moloCore
//

import Domain
import Foundation

extension Components.Schemas.EventListSerializerShort {
    func toEvent() -> Domain.Event {
        return Event(
            id: id ?? 0,
            title: title,
            abstract: "",
            eventDate: startDate,
            eventStartDate: startDate,
            eventEndDate: Calendar.current.date(byAdding: .hour, value: 1, to: startDate),
            town: town,
            street: street,
            zipCode: zipCode,
            organizationid: organization ?? 0,
            imageUrl: imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet) ?? "",
            eventLocation: eventLocation,
            content: content?.fromHtml() ?? "",
            organizationName: organizationName,
            organizationLogoUrlString: organizationImage,
            isPublished: true
        )
    }
}

extension Components.Schemas.EventList {
    func toEvent() -> Domain.Event {
        return Event(
            id: id ?? 0,
            title: title,
            abstract: "",
            eventDate: startDate,
            eventStartDate: startDate,
            eventEndDate: endDate,
            town: town,
            street: street,
            zipCode: zipCode,
            longitude: Double(longitude ?? "") ?? 0.0,
            latitude: Double(latitude ?? "") ?? 0.0,
            link: link,
            tags: tags.map { eventTags in
                eventTags.map { eventTag in
                    eventTag.toTag()
                }
            } ?? [],
            organizationid: organization ?? 0,
            imageUrl: imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet) ?? "",
            eventLocation: eventLocation,
            content: content?.fromHtml() ?? "",
            bookmarked: bookmarked ?? false,
            imageSource: imageSource,
            organizationName: organizationName,
            organizationLogoUrlString: organizationImage,
            organizationType: OrganizationType(rawValue: organizationType ?? "") ?? .news,
            eventOccurences: occurrencesList.map { occurences in
                occurences.map { occurence in
                    occurence.toEventOccurrence()
                }
            } ?? [],
            ticketUrl: ticketUrl,
            watchedCount: requestCount,
            bookmarkedCount: bookmarkedCount,
            isPublished: published ?? true
        )
    }
}

extension Components.Schemas.EventRetrieve {
    func toEvent() -> Domain.Event {
        return Event(
            id: id ?? 0,
            title: title,
            abstract: "",
            eventDate: startDate,
            eventStartDate: startDate,
            eventEndDate: endDate,
            town: town,
            street: street,
            zipCode: zipCode,
            longitude: Double(longitude ?? "") ?? 0.0,
            latitude: Double(latitude ?? "") ?? 0.0,
            link: link,
            tags: tags.map { eventTags in
                eventTags.map { eventTag in
                    eventTag.toTag()
                }
            } ?? [],
            organizationid: organization ?? 0,
            imageUrl: imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet) ?? "",
            eventLocation: eventLocation,
            content: content?.fromHtml() ?? "",
            bookmarked: bookmarked ?? false,
            imageSource: imageSource,
            organizationName: organizationName,
            organizationLogoUrlString: organizationImage,
            organizationType: OrganizationType(rawValue: organizationType ?? "") ?? .news,
            eventOccurences: [],
            ticketUrl: ticketUrl,
            watchedCount: requestCount,
            bookmarkedCount: bookmarkedCount,
            isPublished: true
        )
    }
}
