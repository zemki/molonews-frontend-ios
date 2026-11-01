//
//  StorePushTokenUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class StorePushTokenUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    private let token: String

    public init(token: String) {
        self.token = token
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return try await accountRepository.storePushToken(for: deviceId, token: token)
    }
}
