//
//  FetchArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchArticleUseCase: BaseUseCaseExecuter<Article>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let articleId: Int

    public init(articleId: Int) {
        self.articleId = articleId
    }

    override func execute(with deviceId: String) async throws -> Result<Article, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        return try await articlesRepository.fetchArticle(for: deviceId, articleId: self.articleId)
    }
}
