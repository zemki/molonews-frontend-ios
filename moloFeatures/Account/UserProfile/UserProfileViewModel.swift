//
//  UserProfileViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class UserProfileViewModel: ObservableObject {
    @Published private(set) var state: UserProfileState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private let profileStoragePublisher = PassthroughSubject<Void, Never>()
    private let imageStoragePublisher = PassthroughSubject<Void, Never>()

    private var userProfile: UserProfile?

    private let callback: () -> Void

    public init(callback: @escaping () -> Void) {
        self.callback = callback
        observeStoringSuccess()
    }

    func executeIntent(_ intent: UserProfileIntent) {
        switch intent {
        case .willAppear:
            state = .loading
            loadUserProfile()
        case .onClickBack:
            coordinator?.back(on: nil)
        case let .onClickSave(userProfile, imageData, filename, source):
            saveUserProfile(userProfile: userProfile)
            if let imageData, !imageData.isEmpty, let filename, let source {
                uploadImage(data: imageData, filename: filename, source: source)
            } else {
                imageStoragePublisher.send(())
            }
        }
    }

    func observeStoringSuccess() {
        Publishers.CombineLatest(profileStoragePublisher, imageStoragePublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.callback()
                self?.coordinator?.back(on: nil)
            }
            .store(in: &cancellables)
    }

    private func loadUserProfile() {
        LoadUserProfileUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(userProfile):
                    self?.state = .success(userProfile: userProfile)
                    Container.shared.userProfile.register {
                        userProfile
                    }
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.coordinator?.back(on: nil)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func saveUserProfile(userProfile: UserProfile) {
        StoreUserProfileUseCase(userProfile: userProfile)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    self?.profileStoragePublisher.send(())
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func uploadImage(data: Data, filename: String, source: String) {
        UploadUserImageUseCase(file: data, filename: filename, source: source)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    self?.imageStoragePublisher.send(())
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
