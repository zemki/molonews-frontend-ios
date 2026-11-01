//
//  StoreAreaUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class StoreAreaUseCase: BaseUseCaseExecuter<Void>, UseCaseExecuter {
    @Injected(\.locationRepository) private var locationRepository: LocationRepositoryType?
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    let name: String
    let latitude: Double
    let longitude: Double
    let radius: Float

    public init(name: String, latitude: Double, longitude: Double, radius: Float) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }

    override func execute(with deviceId: String) async throws -> Result<Void, RepositoryError> {
        guard let locationRepository,
              let accountRepository else {
            throw RepositoryError.diError
        }

        let storeResult = try await locationRepository
            .storeAreaSelection(
                for: deviceId,
                latitude: latitude,
                longitude: longitude,
                distance: Int(radius)
            )
        
        if case let .failure(error) = storeResult {
            return .failure(error)
        }
        
        let resultName = await accountRepository.storeAreaName(value: name)
        let resultRadius = await accountRepository.storeAreaRadius(value: Int(radius))
        let latitude = await accountRepository.storeAreaLatitude(value: latitude)
        let longitude = await accountRepository.storeAreaLongitude(value: longitude)
        
        
        if case .failure = resultName {
            return resultName
        }
        
        if case .failure = resultRadius {
            return resultRadius
        }
        
        if case .failure = latitude {
            return latitude
        }
        
        if case .failure = longitude {
            return longitude
        }
        
        return .success(())
    }
}
