//
//  TagRepositoryType.swift
//  Domain
//

import Foundation

public protocol TagRepositoryType {
    func fetchArticleTags(for deviceId: String) async throws -> Result<[Domain.Category], Domain.RepositoryError>
    func fetchEventTags(for deviceId: String) async throws -> Result<[Domain.Category], Domain.RepositoryError>
    func storeArticleTags(for deviceId: String, selectedTags: [Int]) async throws -> Result<Void, RepositoryError>
    func storeEventTags(for deviceId: String, selectedTags: [Int]) async throws -> Result<Void, RepositoryError>
    
    func generateArticleTags(for title: String, content: String) async throws -> Result<[Domain.Tag], Domain.RepositoryError>
    func generateEventTags(for title: String, content: String) async throws -> Result<[Domain.Tag], Domain.RepositoryError>
}
