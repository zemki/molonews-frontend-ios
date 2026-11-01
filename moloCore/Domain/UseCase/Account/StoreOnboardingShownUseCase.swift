//
//  StoreOnboardingShownUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class StoreOnboardingShownUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    private let isShown: Bool

    public init(isShown: Bool) {
        self.isShown = isShown
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        return await accountRepository.storeIsOnboardingFinished(value: true)
    }
}
