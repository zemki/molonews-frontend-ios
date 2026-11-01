//
//  DetailTopNavigation.swift
//  Molecules
//

import Assets
import Atoms
import SwiftUI

public struct DetailTopNavigation: ToolbarContent {
    private let iconColor: Color?
    private let backAction: (() -> Void)?
    private let actions: [(icon: Image, toggledIcon: Image?, isToggled: Bool?, onClick: () -> Void)]
    private let moreMenuTitleAndActions: [(String, () -> Void)]

    private let minSize: CGFloat = 40

    public init(
        iconColor: Color? = nil,
        backAction: (() -> Void)? = nil,
        actions: [(icon: Image, toggledIcon: Image?, isToggled: Bool?, onClick: () -> Void)] = [],
        moreMenuTitleAndActions: [(String, () -> Void)] = []
    ) {
        self.iconColor = iconColor
        self.backAction = backAction
        self.actions = actions
        self.moreMenuTitleAndActions = moreMenuTitleAndActions
    }

    public var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            if let backAction {
                Group {
                    if #available(iOS 26.0, *) {
                        IconButton(icon: Assets.Icons.Navigation.back.swiftUIImage, color: Colors.Icons.navigation.swiftUIColor) {
                            backAction()
                        }
                    } else {
                        IconButton(icon: Assets.Icons.Navigation.back.swiftUIImage, color: iconColor ?? Colors.Icons.ios18TopNavigation.swiftUIColor) {
                            backAction()
                        }
                    }
                }
                .frame(minWidth: minSize, minHeight: minSize)
                .contentShape(Rectangle())
            }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            ForEach(Array(zip(actions.indices, actions)), id: \.0) { action in
                let (icon, toggledIcon, isToggled, onClick) = action.1

                if let isToggled, let toggledIcon {
                    Group {
                        if #available(iOS 26.0, *) {
                            IconButton(icon: isToggled ? toggledIcon : icon, color: Colors.Icons.navigation.swiftUIColor) {
                                onClick()
                            }
                        } else {
                            IconButton(icon: isToggled ? toggledIcon : icon, color: iconColor ?? Colors.Icons.ios18TopNavigation.swiftUIColor) {
                                onClick()
                            }
                        }
                    }
                    .frame(minWidth: minSize, minHeight: minSize)
                    .contentShape(Rectangle())
                } else {
                    Group {
                        if #available(iOS 26.0, *) {
                            IconButton(icon: icon, color: Colors.Icons.navigation.swiftUIColor) {
                                onClick()
                            }
                        } else {
                            IconButton(icon: icon, color: iconColor ?? Colors.Icons.ios18TopNavigation.swiftUIColor) {
                                onClick()
                            }
                        }
                    }
                    .frame(minWidth: minSize, minHeight: minSize)
                    .contentShape(Rectangle())
                }
            }

            if !moreMenuTitleAndActions.isEmpty {
                Menu {
                    ForEach(moreMenuTitleAndActions, id: \.0) { titleAndAction in
                        let (title, action) = titleAndAction
                        Button {
                            action()
                        } label: {
                            Text(title)
                        }
                    }
                } label: {
                    if #available(iOS 26.0, *) {
                        IconButton(icon: Assets.Icons.Navigation.more.swiftUIImage, color: Colors.Icons.navigation.swiftUIColor) {}
                    } else {
                        IconButton(icon: Assets.Icons.Navigation.more.swiftUIImage, color: iconColor ?? Colors.Icons.ios18TopNavigation.swiftUIColor) {}
                    }
                }
            }
        }
    }
}
