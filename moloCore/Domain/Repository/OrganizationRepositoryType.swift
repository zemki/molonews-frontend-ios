//
//  OrganizationRepositoryType.swift
//  Domain
//

import Foundation

public protocol OrganizationRepositoryType {
    func fetchOrganizations(for deviceId: String, type: OrganizationType) async throws -> Result<[Organization], RepositoryError>
    func fetchOrganization(for deviceId: String, id: Int) async throws -> Result<Organization, RepositoryError>
    func storeSelectedOrganizations(for deviceId: String, organizationIds: [Int]) async throws -> Result<Void, RepositoryError>
    func addOrganization(for deviceId: String, organizationId: Int) async throws -> Result<Void, RepositoryError>
    func removeOrganization(for deviceId: String, organizationId: Int) async throws -> Result<Void, RepositoryError>
}
