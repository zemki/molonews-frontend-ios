//
//  CardNameText.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct CardNameText: View {
    private let organizationName: String

    public init(_ organizationName: String) {
        self.organizationName = organizationName
    }

    public var body: some View {
        Text(organizationName)
            .font(.moloSubtitleBold)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }
}

#Preview {
    CardNameText("Weser-Kurier")
}
