//
//  FetchTagSelectionUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchTagSelectionUseCase: BaseUseCaseExecuter<[Domain.Category]>, UseCaseExecuter {
    @Injected(\.tagRepository) private var tagRepository: TagRepositoryType?

    public enum TagType {
        case article,
             event
    }

    private let tagType: TagType

    public init(tagType: TagType) {
        self.tagType = tagType
    }

    override func execute(with deviceId: String) async throws -> Result<[Domain.Category], RepositoryError> {
        guard let tagRepository else {
            throw RepositoryError.diError
        }

        switch tagType {
        case .article:
            return try await tagRepository.fetchArticleTags(for: deviceId)
        case .event:
            return try await tagRepository.fetchEventTags(for: deviceId)
        }
    }
}
