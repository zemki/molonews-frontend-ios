//
//  FetchOrganizationUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchOrganizationUseCase: BaseUseCaseExecuter<Organization>, UseCaseExecuter {
    @Injected(\.organizationRepository) private var organizationRepository: OrganizationRepositoryType?

    private let id: Int

    public init(id: Int) {
        self.id = id
    }

    override func execute(with deviceId: String) async throws -> Result<Organization, RepositoryError> {
        guard let organizationRepository else {
            throw RepositoryError.diError
        }

        return try await organizationRepository.fetchOrganization(for: deviceId, id: id)
    }
}
