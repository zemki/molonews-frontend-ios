//
//  RegistrationConfirmationView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI

public struct RegistrationConfirmationView: View {
    @ObservedObject var viewModel: RegistrationConfirmationViewModel

    public init(viewModel: RegistrationConfirmationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .success:
                RegistrationConfirmation(execute: viewModel.executeIntent(_:))
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .padding(0)
    }
}

private struct RegistrationConfirmation: View {
    private let execute: (RegistrationConfirmationIntent) -> Void

    init(execute: @escaping (RegistrationConfirmationIntent) -> Void) {
        self.execute = execute
    }

    private var topImage: some View {
        Assets.Icons.Account.confirmation.swiftUIImage
            .resizable()
            .frame(width: 50, height: 50)
    }

    private var titleText: some View {
        Text(L10n.News.Molo.Registration.Confirmation.Text.title)
            .font(.moloTitleSmall)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    private var descriptionText: some View {
        Text(L10n.News.Molo.Registration.Confirmation.Text.description)
            .font(.moloContentDefault)
            .multilineTextAlignment(.center)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
            .padding(.horizontal, .horizontalLarge)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            topImage
                .padding(.bottom, .verticalDefault)
            titleText
                .padding(.bottom, .verticalLarge)
            descriptionText
            
            Spacer()
        }
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
    RegistrationConfirmation { _ in }
        .preferredColorScheme(.dark)
}

#Preview("light") {
    RegistrationConfirmation { _ in }
        .preferredColorScheme(.light)
}
