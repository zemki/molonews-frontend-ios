//
//  FetchArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchEventUseCase: BaseUseCaseExecuter<Event> {
    @Injected(\.eventsRepository) private var eventRepository: EventRepositoryType?

    private let eventId: Int

    public init(eventId: Int) {
        self.eventId = eventId
    }

    override func execute(with deviceId: String) async throws -> Result<Event, RepositoryError> {
        guard let eventRepository else {
            throw RepositoryError.diError
        }

        return try await eventRepository.fetchEvent(for: deviceId, eventId: eventId)
    }
}
