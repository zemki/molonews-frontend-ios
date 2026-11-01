//
//  TagRepository.swift
//  DataLayer
//

import Combine
import Domain
import FactoryKit
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public actor TagRepository: TagRepositoryType {
    @Injected(\.apiClient) private var client: MoloClient?

    public init() {}

    public func fetchArticleTags(for deviceId: String) async throws -> Result<[Domain.Category], Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersListTagPreferencesArticles.Input.Headers(xDeviceID: deviceId)

        let response = try await client.api
            .usersListTagPreferencesArticles(headers: headers)

        switch response {
        case let .ok(content):
            let tagCategories = try content.body.json.map { tagPreferenceCategory in
                tagPreferenceCategory.toCategory()
            }

            return .success(tagCategories)
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchEventTags(for deviceId: String) async throws -> Result<[Domain.Category], Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersListTagPreferencesEvents.Input.Headers(xDeviceID: deviceId)

        let response = try await client.api
            .usersListTagPreferencesEvents(headers: headers)

        switch response {
        case let .ok(content):
            let tagCategories = try content.body.json.map { tagPreferenceCategory in
                tagPreferenceCategory.toCategory()
            }

            return .success(tagCategories)
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func storeArticleTags(for deviceId: String, selectedTags: [Int]) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersSetTagPreferencesArticles.Input.Headers(xDeviceID: deviceId)
        let tagList = Operations.UsersSetTagPreferencesArticles.Input.Body.JsonPayload(tagIds: selectedTags)
        let body = Operations.UsersSetTagPreferencesArticles.Input.Body.json(tagList)

        let response = try await client.api
            .usersSetTagPreferencesArticles(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func storeEventTags(for deviceId: String, selectedTags: [Int]) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersSetTagPreferencesEvents.Input.Headers(xDeviceID: deviceId)
        let tagList = Operations.UsersSetTagPreferencesEvents.Input.Body.JsonPayload(tagIds: selectedTags)
        let body = Operations.UsersSetTagPreferencesEvents.Input.Body.json(tagList)

        let response = try await client.api
            .usersSetTagPreferencesEvents(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func generateArticleTags(for title: String, content: String) async throws -> Result<[Domain.Tag], Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.AIGenerateArticleTagsCreate.Input.Headers()
        let formPayload = Operations.AIGenerateArticleTagsCreate.Input.Body.UrlEncodedFormPayload(title: title, abstract: content)
        let body = Operations.AIGenerateArticleTagsCreate.Input.Body.urlEncodedForm(formPayload)

        let response = try await client.api
            .aiGenerateArticleTagsCreate(headers: headers, body: body)

        switch response {
        case let .ok(content):
            let tags = try content.body.json.map { tag in
                tag.toTag()
            }

            return .success(tags)
        case .noContent:
            return .success([])
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func generateEventTags(for title: String, content: String) async throws -> Result<[Domain.Tag], Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.AIGenerateEventTagsCreate.Input.Headers()
        let formPayload = Operations.AIGenerateEventTagsCreate.Input.Body.UrlEncodedFormPayload(title: title, abstract: content)
        let body = Operations.AIGenerateEventTagsCreate.Input.Body.urlEncodedForm(formPayload)

        let response = try await client.api
            .aiGenerateEventTagsCreate(headers: headers, body: body)

        switch response {
        case let .ok(content):
            let tags = try content.body.json.map { tag in
                tag.toTag()
            }

            return .success(tags)
        case .noContent:
            return .success([])
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }
}
