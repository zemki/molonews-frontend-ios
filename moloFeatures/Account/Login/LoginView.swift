//
//  LoginView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI
import Templates

public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case .success:
                Login(execute: viewModel.executeIntent(_:))
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .padding(0)
    }
}

private struct Login: View {
    private let execute: (LoginIntent) -> Void

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: Bool = false

    init(execute: @escaping (LoginIntent) -> Void) {
        self.execute = execute
    }

    private var inputStack: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            DefaultTextField(label: L10n.News.Molo.Registration.Input.email, textContentType: .username, contentBinding: $email, errorBinding: $error)
            DefaultTextField(
                label: L10n.News.Molo.Registration.Input.password,
                textContentType: .password,
                contentBinding: $password,
                errorBinding: $error
            )
        }
    }

    private var titleText: some View {
        Text(L10n.News.Molo.Login.Text.title)
            .font(.moloTitleLarge)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var descriptionText: some View {
        Text(L10n.News.Molo.Login.Text.description)
            .font(.moloContentDefault)
            .multilineTextAlignment(.center)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var submitButton: some View {
        PrimaryButton(
            text: L10n.News.Molo.Login.Button.submit,
            onClick: {
                if email.isEmpty || password.isEmpty {
                    error = true
                } else {
                    execute(.onClickLogin(email: email, password: password))
                }
            }
        )
    }

    private var registrationButton: some View {
        SecondaryButton(
            text: L10n.News.Molo.Login.Button.register,
            onClick: { execute(.onClickRegistration) }
        )
    }

    private var passwordLostButton: some View {
        TertiaryButton(
            text: L10n.News.Molo.Login.Button.passwordLost,
            onClick: { execute(.onClickPasswordLost) }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            titleText
                .padding(.bottom, .verticalLarge)
            descriptionText

            inputStack
                .padding(.vertical, .verticalXLarge)

            submitButton
                .frame(height: .buttonHeight)
                .padding(.bottom, .verticalDefault)

            registrationButton
                .frame(height: .buttonHeight)
                .padding(.bottom, .verticalDefault)

            Spacer()

            passwordLostButton
                .frame(height: .buttonHeight)
                .padding(.bottom, .verticalXLarge)
        }
        .padding(.top, .verticalXLarge * 2)
        .padding(.horizontal, .horizontalDefault)
        .background(Colors.Background.inputForm.swiftUIColor)
        .toolbar {
            DetailTopNavigation(
                backAction: {
                    execute(.onClickClose)
                }
            )
        }
        .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview("dark") {
    Login { _ in }
        .preferredColorScheme(.dark)
}

#Preview("light") {
    Login { _ in }
        .preferredColorScheme(.light)
}
