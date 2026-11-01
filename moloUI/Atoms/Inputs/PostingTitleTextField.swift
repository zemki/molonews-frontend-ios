//
//  PostingTitleTextField.swift
//  Atoms
//

import Assets
import Dimensions
import Foundation
import SwiftUI

public struct PostingTitleTextField: View {
    private let titleHeight: CGFloat = 52

    @Binding var content: String

    private let imageUrlString: String
    private let placeholder: String

    public init(
        imageUrlString: String,
        contentBinding: Binding<String>,
        placeholder: String
    ) {
        self.imageUrlString = imageUrlString
        _content = contentBinding
        self.placeholder = placeholder
    }

    public var body: some View {
        HStack {
            SquareImage(imageUrlString: imageUrlString, imageSize: titleHeight)
                .cornerRadius(.cornerRadiusSmall)
                .padding(.trailing, .horizontalDefault)

            VStack(alignment: .leading) {
                TextField(placeholder, text: $content)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .font(.moloTitleXLarge)
                    .foregroundStyle(Colors.Text.postingTitle.swiftUIColor)

                Spacer()

                Divider()
                    .overlay(Colors.Separator.posting.swiftUIColor)
            }
            .frame(height: titleHeight)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("dark") {
    @Previewable @State var text: String = ""
    PostingTitleTextField(
        imageUrlString: "https://picsum.photos/600/200",
        contentBinding: $text,
        placeholder: "Titel"
    )
    .preferredColorScheme(.dark)
}

#Preview("light") {
    @Previewable @State var text: String = ""
    PostingTitleTextField(
        imageUrlString: "https://picsum.photos/600/200",
        contentBinding: $text,
        placeholder: "Titel"
    )
    .preferredColorScheme(.light)
}
