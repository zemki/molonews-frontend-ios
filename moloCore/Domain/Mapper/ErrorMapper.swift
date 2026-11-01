//
//  ErrorMapper.swift
//  Domain
//

import Foundation

extension RepositoryError {
    func toUseCaseError() -> UseCaseError {
        switch self {
        case .diError:
            return .diError
        case .viewGone:
            return .none
        case .networkError:
            return .networkError
        case .badRequest:
            return .networkError
        case .unauthorized:
            return .networkError
        case .notFound:
            return .networkError
        case .conflict:
            return .networkError
        case .serverError:
            return .networkError
        case .localStorageWriteError:
            return .localStorageError
        case .localStorageReadError:
            return .localStorageError
        case .localStorageDecodingError:
            return .localStorageError
        case let .undocumented(statusCode: statusCode):
            print("[ERROR] undocumented status code: \(statusCode)")
            return .undefinedError
        }
    }
}
