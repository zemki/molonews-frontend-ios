//
//  ObserveIsLoggedInUseCase.swift
//  Domain
//

import Combine
import FactoryKit
import Foundation

public final class ObserveIsLoggedInUseCase: BaseUseCaseExecuter<Bool>, UseCaseObserver {
    override public init() {}

    override func observe(with deviceId: String) -> AnyPublisher<Bool, Never> {
        NotificationCenter.default.publisher(for: TokenStore.didChange)
            .map { _ in () }
            .prepend(())
            .map { (try? TokenStore.shared.value(for: .access)) != nil }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
