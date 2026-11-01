//
//  AccountRepositoryType.swift
//  Domain
//

import Combine
import Foundation

public enum Keys: String {
    case deviceId = "de.uni-bremen.molonews.device_Id"

    case isOnboardingFinished = "de.uni-bremen.molonews.onboarding"

    case location = "de.uni-bremen.molonews.location"

    case areaName = "de.uni-bremen.molonews.area"
    case areaRadius = "de.uni-bremen.molonews.area.radius"
    case areaLatitude = "de.uni-bremen.molonews.area.latitude"
    case areaLongitude = "de.uni-bremen.molonews.area.longitude"

    case locationUpdated = "de.uni-bremen.molonews.location.updated"
}

public protocol AccountRepositoryType {
    func fetchDeviceId() async -> Result<String, RepositoryError>
    func storeDeviceId(value: String) async -> Result<Void, RepositoryError>

    func fetchAuthToken() async -> Result<String?, RepositoryError>
    func storeAuthToken(value: String?) async -> Result<Void, RepositoryError>

    func fetchRefreshToken() async -> Result<String?, RepositoryError>
    func storeRefreshToken(value: String?) async -> Result<Void, RepositoryError>

    func clearTokens() async -> Result<Void, RepositoryError>

    func storePushToken(for deviceId: String, token: String) async throws -> Result<Void, RepositoryError>

    func fetchIsOnboardingFinished() async -> Result<Bool, RepositoryError>
    func storeIsOnboardingFinished(value: Bool) async -> Result<Void, RepositoryError>

    func fetchAreaName() async -> Result<String?, RepositoryError>
    func storeAreaName(value: String?) async -> Result<Void, RepositoryError>
    func fetchAreaRadius() async -> Result<Int?, RepositoryError>
    func storeAreaRadius(value: Int?) async -> Result<Void, RepositoryError>
    func fetchAreaLatitude() async -> Result<Double?, RepositoryError>
    func storeAreaLatitude(value: Double?) async -> Result<Void, RepositoryError>
    func fetchAreaLongitude() async -> Result<Double?, RepositoryError>
    func storeAreaLongitude(value: Double?) async -> Result<Void, RepositoryError>

    func deleteAccount() async throws -> Result<Void, RepositoryError>

    func createUserAccount(for deviceId: String, email: String, password: String, prename: String, lastname: String,
                           displayName: String) async throws -> Result<Void, RepositoryError>
    func loginUserAccount(for deviceId: String, email: String, password: String) async throws -> Result<Void, RepositoryError>
    func getResetLinkForAccount(for deviceId: String, email: String) async throws -> Result<Void, RepositoryError>
    func renewPasswordForAccount(password: String) async throws -> Result<Void, RepositoryError>

    func getUserProfile() async throws -> Result<Domain.UserProfile, Domain.RepositoryError>
    func storeUserProfile(userProfile: UserProfile) async throws -> Result<Void, Domain.RepositoryError>
    func upload(image: Data, filename: String, from source: String) async throws -> Result<Void, Domain.RepositoryError>
}
