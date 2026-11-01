//
//  PostingInputs.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct PostingInputs: View {
    @Binding private var title: String
    @Binding private var content: String

    private let titlePlaceholder: String
    private let contentPlaceholder: String
    private let imageUrlString: String

    public init(
        title: Binding<String>,
        content: Binding<String>,
        titlePlaceholder: String,
        contentPlaceholder: String,
        imageUrlString: String
    ) {
        _title = title
        _content = content
        self.titlePlaceholder = titlePlaceholder
        self.contentPlaceholder = contentPlaceholder
        self.imageUrlString = imageUrlString
    }

    public var body: some View {
        VStack(spacing: 0) {
            PostingTitleTextField(imageUrlString: imageUrlString, contentBinding: $title, placeholder: titlePlaceholder)
                .padding(.bottom, .verticalSmall)

            PostingDescriptionTextEditor(text: $content, placeholder: contentPlaceholder)
        }
    }
}

#Preview("light") {
    @Previewable @State var title: String = ""
    @Previewable @State var content: String = ""

    PostingInputs(
        title: $title,
        content: $content,
        titlePlaceholder: "Titel",
        contentPlaceholder: "Was geht?",
        imageUrlString: "https://picsum.photos/200/200"
    )
    .colorScheme(.light)
}

#Preview("dark") {
    @Previewable @State var title: String = ""
    @Previewable @State var content: String = ""

    PostingInputs(
        title: $title,
        content: $content,
        titlePlaceholder: "Titel",
        contentPlaceholder: "Was geht?",
        imageUrlString: "https://picsum.photos/200/200"
    )
    .colorScheme(.dark)
}
