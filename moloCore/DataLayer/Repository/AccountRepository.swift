//
//  AccountRepository.swift
//  DataLayer
//

import Combine
import Domain
import FactoryKit
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import UIKit

public actor AccountRepository: AccountRepositoryType {
    @Injected(\.apiClient) private var client: MoloClient?

    public init() {}

    public func fetchDeviceId() async -> Result<String, RepositoryError> {
        guard let deviceId = UserDefaults.standard.string(forKey: Keys.deviceId.rawValue) else {
            return await createDeviceId()
        }

        return .success(deviceId)
    }

    private func createDeviceId() async -> Result<String, RepositoryError> {
        let deviceId = await UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        _ = await storeDeviceId(value: deviceId)
        return .success(deviceId)
    }

    public func storeDeviceId(value: String) async -> Result<Void, RepositoryError> {
        .success(UserDefaults.standard.set(value, forKey: Keys.deviceId.rawValue))
    }

    public func fetchAuthToken() async -> Result<String?, RepositoryError> {
        do {
            return .success(try TokenStore.shared.value(for: .access))
        } catch {
            return .failure(.localStorageReadError)
        }
    }

    public func storeAuthToken(value: String?) async -> Result<Void, RepositoryError> {
        do {
            try TokenStore.shared.set(value, for: .access)
            return .success(())
        } catch {
            return .failure(.localStorageWriteError)
        }
    }

    public func fetchRefreshToken() async -> Result<String?, RepositoryError> {
        do {
            return .success(try TokenStore.shared.value(for: .refresh))
        } catch {
            return .failure(.localStorageReadError)
        }
    }

    public func storeRefreshToken(value: String?) async -> Result<Void, RepositoryError> {
        do {
            try TokenStore.shared.set(value, for: .refresh)
            return .success(())
        } catch {
            return .failure(.localStorageWriteError)
        }
    }

    public func clearTokens() async -> Result<Void, RepositoryError> {
        do {
            try TokenStore.shared.clear()
            return .success(())
        } catch {
            return .failure(.localStorageWriteError)
        }
    }

    public func storePushToken(for deviceId: String, token: String) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersPushCreate.Input.Headers(xDeviceID: deviceId)
        let body = Operations.UsersPushCreate.Input.Body
            .json(Components.Schemas.UserPush(firebaseToken: token, pushNews: true, pushCollective: true, pushOfficial: true))

        let response = try await client.api.usersPushCreate(headers: headers, body: body)

        switch response {
        case .ok:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchIsOnboardingFinished() async -> Result<Bool, RepositoryError> {
        .success(UserDefaults.standard.bool(forKey: Keys.isOnboardingFinished.rawValue))
    }

    public func storeIsOnboardingFinished(value: Bool) async -> Result<Void, RepositoryError> {
        .success(UserDefaults.standard.set(value, forKey: Keys.isOnboardingFinished.rawValue))
    }

    public func fetchAreaName() async -> Result<String?, RepositoryError> {
        .success(UserDefaults.standard.string(forKey: Keys.areaName.rawValue))
    }

    public func storeAreaName(value: String?) async -> Result<Void, RepositoryError> {
        .success(UserDefaults.standard.set(value, forKey: Keys.areaName.rawValue))
    }

    public func fetchAreaRadius() async -> Result<Int?, RepositoryError> {
        .success(UserDefaults.standard.integer(forKey: Keys.areaRadius.rawValue))
    }

    public func storeAreaRadius(value: Int?) async -> Result<Void, RepositoryError> {
        .success(UserDefaults.standard.set(value, forKey: Keys.areaRadius.rawValue))
    }

    public func fetchAreaLatitude() async -> Result<Double?, RepositoryError> {
        .success(UserDefaults.standard.double(forKey: Keys.areaLatitude.rawValue))
    }

    public func storeAreaLatitude(value: Double?) async -> Result<Void, RepositoryError> {
        .success(UserDefaults.standard.set(value, forKey: Keys.areaLatitude.rawValue))
    }

    public func fetchAreaLongitude() async -> Result<Double?, RepositoryError> {
        .success(UserDefaults.standard.double(forKey: Keys.areaLongitude.rawValue))
    }

    public func storeAreaLongitude(value: Double?) async -> Result<Void, RepositoryError> {
        .success(UserDefaults.standard.set(value, forKey: Keys.areaLongitude.rawValue))
    }

    public func deleteAccount() async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let response = try await client.api.usersDeleteUser()

        switch response {
        case .noContent:
            return await clearTokens()
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func createUserAccount(
        for deviceId: String,
        email: String,
        password: String,
        prename: String,
        lastname: String,
        displayName: String
    ) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersCreate.Input.Headers(xDeviceID: deviceId)
        let json = Operations.UsersCreate.Input.Body.JsonPayload(
            username: displayName,
            firstName: prename,
            lastName: lastname,
            email: email,
            password: password,
            displayName: displayName
        )
        let body = Operations.UsersCreate.Input.Body.json(json)

        let response = try await client.api
            .usersCreate(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func loginUserAccount(for deviceId: String, email: String, password: String) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.TokenCreate.Input.Headers()
        let json = Operations.TokenCreate.Input.Body.JsonPayload(username: email, password: password)
        let body = Operations.TokenCreate.Input.Body.json(json)

        let response = try await client.api
            .tokenCreate(headers: headers, body: body)

        switch response {
        case let .ok(response):
            let token = try response.body.json.access
            let refresh = try response.body.json.refresh
            do {
                try TokenStore.shared.setSession(accessToken: token, refreshToken: refresh)
                return .success(())
            } catch {
                return .failure(.localStorageWriteError)
            }
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func getResetLinkForAccount(for deviceId: String, email: String) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let json = Operations.UsersRequestPasswordReset.Input.Body.JsonPayload(email: email)
        let body = Operations.UsersRequestPasswordReset.Input.Body.json(json)

        let response = try await client.api
            .usersRequestPasswordReset(body: body)

        switch response {
        case .noContent:
            return .success(())
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func renewPasswordForAccount(password: String) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let json = Operations.UsersResetPasswordWithToken.Input.Body.JsonPayload(newPassword: password)
        let body = Operations.UsersResetPasswordWithToken.Input.Body.json(json)

        let response = try await client.api
            .usersResetPasswordWithToken(body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .unauthorized:
            return .failure(.unauthorized)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func getUserProfile() async throws -> Result<Domain.UserProfile, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let response = try await client.api.usersGetUserDetails()

        switch response {
        case let .ok(okContent):
            let profile = try okContent.body.json.toUserProfile()
            return .success(profile)
        case .unauthorized:
            return .failure(.unauthorized)
        case .notFound:
            return .failure(.notFound)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func storeUserProfile(userProfile: UserProfile) async throws -> Result<Void, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let response = try await client.api
            .usersUpdateUser(body: Operations.UsersUpdateUser.Input.Body.json(
                .init(
                    username: userProfile.displayName,
                    firstName: userProfile.firstName,
                    lastName: userProfile.lastName,
                    email: userProfile.email,
                    homepage: userProfile.homepage,
                    area: userProfile.area?.id,
                    displayName: userProfile.displayName,
                    description: userProfile.description
                )
            ))

        switch response {
        case .noContent:
            return .success(())
        case .unauthorized:
            return .failure(.unauthorized)
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func upload(image: Data, filename: String, from source: String) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let multipartBody: MultipartBody<Operations.UsersUploadPicture.Input.Body.MultipartFormPayload> = [
            .picture(.init(payload: .init(body: HTTPBody(image)), filename: filename)),
            .imageSource(.init(payload: .init(body: HTTPBody(source.isEmpty ? "unbekannt" : source))))
        ]
        let body = Operations.UsersUploadPicture.Input.Body.multipartForm(multipartBody)

        let response = try await client.api
            .usersUploadPicture(body: body)

        switch response {
        case .created:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case .notFound:
            return .failure(.notFound)
        case .internalServerError:
            return .failure(.serverError)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }
}
