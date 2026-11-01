//
//  EventRepositoryType.swift
//  moloCore
//

import Foundation

public protocol EventRepositoryType {
    func fetchEventsByCategory(
        for deviceId: String,
        dateStart: Date?,
        dateEnd: Date?,
        categoryId: Int,
        offset: Int,
        limit: Int,
        searchString: String?
    ) async throws -> Result<PagedEvents, RepositoryError>
    func fetchEvent(for deviceId: String, eventId: Int) async throws -> Result<Event, RepositoryError>
    func fetchCategories(for deviceId: String, dateStart: Date?, dateEnd: Date?, searchString: String?) async throws
        -> Result<[Domain.Category], RepositoryError>
    func fetchBookmarks(for deviceId: String, offset: Int, limit: Int) async throws -> Result<PagedEvents, RepositoryError>
    func fetchEvents(for deviceId: String, query: String, offset: Int, limit: Int) async throws -> Result<PagedEvents, RepositoryError>
    func addToBookmarks(for deviceId: String, eventId: Int) async throws -> Result<Void, RepositoryError>
    func removeFromBookmarks(for deviceId: String, eventId: Int) async throws -> Result<Void, RepositoryError>
    func reportEvent(for deviceId: String, eventId: Int) async throws -> Result<Void, RepositoryError>
    func fetchUpcomingEvents(
        for deviceId: String,
        organizationId: Int,
        offset: Int,
        limit: Int
    ) async throws -> Result<PagedEvents, RepositoryError>

    func fetchUserEvents(offset: Int, limit: Int) async throws -> Result<PagedEvents, RepositoryError>
    func deleteUserEvent(_ eventId: Int) async throws -> Result<Void, RepositoryError>
    func postUserEvent(_ event: PostingEvent) async throws -> Result<Int, RepositoryError>
    func updateUserEvent(_ event: PostingEvent) async throws -> Result<Void, RepositoryError>
    func upload(image: Data, filename: String, for eventId: Int, from source: String) async throws -> Result<Void, Domain.RepositoryError>
}
