//
//  ToggleBookmarkArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class ToggleBookmarkArticleUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let articleId: Int
    private let isBookmarked: Bool

    public init(articleId: Int, isBookmarked: Bool) {
        self.articleId = articleId
        self.isBookmarked = isBookmarked
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        if isBookmarked {
            return try await articlesRepository.removeFromBookmarks(for: deviceId, articleId: articleId)
        } else {
            return try await articlesRepository.addToBookmarks(for: deviceId, articleId: articleId)
        }
    }
}
