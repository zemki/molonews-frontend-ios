//
//  StoreSelectedSourcesUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class StoreSelectedSourcesUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.organizationRepository) private var organizationRepository: OrganizationRepositoryType?

    private let organizationIds: [Int]

    public init(organizationIds: [Int]) {
        self.organizationIds = organizationIds
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let organizationRepository else {
            throw RepositoryError.diError
        }

        return try await organizationRepository.storeSelectedOrganizations(for: deviceId, organizationIds: organizationIds)
    }
}
