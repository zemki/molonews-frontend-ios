//
//  StoreTagSelectionUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class StoreTagSelectionUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.tagRepository) private var tagRepository: TagRepositoryType?

    public enum TagType {
        case article,
             event
    }

    private let tagType: TagType
    private let selectedTags: [Int]

    public init(tagType: TagType, selectedTags: [Int]) {
        self.tagType = tagType
        self.selectedTags = selectedTags
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let tagRepository else {
            throw RepositoryError.diError
        }

        switch tagType {
        case .article:
            return try await tagRepository.storeArticleTags(for: deviceId, selectedTags: selectedTags)
        case .event:
            return try await tagRepository.storeEventTags(for: deviceId, selectedTags: selectedTags)
        }
    }
}
