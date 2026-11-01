//
//  GetCurrentGPSLocationUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class GetCurrentGPSLocationUseCase: BaseUseCaseExecuter<MoloLocation>, UseCaseExecuter {
    @Injected(\.locationRepository) private var locationRepository: LocationRepositoryType?

    override public init() {}

    override func execute(with deviceId: String) async throws -> Result<MoloLocation, RepositoryError> {
        guard let locationRepository else {
            throw RepositoryError.diError
        }

        let (latitude, longitude) = try await locationRepository.getCurrentGPSLocation().get()
        return try await locationRepository.reverseGeocodeByLocation(latitude: latitude, longitude: longitude)
    }
}
