//
//  PostingActionTextField.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct PostingActionTextField: View {
    private let text: String
    private let icon: Image
    private let placeholder: String
    private let action: (() -> Void)?

    public init(text: String, icon: Image, placeholder: String, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.placeholder = placeholder
        self.action = action
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                .fill(Colors.Background.inputPosting.swiftUIColor)
                .frame(height: .textInputHeightLarge)

            HStack {
                TextField(placeholder, text: .constant(text))
                    .padding(.leading, .horizontalXLarge)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .font(.moloTitleSmall)
                    .disabled(true)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if let action {
                    action()
                }
            }

            icon
                .foregroundStyle(Colors.Icons.button.swiftUIColor)
                .padding(.leading, .horizontalMedium)
        }
    }
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingActionTextField(text: "", icon: Assets.Icons.Posting.address.swiftUIImage, placeholder: "Adresse") {
            print("action")
        }
        .padding(.horizontal, .horizontalDefault)
    }
    .preferredColorScheme(.dark)
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingActionTextField(text: "12.12.2012 | 20:15 - 22:30", icon: Assets.Icons.Posting.address.swiftUIImage, placeholder: "Datum") {
            print("action")
        }
        .padding(.horizontal, .horizontalDefault)
    }
    .preferredColorScheme(.light)
}
