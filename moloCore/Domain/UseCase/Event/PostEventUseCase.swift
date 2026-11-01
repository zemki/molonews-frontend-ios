//
//  PostEventUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class PostEventUseCase: BaseUseCaseExecuter<Int>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventsRepository: EventRepositoryType?

    private let event: PostingEvent

    public init(event: PostingEvent) {
        self.event = event
    }

    override func execute(with deviceId: String) async throws -> Result<Int, RepositoryError> {
        guard let eventsRepository else {
            throw RepositoryError.diError
        }

        return try await eventsRepository.postUserEvent(event)
    }
}
