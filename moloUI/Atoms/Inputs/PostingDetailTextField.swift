//
//  PostingDetailTextField.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct PostingDetailTextField: View {
    @Binding var text: String

    private let icon: Image
    private let placeholder: String

    public init(text: Binding<String>, icon: Image, placeholder: String) {
        _text = text
        self.icon = icon
        self.placeholder = placeholder
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                .fill(Colors.Background.inputPosting.swiftUIColor)
                .frame(height: .textInputHeightLarge)

            TextField(placeholder, text: $text)
                .padding(.leading, .horizontalXLarge)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .font(.moloTitleSmall)

            icon
                .foregroundStyle(Colors.Icons.button.swiftUIColor)
                .padding(.leading, .horizontalMedium)
        }
    }
}

#Preview("dark") {
    @Previewable @State var content: String = ""
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingDetailTextField(text: $content, icon: Assets.Icons.Posting.address.swiftUIImage, placeholder: "Adresse")
            .padding(.horizontal, .horizontalDefault)
    }
    .preferredColorScheme(.dark)
}

#Preview("light") {
    @Previewable @State var content: String = "12.12.2012 | 20:15 - 22:30"

    ZStack {
        Colors.Background.default.swiftUIColor

        PostingDetailTextField(text: $content, icon: Assets.Icons.Posting.address.swiftUIImage, placeholder: "Datum")
            .padding(.horizontal, .horizontalDefault)
    }
    .preferredColorScheme(.light)
}
