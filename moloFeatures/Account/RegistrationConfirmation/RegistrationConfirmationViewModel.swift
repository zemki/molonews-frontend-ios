//
//  RegistrationConfirmationViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class RegistrationConfirmationViewModel: ObservableObject {
    @Published private(set) var state: RegistrationConfirmationState = .idle
    
    @Injected(\.coordinator) private var coordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    func executeIntent(_ intent: RegistrationConfirmationIntent) {
        switch intent {
        case .willAppear:
            state = .success
        case .onClickClose:
            coordinator?.back(on: nil)
        }
    }
}
