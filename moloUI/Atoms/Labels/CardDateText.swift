//
//  CardDateText.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct CardDateText: View {
    private let date: String

    public init(_ date: String) {
        self.date = date
    }

    public var body: some View {
        Text(date)
            .font(.moloSubtitleRegular)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }
}

#Preview {
    CardDateText("27.12.2024")
}
