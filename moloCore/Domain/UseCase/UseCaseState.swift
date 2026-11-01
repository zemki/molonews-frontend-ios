//
//  UseCaseState.swift
//  Domain
//

import Foundation

public enum UseCaseState<T> {
    case isLoading
    case success(T)
    case error(UseCaseError)
}
