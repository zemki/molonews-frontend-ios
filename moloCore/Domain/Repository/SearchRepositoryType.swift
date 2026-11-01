//
//  SearchRepositoryType.swift
//  Domain
//

import Foundation

public enum SearchKeys: String {
    case history = "news.molo.history"
}

public protocol SearchRepositoryType {
    func loadHistory() async throws -> Result<[Domain.SearchItem], Domain.RepositoryError>
    func addToHistory(item: SearchItem) async throws -> Result<Void, Domain.RepositoryError>
    func removeFromHistory(item: SearchItem) async throws -> Result<Void, Domain.RepositoryError>
    func clearHistory() async throws -> Result<Void, Domain.RepositoryError>
}

