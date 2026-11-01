//
//  ResetPasswordUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class RenewPasswordUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    public var password: String

    public init(password: String) {
        self.password = password
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return try await accountRepository.renewPasswordForAccount(password: password)
    }
}
