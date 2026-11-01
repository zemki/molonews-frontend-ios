//
//  CardTitleText.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct CardTitleText: View {
    private let title: String
    private let lineLimit: Int

    public init(_ title: String, lineLimit: Int) {
        self.title = title
        self.lineLimit = lineLimit
    }

    public var body: some View {
        Text(title)
            .font(.moloTitleSmall)
            .lineLimit(lineLimit)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }
}

#Preview {
    CardTitleText("ArticleTitleText example", lineLimit: 1)
}
