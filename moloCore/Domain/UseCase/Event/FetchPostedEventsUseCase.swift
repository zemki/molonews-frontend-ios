//
//  FetchPostedEventsUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchPostedEventsUseCase: BaseUseCaseExecuter<PagedEvents>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventsRepository: EventRepositoryType?

    private let offset: Int
    private let limit: Int

    public init(
        offset: Int = 0,
        limit: Int = 20
    ) {
        self.offset = offset
        self.limit = limit
    }

    override func execute(with deviceId: String) async throws -> Result<PagedEvents, RepositoryError> {
        guard let eventsRepository else {
            throw RepositoryError.diError
        }

        return try await eventsRepository
            .fetchUserEvents(offset: offset, limit: limit)
    }
}
