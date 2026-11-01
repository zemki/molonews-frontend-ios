//
//  TabbarView.swift
//  Navigation
//

import Account
import Assets
import Atoms
import DataLayer
import Dimensions
import Domain
import Events
import Explore
import FactoryKit
import Feed
import Modifiers
import Onboarding
import Participate
import Routing
import Search
import Strings
import SwiftUI
import Watchlist

@MainActor
struct TabbarView: View {
    @AppStorage(L10n.Storage.App.darkMode) private var isDarkMode: Bool?
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var coordinator: Coordinator = Container.shared.coordinator.callAsFunction()!
    @StateObject private var viewModel = TabbarViewModel()
    @StateObject private var pushManager = PushNotification()

    @State private var tabSelection: TabIndex = .feed
    @State private var presentOnboarding: Bool = false

    private let fabActions: [(title: String, onClick: TabbarIntent)] =
        [
            (L10n.News.Molo.Posting.article, .onClickPostArticle),
            (L10n.News.Molo.Posting.event, .onClickPostEvent)
        ]

    private let onboardingViewModel = OnboardingViewModel()

    private var topNavigation: DefaultTopNavigation {
        DefaultTopNavigation(
            locationAndRadiusString: viewModel.locationTitle,
            userImageURL: viewModel.userProfileImage,
            selectLocationAction: {
                viewModel.executeIntent(.onClickLocation)
            },
            selectTopicsAction: {
                viewModel.executeIntent(.onClickTopics(tabSelection: tabSelection))
            },
            openProfileAction: {
                viewModel.executeIntent(.onClickProfile)
            }
        )
    }

    private var eventsTab: some View {
        NavigationStack(path: $coordinator.eventsStack) {
            EventsView()
                .fabPosting {
                    viewModel.executeIntent(.onClickFab)
                }
                .navigationDestination(for: Coordinator.StackRouteEvent.self) { _ in }
                .toolbar {
                    topNavigation
                }
        }
        .tabItem {
            Assets.Icons.Tabbar.events.swiftUIImage
            Text(L10n.News.Molo.Tabbar.events)
        }
        .tag(TabIndex.events)
    }

    private var feedTab: some View {
        NavigationStack(path: $coordinator.feedStack) {
            FeedView()
                .fabPosting {
                    viewModel.executeIntent(.onClickFab)
                }
                .navigationDestination(for: Coordinator.StackRouteFeed.self) { _ in }
                .toolbar {
                    topNavigation
                }
        }
        .tabItem {
            Assets.Icons.Tabbar.feed.swiftUIImage
            Text(L10n.News.Molo.Tabbar.feed)
        }
        .tag(TabIndex.feed)
    }

    private var watchlistTab: some View {
        NavigationStack(path: $coordinator.watchlistStack) {
            WatchlistView()
                .fabPosting {
                    viewModel.executeIntent(.onClickFab)
                }
                .navigationDestination(for: Coordinator.StackRouteWatchlist.self) { _ in }
                .toolbar {
                    topNavigation
                }
        }
        .tabItem {
            Assets.Icons.Tabbar.watchlist.swiftUIImage
            Text(L10n.News.Molo.Tabbar.watchlist)
        }
        .tag(TabIndex.watchlist)
    }

    private var participateTab: some View {
        NavigationStack(path: $coordinator.participateStack) {
            ParticipateView()
                .fabPosting {
                    viewModel.executeIntent(.onClickFab)
                }
                .navigationDestination(for: Coordinator.StackRouteParticipate.self) { _ in }
                .toolbar {
                    topNavigation
                }
        }
        .tabItem {
            Assets.Icons.Tabbar.participate.swiftUIImage
            Text(L10n.News.Molo.Tabbar.participate)
        }
        .tag(TabIndex.participate)
    }

    private var searchTab: some View {
        NavigationStack(path: $coordinator.searchStack) {
            SearchView()
                .navigationDestination(for: Coordinator.StackRouteSearch.self) { _ in }
        }
        .tabItem {
            Assets.Icons.Tabbar.explore.swiftUIImage
            Text(L10n.News.Molo.Tabbar.search)
        }
        .tag(TabIndex.search)
    }

