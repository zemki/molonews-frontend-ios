//
//  PasswordRenewalIntent.swift
//  Account
//

import Foundation

public enum PasswordRenewalIntent {
    case willAppear
    case onClickClose
    case onClickSave(password: String)
}
