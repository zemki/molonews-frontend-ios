//
//  OrganizationDetailState.swift
//  OrganizationDetail
//

import Domain
import Foundation

enum OrganizationDetailState {
    case idle
    case loading
    case success(organization: Organization, isUserAsOrganization: Bool)
}
