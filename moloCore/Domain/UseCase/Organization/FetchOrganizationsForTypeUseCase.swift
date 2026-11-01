//
//  FetchOrganizationsForTypeUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchOrganizationsForTypeUseCase: BaseUseCaseExecuter<[Organization]>, UseCaseExecuter {
    @Injected(\.organizationRepository) private var organizationRepository: OrganizationRepositoryType?

    private let type: OrganizationType

    public init(type: OrganizationType) {
        self.type = type
    }

    override func execute(with deviceId: String) async throws -> Result<[Organization], RepositoryError> {
        guard let organizationRepository else {
            throw RepositoryError.diError
        }

        return try await organizationRepository.fetchOrganizations(for: deviceId, type: type)
    }
}
