//
//  RegisterUserUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class RegisterUserUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    public var prename: String
    public var lastname: String
    public var email: String
    public var password: String
    public var displayName: String

    public init(
        prename: String,
        lastname: String,
        email: String,
        password: String,
        displayName: String
    ) {
        self.prename = prename
        self.lastname = lastname
        self.email = email
        self.password = password
        self.displayName = displayName
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return try await accountRepository.createUserAccount(
            for: deviceId,
            email: email,
            password: password,
            prename: prename,
            lastname: lastname,
            displayName: displayName
        )
    }
}
