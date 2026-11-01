//
//  ParticipateView.swift
//  Participate
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI

@MainActor
public struct ParticipateView: View {
    @StateObject var viewModel: ParticipateViewModel

    public init(viewModel: ParticipateViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public init() {
        _viewModel = StateObject(wrappedValue: ParticipateViewModel())
    }

    public var body: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .success:
            MenuView(
                menuItems: viewModel.menuItems,
                isLoggedIn: viewModel.isLoggedIn,
                execute: viewModel.executeIntent
            )
            .background(
                Colors.Background.default.swiftUIColor
            )
        }
    }
}

private struct MenuView: View {
    @AppStorage(L10n.Storage.App.darkMode) private var isDarkMode: Bool = false

    private let menuItems: [(Image, String, ParticipateIntent)]
    private let isLoggedIn: Bool
    private let execute: (ParticipateIntent) -> Void

    @State private var presentDeleteAlert: Bool = false

    init(
        menuItems: [(Image, String, ParticipateIntent)],
        isLoggedIn: Bool,
        execute: @escaping (ParticipateIntent) -> Void
    ) {
        self.menuItems = menuItems
        self.isLoggedIn = isLoggedIn
        self.execute = execute
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: .verticalDefault) {
                ForEach(menuItems.indices, id: \.self) { index in
                    let (icon, title, intent) = menuItems[index]

                    if index == menuItems.count - 1 {
                        HStack(spacing: 0) {
                            MenuItem(image: icon, title: title, onClick: { execute(intent) })
                            Toggle(isOn: $isDarkMode, label: {})
                                .frame(width: 80)
                        }
                    } else {
                        MenuItem(image: icon, title: title, onClick: { execute(intent) })
                    }

                    Divider()
                }
            }

            Spacer()

            if isLoggedIn {
                SecondaryButton(text: L10n.News.Molo.Button.logout, onClick: { execute(.onClickLogout) })
                    .padding(.bottom, .verticalDefault)
                TertiaryButton(text: L10n.News.Molo.Button.deleteAccount, onClick: { presentDeleteAlert = true })
            } else {
                PrimaryButton(text: L10n.News.Molo.Button.login, onClick: { execute(.onClickLogin) })
            }

            Spacer()
        }
        .alert(L10n.News.Molo.Account.Delete.Alert.title, isPresented: $presentDeleteAlert) {
            Button(L10n.News.Molo.Account.Delete.Alert.ok, role: .destructive) {
                execute(.onClickDeleteAccount)
            }
            Button(L10n.News.Molo.Account.Delete.Alert.cancel, role: .cancel) {}
        } message: {
            Text(L10n.News.Molo.Account.Delete.Alert.message)
        }
        .padding(.top, .verticalLarge)
        .padding(.horizontal, .horizontalDefault)
    }
}

private struct MenuViewPreview: View {
    var body: some View {
        ZStack {
            Colors.Background.default.swiftUIColor
            MenuView(
                menuItems: [
                    (Assets.Icons.Participate.sources.swiftUIImage, L10n.News.Molo.Menu.sources, .onClickSources),
                    (Assets.Icons.Participate.feedback.swiftUIImage, L10n.News.Molo.Menu.feedback, .onClickFeedback),
                    (Assets.Icons.Participate.info.swiftUIImage, L10n.News.Molo.Menu.info, .onClickInfo),
                    (Assets.Icons.Participate.privacy.swiftUIImage, L10n.News.Molo.Menu.privacy, .onClickPrivacy),
                    (Assets.Icons.Participate.imprint.swiftUIImage, L10n.News.Molo.Menu.imprint, .onClickImprint),
                    (Assets.Icons.Participate.preferences.swiftUIImage, L10n.News.Molo.Menu.darkMode, .onClickImprint)
                ],
                isLoggedIn: false,
                execute: { _ in }
            )
        }
    }
}

#Preview("light") {
    MenuViewPreview()
        .colorScheme(.light)
}

#Preview("dark") {
    MenuViewPreview()
        .colorScheme(.dark)
}
