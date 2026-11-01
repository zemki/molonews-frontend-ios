//
//  UserProfileIntent.swift
//  Account
//

import Domain
import Foundation

enum UserProfileIntent {
    case willAppear
    case onClickBack
    case onClickSave(userProfile: UserProfile, imageData: Data?, filename: String?, source: String?)
}
