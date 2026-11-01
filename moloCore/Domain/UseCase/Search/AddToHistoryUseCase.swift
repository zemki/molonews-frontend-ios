//
//  AddToHistoryUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class AddToHistoryUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.searchRepository) private var searchRepository: SearchRepositoryType?

    private let item: SearchItem

    public init(item: SearchItem) {
        self.item = item
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let searchRepository else {
            throw RepositoryError.diError
        }

        return try await searchRepository
            .addToHistory(item: item)
    }
}
