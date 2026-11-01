//
//  GetTagPostingPreselectionUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class GetTagPostingPreselectionUseCase: BaseUseCaseExecuter<[Domain.Tag]>, UseCaseExecuter {
    @Injected(\.tagRepository) private var tagRepository: TagRepositoryType?
    
    public enum TagType {
        case article,
             event
    }
    
    private let tagType: TagType
    private let title: String
    private let content: String
    
    public init(tagType: TagType, title: String, content: String) {
        self.tagType = tagType
        self.title = title
        self.content = content
    }
    
    override func execute(with deviceId: String) async throws -> Result<[Domain.Tag], RepositoryError> {
        guard let tagRepository else {
            throw RepositoryError.diError
        }
        
        switch tagType {
        case .article:
            return try await tagRepository.generateArticleTags(for: title, content: content)
        case .event:
            return try await tagRepository.generateEventTags(for: title, content: content)
        }
    }
}
