//
//  RepositoryError.swift
//  Domain
//

import Foundation

public enum RepositoryError: Error {
    case diError,
         viewGone,
         networkError,
         badRequest,
         unauthorized,
         notFound,
         conflict,
         serverError,
         localStorageWriteError,
         localStorageReadError,
         localStorageDecodingError,
         undocumented(statusCode: Int)
}
