//
//  PasswordRenewalViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class PasswordRenewalViewModel: ObservableObject {
    @Published private(set) var state: PasswordRenewalState = .success

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    public init() {}

    func executeIntent(_ intent: PasswordRenewalIntent) {
        switch intent {
        case .willAppear:
            state = .success
        case .onClickClose:
            removeResetTokenAndClose()
        case let .onClickSave(password):
            savePassword(password)
        }
    }

    private func savePassword(_ password: String) {

        RenewPasswordUseCase(password: password)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    self?.removeResetTokenAndClose()
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.state = .success
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func removeResetTokenAndClose() {
        do {
            try TokenStore.shared.set(nil, for: .reset)
            state = .done
        } catch {
            NotificationCenter.default.post(name: .useCaseErrorNotification, object: UseCaseError.localStorageError)
            state = .success
        }
    }
}
