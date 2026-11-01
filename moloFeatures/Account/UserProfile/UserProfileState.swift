//
//  UserProfileState.swift
//  Account
//

import Domain
import Foundation

enum UserProfileState {
    case idle
    case loading
    case success(userProfile: UserProfile)
}
