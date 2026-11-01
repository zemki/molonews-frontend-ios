//
//  LoadUserProfileUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class LoadUserProfileUseCase: BaseUseCaseExecuter<UserProfile>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    override public init() {}

    override func execute(with deviceId: String) async throws -> Result<UserProfile, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return try await accountRepository.getUserProfile()
    }
}
