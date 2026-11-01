//
//  ArticleRepositoryType.swift
//  Domain
//

import Foundation

public protocol ArticleRepositoryType {
    func fetchArticles(
        for deviceId: String,
        searchString: String?,
        filter: OrganizationType,
        offset: Int,
        limit: Int,
        ignoreUserSelection: Bool
    ) async throws -> Result<PagedArticles, RepositoryError>
    func fetchRecentArticles(for deviceId: String, with organizationId: Int, offset: Int, limit: Int) async throws
        -> Result<PagedArticles, RepositoryError>
    func fetchArticle(for deviceId: String, articleId: Int) async throws -> Result<Article, RepositoryError>

    func fetchBookmarks(for deviceId: String, offset: Int, limit: Int) async throws -> Result<PagedArticles, RepositoryError>
    func addToBookmarks(for deviceId: String, articleId: Int) async throws -> Result<Void, RepositoryError>
    func removeFromBookmarks(for deviceId: String, articleId: Int) async throws -> Result<Void, RepositoryError>

    func reportArticle(for deviceId: String, articleId: Int) async throws -> Result<Void, RepositoryError>
    func fetchLatestArticles(
        for deviceId: String,
        organizationId: Int,
        offset: Int,
        limit: Int
    ) async throws -> Result<PagedArticles, RepositoryError>

    func fetchUserArticles(offset: Int, limit: Int) async throws -> Result<PagedArticles, RepositoryError>
    func deleteUserArticle(_ articleId: Int) async throws -> Result<Void, RepositoryError>
    func postUserArticle(_ article: PostingArticle) async throws -> Result<Int, Domain.RepositoryError>
    func updateUserArticle(_ article: PostingArticle) async throws -> Result<Void, Domain.RepositoryError>
    func upload(image: Data, filename: String, for articleId: Int, from source: String) async throws -> Result<Void, Domain.RepositoryError>
}
