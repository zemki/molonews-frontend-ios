//
//  ReportArticleUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class ReportArticleUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let articleId: Int

    public init(articleId: Int) {
        self.articleId = articleId
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        return try await articlesRepository.reportArticle(for: deviceId, articleId: self.articleId)
    }
}
