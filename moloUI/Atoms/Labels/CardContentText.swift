//
//  CardContentText.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct CardContentText: View {
    private let content: LocalizedStringKey

    public init(_ content: String) {
        self.content = LocalizedStringKey(content)
    }

    public var body: some View {
        Text(content)
            .font(.moloContentDefault)
            .lineLimit(4)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }
}

#Preview {
    CardContentText("ArticleContentText example")
}
