//
//  ToggleBookmarkArticleUseCase.swift
//  moloCore
//

import Combine
import FactoryKit
import Foundation

public class ToggleBookmarkEventUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventRepository: EventRepositoryType?

    private let eventId: Int
    public var isBookmarked: Bool

    public init(eventId: Int, isBookmarked: Bool) {
        self.eventId = eventId
        self.isBookmarked = isBookmarked
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let eventRepository else {
            throw RepositoryError.diError
        }

        if isBookmarked {
            return try await eventRepository.removeFromBookmarks(for: deviceId, eventId: eventId)
        } else {
            return try await eventRepository.addToBookmarks(for: deviceId, eventId: eventId)
        }
    }
}
