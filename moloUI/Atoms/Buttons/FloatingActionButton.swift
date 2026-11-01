//
//  FloatingActionButton.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct FloatingActionButton: View {
    private let icon: Image
    private let action: () -> Void

    public init(icon: Image, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    private var button: some View {
        Button {
            action()
        }
        label: {
            icon
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
                .frame(width: .menuIcon)
                .padding(15)
        }
        .contentShape(Rectangle())
        .frame(width: 60, height: 60)
    }

    public var body: some View {
        if #available(iOS 26.0, *) {
            button
                .glassEffect(.regular.tint(Colors.Fab.background.swiftUIColor), in: .circle)
        } else {
            button
                .background {
                    RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Colors.Fab.background.swiftUIColor)
                }
        }
    }
}

#Preview {
    FloatingActionButton(icon: Assets.Icons.Fab.vector.swiftUIImage) {
        print("fab pressed")
    }
}
