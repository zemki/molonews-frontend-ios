//
//  ClearHistoryUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class ClearHistoryUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.searchRepository) private var searchRepository: SearchRepositoryType?
    
    override public init() {}
    
    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let searchRepository else {
            throw RepositoryError.diError
        }
        
        return try await searchRepository.clearHistory()
    }
}
