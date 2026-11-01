//
//  LoginUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class LoginUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    public var email: String
    public var password: String

    public init(
        email: String,
        password: String
    ) {
        self.email = email
        self.password = password
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return try await accountRepository.loginUserAccount(
            for: deviceId,
            email: email,
            password: password
        )
    }
}
