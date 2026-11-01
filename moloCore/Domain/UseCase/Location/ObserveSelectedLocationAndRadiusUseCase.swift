//
//  ObserveSelectedLocationAndRadiusUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public class ObserveSelectedLocationAndRadiusUseCase: BaseUseCaseExecuter<String>, UseCaseObserver {
    override public init() {}

    override func observe(with deviceId: String) -> AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .map { _ in
                let areaName = UserDefaults.standard.string(forKey: Keys.areaName.rawValue)?.appending(" + ") ?? ""
                let radiusString = UserDefaults.standard.string(forKey: Keys.areaRadius.rawValue)?.appending(" km") ?? ""

                return areaName + radiusString
            }
            .eraseToAnyPublisher()
    }
}
