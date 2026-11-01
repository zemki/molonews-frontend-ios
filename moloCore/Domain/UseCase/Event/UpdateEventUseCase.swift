//
//  UpdateEventUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class UpdateEventUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventsRepository: EventRepositoryType?

    private let event: PostingEvent

    public init(event: PostingEvent) {
        self.event = event
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let eventsRepository else {
            throw RepositoryError.diError
        }

        return try await eventsRepository.updateUserEvent(event)
    }
}
