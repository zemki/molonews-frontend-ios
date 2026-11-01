//
//  ReportArticleUseCase.swift
//  moloCore
//

import Combine
import FactoryKit
import Foundation

public class ReportEventUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventRepository: EventRepositoryType?

    private let eventId: Int

    public init(eventId: Int) {
        self.eventId = eventId
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let eventRepository else {
            throw RepositoryError.diError
        }

        return try await eventRepository.reportEvent(for: deviceId, eventId: eventId)
    }
}
