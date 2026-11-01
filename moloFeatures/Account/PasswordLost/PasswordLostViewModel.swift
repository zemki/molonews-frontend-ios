//
//  PasswordLostViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class PasswordLostViewModel: ObservableObject {
    @Published private(set) var state: PasswordLostState = .idle
    
    @Injected(\.coordinator) private var coordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    func executeIntent(_ intent: PasswordLostIntent) {
        switch intent {
        case .willAppear:
            state = .success
        case .onClickClose:
            coordinator?.back(on: nil)
        case let .onClickReset(email):
            resetPassword(email: email)
        }
    }
    
    private func resetPassword(email: String) {
        GetPasswordResetLinkUseCase(email: email)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    self?.coordinator?.back(on: nil)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.state = .success
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
