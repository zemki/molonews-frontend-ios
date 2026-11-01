//
//  UseCaseObserver.swift
//  Domain
//

import Combine
import Foundation

protocol UseCaseObserver<T> {
    associatedtype T: Any

    func observe(with deviceId: String) async throws -> AnyPublisher<T, Never>
}