    @available(iOS 26.0, *)
    private var tabView26: some View {
        TabView(selection: $tabSelection) {
            Tab(value: TabIndex.feed) {
                NavigationStack(path: $coordinator.feedStack) {
                    FeedView()
                        .fabPosting {
                            viewModel.executeIntent(.onClickFab)
                        }
                        .navigationDestination(for: Coordinator.StackRouteFeed.self) { _ in }
                        .toolbar {
                            topNavigation
                        }
                }
            } label: {
                Label {
                    Text(L10n.News.Molo.Tabbar.feed)
                } icon: {
                    Assets.Icons.Tabbar.feed.swiftUIImage
                }
            }

            Tab(value: TabIndex.events) {
                NavigationStack(path: $coordinator.eventsStack) {
                    EventsView()
                        .fabPosting {
                            viewModel.executeIntent(.onClickFab)
                        }
                        .navigationDestination(for: Coordinator.StackRouteEvent.self) { _ in }
                        .toolbar {
                            topNavigation
                        }
                }
            } label: {
                Label {
                    Text(L10n.News.Molo.Tabbar.events)
                } icon: {
                    Assets.Icons.Tabbar.events.swiftUIImage
                }
            }

            Tab(value: TabIndex.watchlist) {
                NavigationStack(path: $coordinator.watchlistStack) {
                    WatchlistView()
                        .fabPosting {
                            viewModel.executeIntent(.onClickFab)
                        }
                        .navigationDestination(for: Coordinator.StackRouteWatchlist.self) { _ in }
                        .toolbar {
                            topNavigation
                        }
                }
            } label: {
                Label {
                    Text(L10n.News.Molo.Tabbar.watchlist)
                } icon: {
                    Assets.Icons.Tabbar.watchlist.swiftUIImage
                }
            }

            Tab(value: TabIndex.participate) {
                NavigationStack(path: $coordinator.participateStack) {
                    ParticipateView()
                        .fabPosting {
                            viewModel.executeIntent(.onClickFab)
                        }
                        .navigationDestination(for: Coordinator.StackRouteSearch.self) { _ in }
                        .toolbar {
                            topNavigation
                        }
                }
            } label: {
                Label {
                    Text(L10n.News.Molo.Tabbar.participate)
                } icon: {
                    Assets.Icons.Tabbar.participate.swiftUIImage
                }
            }

            Tab(value: TabIndex.search, role: .search) {
                NavigationStack(path: $coordinator.searchStack) {
                    SearchView()
                        .navigationDestination(for: Coordinator.StackRouteSearch.self) { _ in }
                }
            } label: {
                Label {
                    Text(L10n.News.Molo.Tabbar.search)
                } icon: {
                    Assets.Icons.Tabbar.explore.swiftUIImage
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(Colors.Icons.button.swiftUIColor)
    }

    @ViewBuilder
    private var tabView: some View {
        if #available(iOS 26.0, *) {
            tabView26
        } else {
            TabView(selection: $tabSelection) {
                feedTab
                eventsTab
                watchlistTab
                participateTab
                searchTab
            }
        }
    }

    var body: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            LoadingView()
        case .onboarding:
            OnboardingView(viewModel: onboardingViewModel)
        case .success:
            ZStack {
                tabView
                    .fullScreenCover(isPresented: $viewModel.presentPasswordReset) {
                        let passwordRenewalViewModel = PasswordRenewalViewModel()
                        PasswordRenewalView(viewModel: passwordRenewalViewModel, isPresented: $viewModel.presentPasswordReset)
                    }
                    .onOpenURL(perform: { url in
                        if url.absoluteString.contains(L10n.Url.App.Delegate.Password.reset) {
                            if let resetToken = URLComponents(string: url.absoluteString)?
                                .queryItems?.first(where: { item in
                                    item.name == L10n.Url.App.Delegate.Reset.token
                                })?.value {
                                viewModel.executeIntent(.onPasswordResetLinkOpened(token: resetToken))
                            }
                        } else if url.absoluteString.contains(L10n.Url.App.Delegate.activate) ||
                            url.absoluteString.contains(L10n.Url.App.Delegate.activated) {
                            if let bearerToken = URLComponents(string: url.absoluteString)?
                                .queryItems?.first(where: { item in
                                    item.name == L10n.Url.App.Delegate.Bearer.token
                                })?.value {
                                viewModel.executeIntent(.onRegistrationLogin(token: bearerToken))
                            }
                        }
                    })
                    .onChange(of: coordinator.presentedSheets.last) { oldValue, newValue in
                        if oldValue != nil, newValue == nil {
                            coordinator.dismissSheetCallback?()
                            coordinator.dismissSheetCallback = nil
                        }
                    }
                    .confirmationDialog(
                        L10n.News.Molo.Posting.title,
                        isPresented: $viewModel.showPostingActionSheet,
                        titleVisibility: .automatic
                    ) {
                        ForEach(fabActions, id: \.0) { actionItem in
                            let (title, action) = actionItem
                            Button(title) {
                                viewModel.executeIntent(action)
                            }
                        }
                    }

                MultiSheetRepresentable(presentedSheets: $coordinator.presentedSheets)
                    .frame(width: 0, height: 0)
            }
            .preferredColorScheme((isDarkMode ?? (colorScheme == .dark)) ? .dark : .light)
            .onAppear {
                if isDarkMode == nil {
                    isDarkMode = (colorScheme == .dark)
                }
            }
            .onChange(of: colorScheme) { _, newScheme in
                isDarkMode = (newScheme == .dark)
            }
            .task {
                await pushManager.request()
            }
        case let .error(error):
            fatalError("[ERROR] in TabbarViewModel state: \(error)")
        }
    }
}

#Preview("light") {
    TabbarView()
        .colorScheme(.light)
}

#Preview("dark") {
    TabbarView()
        .colorScheme(.dark)
}
