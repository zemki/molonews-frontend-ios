//
//  RegistrationIntent.swift
//  Account
//

import Foundation

public enum RegistrationIntent {
    case willAppear
    case onClickClose
    case onClickRegister(email: String, password: String, prename: String, lastname: String, displayName: String)
}
