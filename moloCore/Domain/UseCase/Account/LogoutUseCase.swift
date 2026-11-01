//
//  LogoutUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class LogoutUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    override public init() {}

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return await accountRepository.clearTokens()
    }
}
