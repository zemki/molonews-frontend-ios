//
//  GeocodeLocationByNameUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class GeocodeLocationByNameUseCase: BaseUseCaseExecuter<MoloLocation>, UseCaseExecuter {
    @Injected(\.locationRepository) private var locationRepository: LocationRepositoryType?

    private let address: String

    public init(address: String) {
        self.address = address
    }

    override func execute(with deviceId: String) async throws -> Result<MoloLocation, RepositoryError> {
        guard let locationRepository else {
            throw RepositoryError.diError
        }

        return try await locationRepository.geocodeLocationFromAddress(address)
    }
}
