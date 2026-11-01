//
//  Factory+Coordinator.swift
//  moloApp
//

import FactoryKit
import Foundation

public extension Container {
    // MARK: - Routing

    var coordinator: Factory<Coordinator?> { promised().singleton }
}
