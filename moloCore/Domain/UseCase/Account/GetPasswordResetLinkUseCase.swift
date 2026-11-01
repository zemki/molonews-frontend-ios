//
//  GetPasswordResetLinkUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class GetPasswordResetLinkUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?
    
    public var email: String
    
    public init(
        email: String
    ) {
        self.email = email
    }
    
    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }
        
        return try await accountRepository.getResetLinkForAccount(for: deviceId, email: email)
    }
}
