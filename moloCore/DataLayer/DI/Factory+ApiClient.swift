//
//  Factory+ApiClient.swift
//  DataLayer
//

import FactoryKit
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public extension Container {
    var apiClient: Factory<MoloClient?> { promised().unique }
}
