//
//  FetchArticlesUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchArticlesUseCase: BaseUseCaseExecuter<PagedArticles>, UseCaseExecuter {
    @Injected(\.articlesRepository) private var articlesRepository: ArticleRepositoryType?

    private let searchString: String?
    private let filter: OrganizationType
    private let offset: Int
    private let limit: Int
    private let ignoreUserSelection: Bool

    public init(
        searchString: String? = nil,
        filter: OrganizationType = .all,
        offset: Int = 0,
        limit: Int = 20,
        ignoreUserSelection: Bool
    ) {
        self.searchString = searchString
        self.filter = filter
        self.offset = offset
        self.limit = limit
        self.ignoreUserSelection = ignoreUserSelection
    }

    override func execute(with deviceId: String) async throws -> Result<PagedArticles, RepositoryError> {
        guard let articlesRepository else {
            throw RepositoryError.diError
        }

        return try await articlesRepository.fetchArticles(
            for: deviceId,
            searchString: searchString,
            filter: filter,
            offset: offset,
            limit: limit,
            ignoreUserSelection: ignoreUserSelection
        )
    }
}
