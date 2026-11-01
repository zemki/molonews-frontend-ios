//
//  OnboardingPageView.swift
//  Organisms
//

import Assets
import Atoms
import Dimensions
import Molecules
import Strings
import SwiftUI

public struct OnboardingPageView: View {
    private let titleImage: Image
    private let backButtonImage: Image?
    private let pageIndicatorImage: Image

    private let titleString1: String
    private let titleString2: String
    private let titleString1Color: Color
    private let titleString2Color: Color

    private let descriptionString: String

    private let buttonString: String
    private let buttonImage: Image?

    private let backAction: (() -> Void)?
    private let action: () -> Void

    public init(
        titleImage: Image,
        backButtonImage: Image?,
        pageIndicatorImage: Image,
        titleString1: String,
        titleString2: String,
        titleString1Color: Color,
        titleString2Color: Color,
        descriptionString: String,
        buttonString: String,
        buttonImage: Image?,
        backAction: (() -> Void)?,
        action: @escaping () -> Void
    ) {
        self.titleImage = titleImage
        self.backButtonImage = backButtonImage
        self.pageIndicatorImage = pageIndicatorImage
        self.titleString1 = titleString1
        self.titleString2 = titleString2
        self.titleString1Color = titleString1Color
        self.titleString2Color = titleString2Color
        self.descriptionString = descriptionString
        self.buttonString = buttonString
        self.buttonImage = buttonImage
        self.backAction = backAction
        self.action = action
    }

    @ViewBuilder
    private var backButton: some View {
        if let backButtonImage, let backAction {
            IconButton(icon: backButtonImage, color: Colors.Icons.topNavigation.swiftUIColor, action: backAction)
        } else {
            EmptyView()
        }
    }

    private var titleText: some View {
        Group {
            Text(titleString1).foregroundStyle(titleString1Color) +
                Text(titleString2).foregroundStyle(titleString2Color)
        }
        .font(.moloTitleXLarge)
        .multilineTextAlignment(.leading)
    }

    private var descriptionText: some View {
        Text(.init(descriptionString))
            .font(.moloContentDefault)
            .multilineTextAlignment(.leading)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }

    private var submitButton: some View {
        PrimaryButton(
            text: buttonString,
            image: buttonImage,
            onClick: { action() }
        )
    }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                titleImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)

                HStack(spacing: 0) {
                    backButton

                    Spacer()

                    pageIndicatorImage
                }
                .padding(.top, .verticalLarge)
                .padding(.horizontal, .horizontalLarge)
            }

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                titleText
                    .padding(.bottom, .verticalDefault)

                descriptionText
                    .padding(.bottom, .verticalLarge * 2)

                submitButton

                Spacer()
            }
            .padding(.horizontal, .horizontalLarge * 2)
        }
        .background(Colors.Background.inputForm.swiftUIColor)
    }
}
