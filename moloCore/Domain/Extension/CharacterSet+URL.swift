//
//  CharacterSet+URL.swift
//  Domain
//

import Foundation

public extension CharacterSet {
    static let urlFullCharacterSet = CharacterSet(charactersIn: " \"#<>[\\]^`{|}").inverted
}
