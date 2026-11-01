//
//  IconButton.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct IconButton: View {
    private let icon: Image
    private let resizable: Bool
    private let color: Color
    private let action: () -> Void

    public init(icon: Image, resizable: Bool = true, color: Color, action: @escaping () -> Void) {
        self.icon = icon
        self.resizable = resizable
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        }
        label: {
            Group {
                if resizable {
                    icon
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    icon
                        .renderingMode(.template)
                }
            }
            .frame(width: .iconButtonSize, height: .iconButtonSize)
            .foregroundStyle(color)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    IconButton(icon: Assets.Icons.Feed.watch.swiftUIImage, color: Colors.Icons.button.swiftUIColor) {
        print("button pressed")
    }
}
