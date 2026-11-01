//
//  FetchEventsForOrganizationUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchEventsForOrganizationUseCase: BaseUseCaseExecuter<PagedEvents> {
    @Injected(\.eventsRepository) private var eventRepository: EventRepositoryType?

    private let organizationId: Int
    private let offset: Int
    private let limit: Int

    public init(organizationId: Int, at offset: Int = 0, limit: Int = 20) {
        self.organizationId = organizationId
        self.offset = offset
        self.limit = limit
    }

    override func execute(with deviceId: String) async throws -> Result<PagedEvents, RepositoryError> {
        guard let eventRepository else {
            throw RepositoryError.diError
        }

        return try await eventRepository.fetchUpcomingEvents(for: deviceId, organizationId: organizationId, offset: offset, limit: limit)
    }
}
