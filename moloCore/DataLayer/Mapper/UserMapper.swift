//
//  UserMapper.swift
//  DataLayer
//

import Domain
import Foundation

extension Components.Schemas.UserGet {
    func toUserProfile() -> Domain.UserProfile {
        UserProfile(
            organizationId: organizationId ?? 0,
            username: username,
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            description: description ?? "",
            imageUrl: picture ?? "",
            email: email ?? "",
            displayName: displayName ?? "",
            area: area?.toArea(),
            homepage: homepage ?? ""
        )
    }
}
