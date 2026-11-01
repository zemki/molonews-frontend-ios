//
//  TabbarState.swift
//  moloApp
//

import Domain
import Foundation

enum TabbarState {
    case idle
    case loading
    case onboarding
    case success
    case error(error: UseCaseError)
}
