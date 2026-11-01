//
//  PostingDescriptionTextEditor.swift
//  Atoms
//

import Assets
import Dimensions
import Foundation
import SwiftUI

public struct PostingDescriptionTextEditor: View {
    @Binding private var text: String

    private let placeholder: String

    public init(text: Binding<String>, placeholder: String) {
        _text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.moloContentDefault)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled(false)
                .foregroundStyle(Colors.Text.default.swiftUIColor)

            if text.isEmpty {
                Text(placeholder)
                    .font(.moloContentDefault)
                    .foregroundColor(Colors.Text.default80.swiftUIColor)
                    .padding(.top, .verticalDefault)
                    .padding(.leading, .horizontalSmall)
            }
        }
    }
}

#Preview("empty dark") {
    @Previewable @State var text = ""

    PostingDescriptionTextEditor(
        text: $text,
        placeholder: "String"
    )
    .preferredColorScheme(.dark)
}

#Preview("content light") {
    @Previewable @State var text =
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

    PostingDescriptionTextEditor(
        text: $text,
        placeholder: "Placeholder"
    )
    .preferredColorScheme(.light)
}
