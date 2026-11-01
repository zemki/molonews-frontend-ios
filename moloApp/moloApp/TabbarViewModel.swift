//
//  TabbarViewModel.swift
//  moloApp
//

import Combine
import Domain
import FactoryKit
import Routing
import Strings
import SwiftUI

@MainActor
public final class TabbarViewModel: ObservableObject {
    @Published private(set) var state: TabbarState = .idle

    @Published var locationTitle: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var userProfileImage: String = ""

    @Published var showPostingActionSheet: Bool = false
    @Published var presentPasswordReset: Bool = false

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var userProfile: UserProfile?

    private var cancellables = Set<AnyCancellable>()

    public init() {
        handleUseCaseErrorNotification()
        handleArticleReportedNotification()
        handleCalendarNoAccessNotification()

        observeLoginAndOnboarding()
        observeStoredLocation()
    }

    func executeIntent(_ intent: TabbarIntent) {
        switch intent {
        case .onClickLocation:
            coordinator?.showSheet(.locationSelection)
        case let .onClickTopics(tabSelection):
            coordinator?.showSheet(.topicsSelection(topicsTab: tabSelection == .events ? 1 : 0))
        case .onClickProfile:
            guard let profile = userProfile else {
                coordinator?.showSheet(.login)
                return
            }
            coordinator?.dismissSheetCallback = { [weak self] in
                self?.loadUserProfile()
            }
            coordinator?.showSheet(.organizationDetail(id: profile.organizationId, fromArticles: true), stacked: true)
        case .onClickPostArticle:
            openArticlePosting()
        case .onClickPostEvent:
            openEventPosting()
        case .onClickFab:
            if case .success = state {
                if isLoggedIn {
                    showPostingActionSheet = true
                } else {
                    coordinator?.showSheet(.login)
                }
            }
        case let .onPasswordResetLinkOpened(token):
            do {
                try TokenStore.shared.set(token, for: .reset)
                presentPasswordReset = true
            } catch {
                NotificationCenter.default.post(name: .useCaseErrorNotification, object: UseCaseError.localStorageError)
            }
        case let .onRegistrationLogin(token):
            do {
                // An activation link starts a new session without a refresh token.
                try TokenStore.shared.setSession(accessToken: token)
                ToastNotification.shared.show(L10n.News.Molo.Notification.Login.success)
            } catch {
                NotificationCenter.default.post(name: .useCaseErrorNotification, object: UseCaseError.localStorageError)
            }
        }
    }

    private func openArticlePosting() {
        if case .success = state {
            coordinator?.showSheet(.postArticle(id: nil))
        }
    }

    private func openEventPosting() {
        if case .success = state {
            coordinator?.showSheet(.postEvent(id: nil))
        }
    }

    private func observeLoginAndOnboarding() {
        Publishers.CombineLatest(
            ObserveIsLoggedInUseCase().execute(),
            ObserveOnboardingShownUseCase().execute()
        )
        .eraseToAnyPublisher()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] useCaseStateLogin, useCaseStateOnboarding in
            switch (useCaseStateLogin, useCaseStateOnboarding) {
            case (_, .isLoading),
                 (.isLoading, _):
                self?.state = .loading
            case let (.success(loggedIn), .success(onboardingShown)):
                if !onboardingShown {
                    self?.state = .onboarding
                } else {
                    self?.isLoggedIn = loggedIn

                    if loggedIn, Container.shared.userProfile() == nil {
                        self?.loadUserProfile()
                    } else {
                        self?.userLoggedOut()
                    }
                    self?.state = .success
                }
            case let (.error(useCaseError), _),
                 let (_, .error(useCaseError)):
                NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
            }
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
                    break
                case let .success(profile):
                    Container.shared.userProfile.register {
                        profile
                    }
                    self?.userProfile = profile
                    self?.userProfileImage = profile.imageUrl
                case .error:
                    break
                @unknown default:
                    ToastNotification.shared.show(L10n.News.Molo.Notification.Location.notFound)
                }
            }
            .store(in: &cancellables)
    }

    private func userLoggedOut() {
        Container.shared.userProfile.register {
            nil
        }
        userProfile = nil
        userProfileImage = ""
    }

    private func observeStoredLocation() {
        ObserveSelectedLocationAndRadiusUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(location):
                    self?.locationTitle = location
                case let .error(error):
                    print("[ERROR] in TabbarViewModel observeStoredLocation", error)
                    ToastNotification.shared.show(L10n.News.Molo.Notification.Location.notFound)
                @unknown default:
                    ToastNotification.shared.show(L10n.News.Molo.Notification.Location.notFound)
                }
            }
            .store(in: &cancellables)
    }

    private func handleUseCaseErrorNotification() {
        NotificationCenter.default
            .publisher(for: .useCaseErrorNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                ToastNotification.shared.show(L10n.News.Molo.Notification.General.error)
            }
            .store(in: &cancellables)
    }

    private func handleArticleReportedNotification() {
        NotificationCenter.default
            .publisher(for: .articleReportedNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                ToastNotification.shared.show(L10n.News.Molo.Notification.Article.reported)
            }
            .store(in: &cancellables)
    }

    private func handleCalendarNoAccessNotification() {
        NotificationCenter.default
            .publisher(for: .eventStorageNoAccessNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                ToastNotification.shared.show(L10n.News.Molo.Notification.Event.noAccess)
            }
            .store(in: &cancellables)
    }
}
