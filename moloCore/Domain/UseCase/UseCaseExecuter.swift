//
//  UseCaseExecuter.swift
//  Domain
//

import Combine
import Foundation

protocol UseCaseExecuter<T> {
    associatedtype T: Any
    
    func execute(with deviceId: String) async throws -> Result<T, RepositoryError>
}
