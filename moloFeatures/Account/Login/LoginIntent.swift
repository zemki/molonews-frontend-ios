//
//  LoginIntent.swift
//  Account
//

import Foundation

enum LoginIntent {
    case willAppear
    case onClickClose
    case onClickLogin(email: String, password: String)
    case onClickRegistration
    case onClickPasswordLost
}
