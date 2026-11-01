//
//  ParticipateViewModel.swift
//  Participate
//

import Assets
import Combine
import Domain
import FactoryKit
import Routing
import Strings
import SwiftUI

@MainActor
public final class ParticipateViewModel: ObservableObject {
    @Published private(set) var state: ParticipateState = .idle
    @Published private(set) var isLoggedIn: Bool = false

    @Injected(\.coordinator) private var coordinator: Coordinator?
    @Injected(\.accountRepository) private var accountRepository: AccountRepositoryType?

    @Injected(\.userProfile) private var userProfile: UserProfile?

    private var cancellables = Set<AnyCancellable>()

    @Published var menuItems: [(icon: Image, title: String, onClick: ParticipateIntent)] =
        [
            (Assets.Icons.Participate.sources.swiftUIImage, L10n.News.Molo.Menu.sources, .onClickSources),
            (Assets.Icons.Participate.feedback.swiftUIImage, L10n.News.Molo.Menu.feedback, .onClickFeedback),
            (Assets.Icons.Participate.info.swiftUIImage, L10n.News.Molo.Menu.info, .onClickInfo),
            (Assets.Icons.Participate.privacy.swiftUIImage, L10n.News.Molo.Menu.privacy, .onClickPrivacy),
            (Assets.Icons.Participate.imprint.swiftUIImage, L10n.News.Molo.Menu.imprint, .onClickImprint),
            (Assets.Icons.Participate.posts.swiftUIImage, L10n.News.Molo.Menu.terms, .onClickTerms),
            (Assets.Icons.Participate.preferences.swiftUIImage, L10n.News.Molo.Menu.darkMode, .onClickDarkMode)
        ]

    public init() {
        state = .success
        observeLoggedInState()
    }

    func executeIntent(_ intent: ParticipateIntent) {
        switch intent {
        case .onClickSources:
            coordinator?.showSheet(.sourcesSelection)
        case .onClickFeedback:
            coordinator?.showSheet(.feedbackInAppEmail)
        case .onClickInfo:
            coordinator?.showSheet(.webContent(urlString: L10n.News.Molo.Url.info))
        case .onClickPrivacy:
            coordinator?.showSheet(.webContent(urlString: L10n.News.Molo.Url.privacy))
        case .onClickImprint:
            coordinator?.showSheet(.webContent(urlString: L10n.News.Molo.Url.imprint))
        case .onClickTerms:
            coordinator?.showSheet(.webContent(urlString: L10n.News.Molo.Url.terms))
        case .onClickDarkMode:
            break
        case .onClickLogin:
            coordinator?.showSheet(.login)
        case .onClickLogout:
            logout()
        case .onClickDeleteAccount:
            deleteAccount()
        }
    }

    private func observeLoggedInState() {
        ObserveIsLoggedInUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(isLoggedIn):
                    self?.isLoggedIn = isLoggedIn
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func logout() {
        LogoutUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
    }

    private func deleteAccount() {
        DeleteAccountUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.logout()
            }
            .store(in: &cancellables)
    }
}
