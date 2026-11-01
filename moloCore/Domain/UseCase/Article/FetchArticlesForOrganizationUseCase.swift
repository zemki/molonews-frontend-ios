//
//  FetchArticlesForOrganizationUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchArticlesForOrganizationUseCase: BaseUseCaseExecuter<PagedArticles> {
    @Injected(\.articlesRepository) private var articleRepository: ArticleRepositoryType?

    private let organizationId: Int
    private let offset: Int
    private let limit: Int

    public init(organizationId: Int, at offset: Int = 0, limit: Int = 20) {
        self.organizationId = organizationId
        self.offset = offset
        self.limit = limit
    }

    override func execute(with deviceId: String) async throws -> Result<PagedArticles, RepositoryError> {
        guard let articleRepository else {
            throw RepositoryError.diError
        }

        return try await articleRepository.fetchLatestArticles(for: deviceId, organizationId: organizationId, offset: offset, limit: limit)
    }
}
