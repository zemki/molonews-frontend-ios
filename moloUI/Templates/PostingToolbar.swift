//
//  PostingToolbar.swift
//  Templates
//

import Assets
import Atoms
import Dimensions
import Foundation
import SwiftUI

public struct PostingToolbar: ToolbarContent {
    private let leadingAction: (icon: Image, onClick: () -> Void)
    private let trailingAction: (icon: Image, onClick: () -> Void)?
    private let title: String

    public init(
        leadingAction: (icon: Image, onClick: () -> Void),
        trailingAction: (icon: Image, onClick: () -> Void)?,
        title: String
    ) {
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.title = title
    }

    @ToolbarContentBuilder
    var leadingButton: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            IconButton(icon: leadingAction.icon, resizable: false, color: Colors.Icons.navigation.swiftUIColor) {
                leadingAction.onClick()
            }
            .frame(width: 44, height: 44)
            .background(.clear)
        }
    }

    @ToolbarContentBuilder
    var principalTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.moloTitleDefault)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
        }
    }

    @ToolbarContentBuilder
    var trailingButton: some ToolbarContent {
        if let trailingAction {
            ToolbarItemGroup(placement: .topBarTrailing) {
                IconButton(icon: trailingAction.icon, resizable: false, color: Colors.Icons.postingNavigation.swiftUIColor) {
                    trailingAction.onClick()
                }
                .frame(width: 85, height: 37)
                .background {
                    RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                        .fill(Colors.Background.primary.swiftUIColor)
                }
            }
        }
    }

    public var body: some ToolbarContent {
        leadingButton

        principalTitle

        if #available(iOS 26.0, *) {
            trailingButton
                .sharedBackgroundVisibility(.hidden)
        } else {
            trailingButton
        }
    }
}
