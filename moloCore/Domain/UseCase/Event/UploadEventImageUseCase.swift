//
//  UploadEventImageUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class UploadEventImageUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventRepository: EventRepositoryType?

    private let eventId: Int
    private let file: Data
    private let filename: String
    private let source: String

    public init(eventId: Int, file: Data, filename: String, source: String) {
        self.eventId = eventId
        self.file = file
        self.filename = filename
        self.source = source
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let eventRepository else {
            throw RepositoryError.diError
        }

        return try await eventRepository.upload(image: file, filename: filename, for: eventId, from: source)
    }
}
