//
//  SecondaryButton.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct SecondaryButton: View {
    let text: String
    let onClick: () -> Void

    public init(text: String, onClick: @escaping () -> Void) {
        self.text = text
        self.onClick = onClick
    }

    public var body: some View {
        Button(text, action: onClick)
            .buttonStyle(SecondaryStyle())
    }

    struct SecondaryStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .font(.moloSubtitleRegular)
                .frame(maxWidth: .buttonWidth, maxHeight: .buttonHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                        .stroke(lineWidth: 1)
                )
                .contentShape(
                    RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                )
        }
    }
}

#Preview {
    SecondaryButton(text: "Abmelden", onClick: { print("klick") })
}
