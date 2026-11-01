//
//  User.swift
//  Domain
//

import Foundation

struct User {
    public var username: String
    public var prename: String
    public var lastname: String
    public var email: String
    public var password: String
    public var displayName: String
    
    init(
        username: String,
        prename: String,
        lastname: String,
        email: String,
        password: String,
        displayName: String
    ) {
        self.username = username
        self.prename = prename
        self.lastname = lastname
        self.email = email
        self.password = password
        self.displayName = displayName
    }
}
