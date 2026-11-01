//
//  FetchSearchEventsUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchEventsUseCase: BaseUseCaseExecuter<PagedEvents>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventsRepository: EventRepositoryType?

    private let query: String
    private let offset: Int
    private let limit: Int

    public init(
        query: String,
        offset: Int = 0,
        limit: Int = 20
    ) {
        self.query = query
        self.offset = offset
        self.limit = limit
    }

    override func execute(with deviceId: String) async throws -> Result<PagedEvents, RepositoryError> {
        guard let eventsRepository else {
            throw RepositoryError.diError
        }

        return try await eventsRepository
            .fetchEvents(for: deviceId, query: query, offset: offset, limit: limit)
    }
}
