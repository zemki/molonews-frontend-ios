//
//  PrimaryButton.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct PrimaryButton: View {
    private let text: String
    private let image: Image?
    private let onClick: () -> Void

    public init(text: String, image: Image? = nil, onClick: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.onClick = onClick
    }

    public var body: some View {
        Button(text, action: onClick)
            .buttonStyle(PrimaryStyle(image: image))
    }

    struct PrimaryStyle: ButtonStyle {
        private let image: Image?

        init(image: Image?) {
            self.image = image
        }

        func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: .horizontalDefault) {
                configuration.label
                image
            }
            .foregroundStyle(Colors.Text.menuItem.swiftUIColor)
            .font(.moloSubtitleRegular)
            .frame(maxWidth: .buttonWidth, maxHeight: .buttonHeight)
            .background(Colors.Background.primary.swiftUIColor)
            .clipShape(.rect(cornerRadius: .cornerRadiusSmall))
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                    .stroke(Colors.Border.topics.swiftUIColor, lineWidth: 1)
            )
        }
    }
}

#Preview("image") {
    PrimaryButton(
        text: "Anmelden / Registieren",
        image: Assets.Icons.Button.arrow.swiftUIImage,
        onClick: { print("klick") }
    )
}

#Preview("no image") {
    PrimaryButton(
        text: "Anmelden / Registieren",
        image: nil,
        onClick: { print("klick") }
    )
}
