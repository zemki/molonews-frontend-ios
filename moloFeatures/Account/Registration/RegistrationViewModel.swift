//
//  RegistrationViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class RegistrationViewModel: ObservableObject {
    @Published private(set) var state: RegistrationState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    public init() {}

    func executeIntent(_ intent: RegistrationIntent) {
        switch intent {
        case .willAppear:
            state = .success
        case .onClickClose:
            coordinator?.back(on: nil)
        case let .onClickRegister(email, password, prename, lastname, displayName):
            registerUser(email: email, password: password, prename: prename, lastname: lastname, displayName: displayName)
        }
    }

    private func registerUser(email: String, password: String, prename: String, lastname: String, displayName: String) {
        RegisterUserUseCase(prename: prename, lastname: lastname, email: email, password: password, displayName: displayName)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    self?.coordinator?.showSheet(.confirmRegsitration)
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
