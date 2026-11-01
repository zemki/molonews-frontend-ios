//
//  RemoveOrganizationFromSourcesUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class RemoveOrganizationFromSourcesUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.organizationRepository) private var organizationRepository: OrganizationRepositoryType?

    private let organizationId: Int

    public init(organizationId: Int) {
        self.organizationId = organizationId
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let organizationRepository else {
            throw RepositoryError.diError
        }

        return try await organizationRepository.removeOrganization(for: deviceId, organizationId: organizationId)
    }
}
