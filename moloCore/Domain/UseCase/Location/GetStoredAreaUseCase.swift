//
//  GetStoredAreaUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class GetStoredAreaUseCase: BaseUseCaseExecuter<MoloLocation>, UseCaseExecuter {
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    override public init() {}

    override func execute(with deviceId: String) async throws -> Result<MoloLocation, RepositoryError> {
        guard let accountRepository else {
            throw RepositoryError.diError
        }

        guard let name = try await accountRepository.fetchAreaName().get(),
              let radius = try await accountRepository.fetchAreaRadius().get(),
              let latitude = try await accountRepository.fetchAreaLatitude().get(),
              let longitude = try await accountRepository.fetchAreaLongitude().get() else {
            return .failure(.notFound)
        }

        return .success(MoloLocation(name: name, latitude: latitude, longitude: longitude, radius: Double(radius)))
    }
}
