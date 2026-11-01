//
//  FetchMoloLocationsFromCoordinatesUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class FetchMoloLocationsFromCoordinatesUseCase: BaseUseCaseExecuter<[Area]>, UseCaseExecuter {
    @Injected(\.locationRepository) private var locationRepository: LocationRepositoryType?

    private let latitude: Double
    private let longitude: Double
    private let radius: Int

    public init(latitude: Double, longitude: Double, radius: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }

    override func execute(with deviceId: String) async throws -> Result<[Area], RepositoryError> {
        guard let locationRepository else {
            throw RepositoryError.diError
        }

        return try await locationRepository.fetchAreas(for: latitude, longitude: longitude, distance: radius)
    }
}
