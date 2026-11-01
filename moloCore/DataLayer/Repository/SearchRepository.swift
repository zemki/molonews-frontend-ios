//
//  SearchRepository.swift
//  DataLayer
//

import Combine
import Domain
import FactoryKit
import Foundation

public actor SearchRepository: SearchRepositoryType {
    public init() {}

    public func loadHistory() async throws -> Result<[Domain.SearchItem], Domain.RepositoryError> {
        guard let data = UserDefaults.standard.data(forKey: SearchKeys.history.rawValue),
              let items = try? JSONDecoder().decode([SearchItem].self, from: data) else {
            return .success([])
        }

        return .success(items)
    }

    public func addToHistory(item: Domain.SearchItem) async throws -> Result<Void, Domain.RepositoryError> {
        var items: [SearchItem] = []

        if let data = UserDefaults.standard.data(forKey: SearchKeys.history.rawValue) {
            items = try JSONDecoder().decode([SearchItem].self, from: data)
        }

        if let index = items.firstIndex(where: { searchItem in
            searchItem.query == item.query
        }) {
            items.remove(at: index)
        }

        items.insert(item, at: 0)

        if items.count > 100 {
            items.removeSubrange(100...)
        }

        let updatedData = try JSONEncoder().encode(items)
        UserDefaults.standard.set(updatedData, forKey: SearchKeys.history.rawValue)

        return .success(())
    }

    public func removeFromHistory(item: Domain.SearchItem) async throws -> Result<Void, Domain.RepositoryError> {
        guard let data = UserDefaults.standard.data(forKey: SearchKeys.history.rawValue),
              var items = try? JSONDecoder().decode([SearchItem].self, from: data) else {
            return .failure(.localStorageReadError)
        }

        if let index = items.firstIndex(where: { searchItem in
            searchItem.query == item.query
        }) {
            items.remove(at: index)

            let updatedData = try JSONEncoder().encode(items)
            UserDefaults.standard.set(updatedData, forKey: SearchKeys.history.rawValue)
        }

        return .success(())
    }

    public func clearHistory() async throws -> Result<Void, Domain.RepositoryError> {
        UserDefaults.standard.removeObject(forKey: SearchKeys.history.rawValue)

        return .success(())
    }
}
