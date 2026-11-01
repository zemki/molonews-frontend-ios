//
//  FetchPostedArticlesUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchPostedArticlesUseCase: BaseUseCaseExecuter<PagedArticles>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let offset: Int
    private let limit: Int

    public init(
        offset: Int = 0,
        limit: Int = 20
    ) {
        self.offset = offset
        self.limit = limit
    }

    override func execute(with deviceId: String) async throws -> Result<PagedArticles, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        return try await articlesRepository
            .fetchUserArticles(offset: offset, limit: limit)
    }
}
