//
//  DeletePostedArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class DeletePostedArticleUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articleRepository: ArticleRepositoryType?

    private let articleId: Int

    public init(articleId: Int) {
        self.articleId = articleId
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let articleRepository else {
            throw RepositoryError.diError
        }

        return try await articleRepository.deleteUserArticle(articleId)
    }
}
