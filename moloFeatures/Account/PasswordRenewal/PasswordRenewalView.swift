//
//  PasswordRenewalView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI
import Templates

@MainActor
public struct PasswordRenewalView: View {
    @Binding private var isPresented: Bool

    @ObservedObject var viewModel: PasswordRenewalViewModel

    public init(viewModel: PasswordRenewalViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _isPresented = isPresented
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case .success:
                PasswordRenewal(execute: viewModel.executeIntent(_:))
            case .done:
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.async {
                            isPresented = false
                        }
                    }
            }
        }
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .navigationBarBackButtonHidden(true)
        .padding(0)
    }
}

private struct PasswordRenewal: View {
    private let execute: (PasswordRenewalIntent) -> Void

    @State private var password: String = ""
    @State private var confirmation: String = ""
    @State private var error: Bool = false

    init(execute: @escaping (PasswordRenewalIntent) -> Void) {
        self.execute = execute
    }

    private var inputStack: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            DefaultTextField(
                label: L10n.News.Molo.PasswordRenewal.Input.password,
                textContentType: .newPassword,
                contentBinding: $password,
                errorBinding: $error
            )
            DefaultTextField(
                label: L10n.News.Molo.PasswordRenewal.Input.passwordConfirmation,
                textContentType: .newPassword,
                contentBinding: $confirmation,
                errorBinding: $error
            )
        }
    }

    private var titleText: some View {
        Text(L10n.News.Molo.PasswordRenewal.Text.title)
            .font(.moloTitleLarge)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var descriptionText: some View {
        Text(L10n.News.Molo.PasswordRenewal.Text.description)
            .font(.moloContentDefault)
            .multilineTextAlignment(.center)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var submitButton: some View {
        PrimaryButton(
            text: L10n.News.Molo.PasswordRenewal.Button.submit,
            onClick: {
                if password.isEmpty || confirmation.isEmpty || password != confirmation {
                    error = true
                } else {
                    execute(.onClickSave(password: password))
                }
            }
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

            Spacer()
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
    PasswordRenewal { _ in }
        .preferredColorScheme(.dark)
}

#Preview("light") {
    PasswordRenewal { _ in }
        .preferredColorScheme(.light)
}
