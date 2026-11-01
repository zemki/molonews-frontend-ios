//
//  EventRepository.swift
//  moloCore
//

import Combine
import Domain
import FactoryKit
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public actor EventRepository: EventRepositoryType {
    @Injected(\.apiClient) private var client: MoloClient?

    public init() {}

    public func fetchEventsByCategory(
        for deviceId: String,
        dateStart: Date?,
        dateEnd: Date?,
        categoryId: Int,
        offset: Int,
        limit: Int,
        searchString: String?
    ) async throws -> Result<Domain.PagedEvents, Domain.RepositoryError> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersListFutureEventsByCategory.Input.Headers(xDeviceID: deviceId)

        var query = Operations.UsersListFutureEventsByCategory.Input.Query(
            search: searchString,
            limit: limit,
            offset: offset,
            categoryId: categoryId
        )

        if let start = dateStart, let end = dateEnd {
            query = Operations.UsersListFutureEventsByCategory.Input.Query(
                search: searchString,
                limit: limit,
                offset: offset,
                categoryId: categoryId,
                dateStart: dateFormatter.string(from: start),
                dateEnd: dateFormatter.string(from: end)
            )
        }

        let response = try await client.api
            .usersListFutureEventsByCategory(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { eventList in
                eventList.toEvent()
            }

            return .success((
                PagedEvents(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                ),
            ))
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchCategories(
        for deviceId: String, dateStart: Date?,
        dateEnd: Date?,
        searchString: String?
    ) async throws -> Result<[Domain.Category], Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let headers = Operations.UsersListTagPreferencesEvents.Input.Headers(xDeviceID: deviceId)

        var response: Operations.UsersListTagPreferencesEvents.Output?

        if let dateStart = dateStart, let dateEnd = dateEnd {
            let query = Operations.UsersListTagPreferencesEvents.Input.Query(
                dateStart: dateFormatter.string(from: dateStart),
                dateEnd: dateFormatter.string(from: dateEnd),
                //        searchString: searchString TODO: missing in API
            )
            response = try await client.api
                .usersListTagPreferencesEvents(query: query, headers: headers)
        } else {
            response = try await client.api
                .usersListTagPreferencesEvents(headers: headers)
        }

        switch response {
        case let .ok(content):
            let categories = try content.body.json

            return .success(
                categories.map {
                    $0.toCategory()
                }
            )
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        case .none:
            return .failure(.serverError)
        }
    }

    public func fetchBookmarks(for deviceId: String, offset: Int, limit: Int) async throws -> Result<Domain.PagedEvents, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersEventBookmarksList.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersEventBookmarksList.Input.Query(limit: limit, offset: offset)

        let response = try await client.api
            .usersEventBookmarksList(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { eventList in
                eventList.toEvent()
            }

            return .success(
                PagedEvents(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchEvents(for deviceId: String, query: String, offset: Int, limit: Int) async throws -> Result<PagedEvents, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.EventsList.Input.Headers(xDeviceID: deviceId)
        let query = Operations.EventsList.Input.Query(ordering: .eventDate, search: query, offset: offset)

        let response = try await client.api.eventsList(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { eventList in
                eventList.toEvent()
            }

            return .success(
                PagedEvents(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func addToBookmarks(for deviceId: String, eventId: Int) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersEventBookmarksUpdate.Input.Headers(xDeviceID: deviceId)
        let path = Operations.UsersEventBookmarksUpdate.Input.Path(id: eventId)

        let response = try await client.api
            .usersEventBookmarksUpdate(path: path, headers: headers)

        switch response {
        case .created:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func removeFromBookmarks(for deviceId: String, eventId: Int) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersEventBookmarksDelete.Input.Headers(xDeviceID: deviceId)
        let path = Operations.UsersEventBookmarksDelete.Input.Path(id: eventId)

        let response = try await client.api
            .usersEventBookmarksDelete(path: path, headers: headers)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchEvent(for deviceId: String, eventId: Int) async throws -> Result<Domain.Event, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.EventsRead.Input.Headers(xDeviceID: deviceId)
        let path = Operations.EventsRead.Input.Path(id: eventId)

        let response = try await client.api.eventsRead(path: path, headers: headers)

        switch response {
        case let .ok(content):
            let event = try content.body.json.toEvent()
            return .success(event)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func reportEvent(for deviceId: String, eventId: Int) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.GeneralFlagEvent.Input.Headers(xDeviceID: deviceId)
        let json = Operations.GeneralFlagEvent.Input.Body.JsonPayload(eventId: eventId)
        let body = Operations.GeneralFlagEvent.Input.Body.json(json)

        let response = try await client.api
            .generalFlagEvent(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchUpcomingEvents(
        for deviceId: String,
        organizationId: Int,
        offset: Int,
        limit: Int
    ) async throws -> Result<PagedEvents, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersListEventsByOrganization.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersListEventsByOrganization.Input.Query(limit: limit, offset: offset, organizationId: organizationId)

        let response = try await client.api
            .usersListEventsByOrganization(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { eventList in
                eventList.toEvent()
            }

            return .success((
                PagedEvents(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                ),
            ))
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchUserEvents(offset: Int, limit: Int) async throws -> Result<Domain.PagedEvents, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let query = Operations.UsersListUserEvents.Input.Query(limit: limit, offset: offset)

        let response = try await client.api
            .usersListUserEvents(query: query)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { eventList in
                eventList.toEvent()
            }

            return .success(
                PagedEvents(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case .unauthorized:
            return .failure(.unauthorized)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func deleteUserEvent(_ eventId: Int) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let path = Operations.EventsDelete.Input.Path(id: eventId)

        let response = try await client.api
            .eventsDelete(path: path)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func postUserEvent(_ event: PostingEvent) async throws -> Result<Int, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let json = Operations.EventsCreate.Input.Body.JsonPayload(
            title: event.title,
            content: event.content.replacingOccurrences(of: "\n", with: "<br />"),
            link: event.link,
            street: event.location.street,
            town: event.location.town,
            zipCode: event.location.zipCode,
            imageUrl: nil,
            eventLocation: event.location.eventLocation,
            longitude: event.location.longitude,
            latitude: event.location.latitude,
            imageSource: event.imageSource,
            published: event.published,
            occurrences: [
                Operations.EventsCreate.Input.Body.JsonPayload.OccurrencesPayloadPayload(eventStartDate: event.startDate, eventEndDate: event.endDate)
            ],
            eventTags: event.tags.sorted()
        )

        let body = Operations.EventsCreate.Input.Body.json(json)

        let response = try await client.api
            .eventsCreate(body: body)

        switch response {
        case let .created(createdContent):
            if let eventId = try createdContent.body.json.id {
                return .success(eventId)
            }

            return .failure(.serverError)
        case .badRequest:
            return .failure(.badRequest)
        case .conflict:
            return .failure(.conflict)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func updateUserEvent(_ event: PostingEvent) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client, let id = event.id else {
            return .failure(.diError)
        }

        let path = Operations.EventsUpdate.Input.Path(id: id)
        let json = Operations.EventsUpdate.Input.Body.JsonPayload(
            title: event.title,
            content: event.content.replacingOccurrences(of: "\n", with: "<br />"),
            link: event.link,
            date: nil,
            street: event.location.street,
            town: event.location.town,
            zipCode: event.location.zipCode,
            imageUrl: nil,
            eventLocation: event.location.eventLocation,
            longitude: event.location.longitude,
            latitude: event.location.latitude,
            imageSource: event.imageSource,
            published: event.published,
            occurrences: [
                Operations.EventsUpdate.Input.Body.JsonPayload.OccurrencesPayloadPayload(eventStartDate: event.startDate, eventEndDate: event.endDate)
            ],
            area: [],
            eventTags: event.tags.sorted()
        )
        let body = Operations.EventsUpdate.Input.Body.json(json)

        let response = try await client.api
            .eventsUpdate(path: path, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func upload(image: Data, filename: String, for eventId: Int, from source: String) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let path = Operations.EventsUploadPicture.Input.Path(id: eventId)
        let multipartBody: MultipartBody<Operations.EventsUploadPicture.Input.Body.MultipartFormPayload> = [
            .picture(.init(payload: .init(body: HTTPBody(image)), filename: filename)),
            .imageSource(.init(payload: .init(body: HTTPBody(source.isEmpty ? "unbekannt" : source))))
        ]
        let body = Operations.EventsUploadPicture.Input.Body.multipartForm(multipartBody)

        let response = try await client.api
            .eventsUploadPicture(path: path, body: body)

        switch response {
        case .created:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case .internalServerError:
            return .failure(.serverError)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }
}
