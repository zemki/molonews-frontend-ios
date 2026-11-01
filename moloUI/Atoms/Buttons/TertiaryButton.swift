//
//  TertiaryButton.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct TertiaryButton: View {
    let text: String
    let onClick: () -> Void

    public init(text: String, onClick: @escaping () -> Void) {
        self.text = text
        self.onClick = onClick
    }

    public var body: some View {
        Button(text, action: onClick)
            .buttonStyle(TertiaryStyle())
    }

    struct TertiaryStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .font(.moloSubtitleRegular)
                .frame(maxWidth: .buttonWidth, maxHeight: .buttonHeight)
        }
    }
}

#Preview {
    TertiaryButton(text: "Account löschen", onClick: { print("klick") })
}
