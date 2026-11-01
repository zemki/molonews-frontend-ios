//
//  OrganizationRepository.swift
//  DataLayer
//

import Combine
import Domain
import FactoryKit
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public actor OrganizationRepository: OrganizationRepositoryType {
    @Injected(\.apiClient) private var client: MoloClient?

    public init() {}

    public func fetchOrganizations(for deviceId: String, type: OrganizationType) async throws -> Result<[Organization], RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.OrganizationsList.Input.Headers(xDeviceID: deviceId)
        let organizationType = Operations.OrganizationsList.Input.Query._TypePayload(rawValue: type.rawValue)
        let query = Operations.OrganizationsList.Input.Query(_type: organizationType)

        let response = try await client.api
            .organizationsList(query: query, headers: headers)

        switch response {
        case let .ok(content):
            let results = try content.body.json.map { organization in
                organization.toOrganization()
            }

            return .success(results)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func fetchOrganization(for deviceId: String, id: Int) async throws -> Result<Organization, RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.OrganizationsRead.Input.Headers(xDeviceID: deviceId)
        let path = Operations.OrganizationsRead.Input.Path(id: id)

        let response = try await client.api
            .organizationsRead(path: path, headers: headers)

        switch response {
        case let .ok(content):
            let result = try content.body.json.toOrganization()
            return .success(result)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func storeSelectedOrganizations(
        for deviceId: String,
        organizationIds: [Int]
    ) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersOrganizationsCreate.Input.Headers(xDeviceID: deviceId)
        let query = Operations.UsersOrganizationsCreate.Input.Query(
            organizationType: Operations.UsersOrganizationsCreate.Input.Query.OrganizationTypePayload(
                rawValue: OrganizationType.all.rawValue
            )
        )
        let json = Components.Schemas.UserOrganizations(organization: organizationIds)
        let body = Operations.UsersOrganizationsCreate.Input.Body.json(json)

        let response = try await client.api
            .usersOrganizationsCreate(query: query, headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func addOrganization(for deviceId: String, organizationId: Int) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersAddOrganization.Input.Headers(xDeviceID: deviceId)
        let json = Operations.UsersAddOrganization.Input.Body.JsonPayload(organizationId: organizationId)
        let body = Operations.UsersAddOrganization.Input.Body.json(json)

        let response = try await client.api
            .usersAddOrganization(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }

    public func removeOrganization(for deviceId: String, organizationId: Int) async throws -> Result<Void, Domain.RepositoryError> {
        guard let client else {
            return .failure(.diError)
        }

        let headers = Operations.UsersRemoveOrganization.Input.Headers(xDeviceID: deviceId)
        let json = Operations.UsersRemoveOrganization.Input.Body.JsonPayload(organizationId: organizationId)
        let body = Operations.UsersRemoveOrganization.Input.Body.json(json)

        let response = try await client.api
            .usersRemoveOrganization(headers: headers, body: body)

        switch response {
        case .noContent:
            return .success(())
        case .badRequest:
            return .failure(.badRequest)
        case let .undocumented(statusCode: statusCode, _):
            return .failure(.undocumented(statusCode: statusCode))
        }
    }
}
