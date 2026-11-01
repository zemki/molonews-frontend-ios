//
//  UpdateArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class UpdateArticleUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let article: PostingArticle

    public init(article: PostingArticle) {
        self.article = article
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        return try await articlesRepository.updateUserArticle(article)
    }
}
