//
//  OrganizationMapper.swift
//  DataLayer
//

import Domain
import Foundation

extension Components.Schemas.Organization {
    func toOrganization() -> Domain.Organization {
        Domain.Organization(
            id: id ?? 0,
            name: name,
            description: description,
            type: OrganizationType(rawValue: self._type.rawValue) ?? .unknown,
            imageUrlString: image.addingPercentEncoding(withAllowedCharacters: .urlFullCharacterSet) ?? "",
            isSelected: isSelected ?? false
        )
    }
}
