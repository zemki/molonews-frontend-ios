//
//  RegistrationView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI
import Templates

public struct RegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel

    public init(viewModel: RegistrationViewModel) {
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
                Registration(execute: viewModel.executeIntent(_:))
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .padding(0)
    }
}

private struct Registration: View {
    private let execute: (RegistrationIntent) -> Void

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var prename: String = ""
    @State private var lastname: String = ""
    @State private var displayName: String = ""

    @State private var isChecked: Bool = false
    
    @State private var error: Bool = false
    @State private var isCheckedError: Bool = false

    init(execute: @escaping (RegistrationIntent) -> Void) {
        self.execute = execute
    }

    private var inputStack: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            DefaultTextField(label: L10n.News.Molo.Registration.Input.email, textContentType: .username, contentBinding: $email, errorBinding: $error)
            DefaultTextField(
                label: L10n.News.Molo.Registration.Input.password,
                textContentType: .newPassword,
                contentBinding: $password,
                errorBinding: $error
            )
            DefaultTextField(
                label: L10n.News.Molo.Registration.Input.prename,
                textContentType: .givenName,
                contentBinding: $prename,
                errorBinding: $error
            )
            DefaultTextField(
                label: L10n.News.Molo.Registration.Input.lastname,
                textContentType: .familyName,
                contentBinding: $lastname,
                errorBinding: $error
            )
            DefaultTextField(
                label: L10n.News.Molo.Registration.Input.displayName,
                textContentType: .name,
                contentBinding: $displayName,
                errorBinding: $error
            )
        }
    }

    private var titleText: some View {
        Text(L10n.News.Molo.Registration.Text.title)
            .font(.moloTitleLarge)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var descriptionText: some View {
        Text(L10n.News.Molo.Registration.Text.description)
            .font(.moloContentDefault)
            .multilineTextAlignment(.center)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var checkbox: some View {
        Toggle(isOn: $isChecked) {
            Group {
                Text(L10n.News.Molo.Registration.Text.Terms.prefix) +
                    Text(.init(L10n.News.Molo.Registration.Text.Terms.link)).underline() +
                    Text(L10n.News.Molo.Registration.Text.Terms.postfix)
            }
            .font(.moloFooterMedium)
            .multilineTextAlignment(.leading)
            .foregroundStyle(isCheckedError ? Colors.Text.error.swiftUIColor : Colors.Text.default.swiftUIColor)
            .tint(isCheckedError ? Colors.Text.error.swiftUIColor : Colors.Text.default.swiftUIColor)
            .onChange(of: isChecked) { _, _ in
                isCheckedError = false
            }
        }
        .toggleStyle(CheckboxToggleStyle())
    }

    private var submitButton: some View {
        PrimaryButton(
            text: L10n.News.Molo.Registration.Button.submit,
            onClick: {
                if email.isEmpty || password.isEmpty || prename.isEmpty || lastname.isEmpty || displayName.isEmpty {
                    error = true
                } else if isChecked == false {
                    isCheckedError = true
                } else {
                    execute(
                        .onClickRegister(
                            email: email,
                            password: password,
                            prename: prename,
                            lastname: lastname,
                            displayName: displayName
                        )
                    )
                }
            }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                titleText
                    .padding(.bottom, .verticalLarge)
                descriptionText

                inputStack
                    .padding(.vertical, .verticalXLarge)

                checkbox
                    .padding(.bottom, .verticalXLarge * 2)

                submitButton
                    .frame(height: .buttonHeight)
            }
            .padding(.top, .verticalXLarge * 2)
            .padding(.horizontal, .horizontalDefault)
        }
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
    Registration { _ in }
        .preferredColorScheme(.dark)
}

#Preview("light") {
    Registration { _ in }
        .preferredColorScheme(.light)
}
