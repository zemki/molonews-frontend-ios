//
//  LoadHistoryUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class LoadHistoryUseCase: BaseUseCaseExecuter<[SearchItem]>, UseCaseExecuter {
    @Injected(\.searchRepository) private var searchRepository: SearchRepositoryType?
    
    override public init() {}
    
    override func execute(with deviceId: String) async throws -> Result<[SearchItem], RepositoryError> {
        guard let searchRepository else {
            throw RepositoryError.diError
        }
        
        return try await searchRepository.loadHistory()
    }
}
