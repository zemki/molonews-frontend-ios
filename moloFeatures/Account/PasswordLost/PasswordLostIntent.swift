//
//  PasswordLostIntent.swift
//  Account
//

import Foundation

public enum PasswordLostIntent {
    case willAppear
    case onClickClose
    case onClickReset(email: String)
}
