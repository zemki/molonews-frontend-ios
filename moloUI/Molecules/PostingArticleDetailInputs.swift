//
//  PostingArticleDetailInputs.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct PostingArticleDetailInputs: View {
    @Binding private var linkUrlString: String

    private let linkPlaceholder: String

    public init(
        linkUrlString: Binding<String>,
        linkPlaceholder: String
    ) {
        _linkUrlString = linkUrlString
        self.linkPlaceholder = linkPlaceholder
    }

    public var body: some View {
        VStack(spacing: .verticalMedium) {
            PostingDetailTextField(text: $linkUrlString, icon: Assets.Icons.Posting.link.swiftUIImage, placeholder: linkPlaceholder)
        }
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingArticleDetailInputs(
            linkUrlString: .constant("https://www.link.de"),
            linkPlaceholder: "Link (optional)",
        )
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingArticleDetailInputs(
            linkUrlString: .constant("https://www.link.de"),
            linkPlaceholder: "Link (optional)",
        )
    }
    .colorScheme(.dark)
}
