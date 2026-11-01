//
//  DefaultToolbar.swift
//  moloApp
//

import Assets
import Atoms
import Dimensions
import SwiftUI

struct DefaultTopNavigation: ToolbarContent {
    private let locationAndRadiusString: String
    private let userImageURL: String?
    private let selectLocationAction: () -> Void
    private let selectTopicsAction: () -> Void
    private let openProfileAction: () -> Void

    private let minFrameSize: CGFloat = 40

    init(
        locationAndRadiusString: String,
        userImageURL: String?,
        selectLocationAction: @escaping () -> Void,
        selectTopicsAction: @escaping () -> Void,
        openProfileAction: @escaping () -> Void
    ) {
        self.locationAndRadiusString = locationAndRadiusString
        self.userImageURL = userImageURL
        self.selectLocationAction = selectLocationAction
        self.selectTopicsAction = selectTopicsAction
        self.openProfileAction = openProfileAction
    }

    @ToolbarContentBuilder
    private var logoAndLocation: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: .horizontalSmall) {
                Assets.Icons.Navigation.logo.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .menuIconBackground, height: .iconButtonSize)
                    .padding(.leading, .horizontalSmall)
                    .clipShape(Rectangle())

                Text(locationAndRadiusString)
                    .font(.moloSubtitleRegular)
                    .foregroundStyle(Colors.Text.topNavigation.swiftUIColor)
                    .padding(.trailing, .horizontalMedium)
                    .fixedSize()
                    .contentShape(Rectangle())
            }
            .onTapGesture {
                selectLocationAction()
            }
        }
    }

    @ToolbarContentBuilder
    private var locationAndTopicsSelection: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            IconButton(icon: Assets.Icons.Navigation.topics.swiftUIImage, color: Colors.Icons.button.swiftUIColor) {
                selectTopicsAction()
            }
            .frame(minWidth: minFrameSize, minHeight: minFrameSize)
            .contentShape(Rectangle())
        }

        if #available(iOS 26.0, *) {
            ToolbarSpacer(.fixed, placement: .topBarTrailing)
        }

        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .topBarTrailing) {
                if let url = userImageURL, !url.isEmpty {
                    SquareImage(imageUrlString: url, imageSize: 44)
                        .clipShape(.circle)
                        .onTapGesture {
                            openProfileAction()
                        }
                } else {
                    ZStack {
                        Circle()
                            .stroke(.white.opacity(0.8), lineWidth: 1)
                            .fill(Colors.Background.toolbarItem.swiftUIColor)
                        IconButton(icon: Assets.Icons.Navigation.profile.swiftUIImage, color: Colors.Icons.profile.swiftUIColor) {
                            openProfileAction()
                        }
                    }
                    .frame(width: 44)
                }
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: .topBarTrailing) {
                if let url = userImageURL, !url.isEmpty {
                    SquareImage(imageUrlString: url, imageSize: 44)
                        .clipShape(.circle)
                        .onTapGesture {
                            openProfileAction()
                        }
                } else {
                    IconButton(icon: Assets.Icons.Navigation.profile.swiftUIImage, color: Colors.Icons.button.swiftUIColor) {
                        openProfileAction()
                    }
                    .frame(minWidth: minFrameSize, minHeight: minFrameSize)
                    .contentShape(Rectangle())
                }
            }
        }
    }

    var body: some ToolbarContent {
        if #available(iOS 26.0, *) {
            logoAndLocation
            // .sharedBackgroundVisibility(.hidden)
        } else {
            logoAndLocation
        }
        locationAndTopicsSelection
    }
}

private struct LogoAndLocationView: View {
    let title: String
    let onTap: () -> Void

    var body: some View {}
}
