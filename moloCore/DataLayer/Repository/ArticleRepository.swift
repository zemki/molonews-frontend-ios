//
//  ArticleRepository.swift
//  Repository
//

import Combine
import Domain
import FactoryKit
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public actor ArticleRepository: ArticleRepositoryType {
    @Injected(\.apiClient) private var client: MoloClient?

    public init() {}

    public func fetchArticles(
        for deviceId: String,
        searchString: String?,
        filter: OrganizationType,
        offset: Int,
        limit: Int,
        ignoreUserSelection: Bool
    ) async throws -> Result<Domain.PagedArticles, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersListArticles.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersListArticles.Input.Query(
            search: searchString,
            limit: limit,
            offset: offset,
            ignoreUserSelection: ignoreUserSelection,
            news: filter == .news || filter == .all,
            official: filter == .official || filter == .all,
            collective: filter == .collective || filter == .all
        )

        let response = try await client.api
            .usersListArticles(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { articleList in
                articleList.toArticle()
            }

            return .success(
                PagedArticles(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchRecentArticles(
        for deviceId: String,
        with organizationId: Int,
        offset: Int,
        limit: Int
    ) async throws -> Result<Domain.PagedArticles, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.ArticlesList.Input.Headers(xDeviceID: deviceId)
        let query = Operations.ArticlesList.Input.Query(
            organizationAllTags: "\(organizationId)",
            ordering: Operations.ArticlesList.Input.Query.OrderingPayload(rawValue: ArticleOrder.DESC.rawValue),
            limit: limit,
            offset: offset
        )

        let response = try await client.api
            .articlesList(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { articleList in
                articleList.toArticle()
            }

            return .success(
                PagedArticles(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchArticle(for deviceId: String, articleId: Int) async throws -> Result<Domain.Article, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.ArticlesRead.Input.Headers(xDeviceID: deviceId)
        let path = Operations.ArticlesRead.Input.Path(id: articleId)
        let response = try await client.api.articlesRead(path: path, headers: headers)

        switch response {
        case let .ok(content):
            let article = try content.body.json.toArticle()
            return .success(article)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchBookmarks(for deviceId: String, offset: Int, limit: Int) async throws -> Result<Domain.PagedArticles, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersArticleBookmarksList.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersArticleBookmarksList.Input.Query(limit: limit, offset: offset)

        let response = try await client.api
            .usersArticleBookmarksList(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { articleList in
                articleList.toArticle()
            }

            return .success(
                PagedArticles(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func addToBookmarks(for deviceId: String, articleId: Int) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersArticleBookmarksUpdate.Input.Headers(xDeviceID: deviceId)
        let path = Operations.UsersArticleBookmarksUpdate.Input.Path(id: articleId)

        let response = try await client.api
            .usersArticleBookmarksUpdate(path: path, headers: headers)

        switch response {
        case .created:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func removeFromBookmarks(for deviceId: String, articleId: Int) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersArticleBookmarksDelete.Input.Headers(xDeviceID: deviceId)
        let path = Operations.UsersArticleBookmarksDelete.Input.Path(id: articleId)

        let response = try await client.api
            .usersArticleBookmarksDelete(path: path, headers: headers)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func reportArticle(for deviceId: String, articleId: Int) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.GeneralFlagArticle.Input.Headers(xDeviceID: deviceId)
        let json = Operations.GeneralFlagArticle.Input.Body.JsonPayload(articleId: articleId)
        let body = Operations.GeneralFlagArticle.Input.Body.json(json)

        let response = try await client.api
            .generalFlagArticle(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchLatestArticles(
        for deviceId: String,
        organizationId: Int,
        offset: Int,
        limit: Int
    ) async throws -> Result<Domain.PagedArticles, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersListArticlesByOrganization.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersListArticlesByOrganization.Input.Query(
            limit: limit,
            offset: offset,
            organizationId: organizationId
        )

        let response = try await client.api
            .usersListArticlesByOrganization(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { articleList in
                articleList.toArticle()
            }

            return .success(
                PagedArticles(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchUserArticles(offset: Int, limit: Int) async throws -> Result<Domain.PagedArticles, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let query = Operations.UsersListUserArticles.Input.Query(limit: limit, offset: offset)

        let response = try await client.api
            .usersListUserArticles(query: query)

        switch response {
        case let .ok(content):
            let count = try content.body.json.count
            let next = try content.body.json.next
            let previous = try content.body.json.previous
            let results = try content.body.json.results.map { articleList in
                articleList.toArticle()
            }

            return .success(
                PagedArticles(
                    count: count,
                    next: next,
                    previous: previous,
                    results: results
                )
            )
        case .badRequest:
            return .failure(.badRequest)
        case .unauthorized:
            return .failure(.unauthorized)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func deleteUserArticle(_ articleId: Int) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let path = Operations.ArticlesDelete.Input.Path(id: articleId)

        let response = try await client.api
            .articlesDelete(path: path)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func postUserArticle(_ article: PostingArticle) async throws -> Result<Int, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let json = Operations.ArticlesCreate.Input.Body.JsonPayload(
            title: article.title,
            abstract: article.content.replacingOccurrences(of: "\n", with: "<br />"),
            link: article.link,
            published: article.published,
            articleTags: article.tags.sorted()
        )
        let body = Operations.ArticlesCreate.Input.Body.json(json)

        let response = try await client.api
            .articlesCreate(body: body)

        switch response {
        case let .created(createdContent):
            if let articleId = try createdContent.body.json.id {
                return .success(articleId)
            }

            return .failure(.serverError)
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func updateUserArticle(_ article: PostingArticle) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client, let id = article.id else {
            return .failure(.diError)
        }

        let path = Operations.ArticlesUpdate.Input.Path(id: id)
        let json = Operations.ArticlesUpdate.Input.Body.JsonPayload(
            title: article.title,
            abstract: article.content.replacingOccurrences(of: "\n", with: "<br />"),
            link: article.link,
            published: article.published,
            articleTags: article.tags.sorted()
        )
        let body = Operations.ArticlesUpdate.Input.Body.json(json)

        let response = try await client.api
            .articlesUpdate(path: path, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func upload(image: Data, filename: String, for articleId: Int, from source: String) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let path = Operations.ArticlesUploadPicture.Input.Path(id: articleId)
        let multipartBody: MultipartBody<Operations.ArticlesUploadPicture.Input.Body.MultipartFormPayload> = [
            .picture(.init(payload: .init(body: HTTPBody(image)), filename: filename)),
            .imageSource(.init(payload: .init(body: HTTPBody(source.isEmpty ? "unbekannt" : source))))
        ]
        let body = Operations.ArticlesUploadPicture.Input.Body.multipartForm(multipartBody)

        let response = try await client.api
            .articlesUploadPicture(path: path, body: body)

        switch response {
        case .created:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case .internalServerError:
            return .failure(.serverError)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }
}
