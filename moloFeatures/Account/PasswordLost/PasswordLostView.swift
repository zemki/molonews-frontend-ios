//
//  PasswordLostView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI
import Templates

public struct PasswordLostView: View {
    @ObservedObject var viewModel: PasswordLostViewModel

    public init(viewModel: PasswordLostViewModel) {
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
                PasswordLost(execute: viewModel.executeIntent(_:))
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .padding(0)
    }
}

private struct PasswordLost: View {
    private let execute: (PasswordLostIntent) -> Void

    @State private var email: String = ""
    @State private var error: Bool = false

    init(execute: @escaping (PasswordLostIntent) -> Void) {
        self.execute = execute
    }

    private var inputStack: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            DefaultTextField(label: L10n.News.Molo.PasswordLost.Input.email, textContentType: .username, contentBinding: $email, errorBinding: $error)
        }
    }

    private var titleText: some View {
        Text(L10n.News.Molo.PasswordLost.Text.title)
            .font(.moloTitleLarge)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var descriptionText: some View {
        Text(L10n.News.Molo.PasswordLost.Text.description)
            .font(.moloContentDefault)
            .multilineTextAlignment(.center)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var submitButton: some View {
        PrimaryButton(
            text: L10n.News.Molo.PasswordLost.Button.submit,
            onClick: {
                if email.isEmpty {
                    error = true
                } else {
                    execute(.onClickReset(email: email))
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
    PasswordLost { _ in }
        .preferredColorScheme(.dark)
}

#Preview("light") {
    PasswordLost { _ in }
        .preferredColorScheme(.light)
}
