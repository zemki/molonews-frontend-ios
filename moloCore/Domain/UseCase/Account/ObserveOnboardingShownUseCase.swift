//
//  ObserveOnboardingShownUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class ObserveOnboardingShownUseCase: BaseUseCaseExecuter<Bool>, UseCaseObserver {
    override public init() {}

    override func observe(with deviceId: String) -> AnyPublisher<Bool, Never> {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .map { _ in
                UserDefaults.standard.bool(forKey: Keys.isOnboardingFinished.rawValue) == true
            }
            .removeDuplicates()
            .prepend(UserDefaults.standard.bool(forKey: Keys.isOnboardingFinished.rawValue) == true)
            .eraseToAnyPublisher()
    }
}
