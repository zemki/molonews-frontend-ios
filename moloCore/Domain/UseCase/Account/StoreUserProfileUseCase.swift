//
//  StoreUserProfileUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class StoreUserProfileUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    private let userProfile: UserProfile

    public init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return try await accountRepository.storeUserProfile(userProfile: userProfile)
    }
}
