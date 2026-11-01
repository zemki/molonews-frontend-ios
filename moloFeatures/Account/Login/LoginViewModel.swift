//
//  LoginViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    public init() {}

    func executeIntent(_ intent: LoginIntent) {
        switch intent {
        case .willAppear:
            state = .success
        case .onClickClose:
            coordinator?.back(on: nil)
        case let .onClickLogin(email, password):
            loginUser(email: email, password: password)
        case .onClickRegistration:
            coordinator?.showSheet(.register)
        case .onClickPasswordLost:
            coordinator?.showSheet(.passwordLost, stacked: true)
        }
    }

    private func loginUser(email: String, password: String) {
        LoginUseCase(email: email, password: password)
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
