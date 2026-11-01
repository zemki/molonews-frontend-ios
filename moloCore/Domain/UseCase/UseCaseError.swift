//
//  UseCaseError.swift
//  Domain
//

import Foundation

public enum UseCaseError: Error {
    case none,
         diError,
         networkError,
         localStorageError,
         undefinedError,
         observationExecutionError,
         resultExecutionError
}
