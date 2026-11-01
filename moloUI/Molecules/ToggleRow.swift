//
//  ToggleRow.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct ToggleRow: View {
    @Binding private var isSelected: Bool

    private let logoUrlString: String
    private let title: String

    public init(logoUrlString: String, title: String, isSelected: Binding<Bool>) {
        self.logoUrlString = logoUrlString
        self.title = title
        _isSelected = isSelected
    }

    public var body: some View {
        Toggle(isOn: $isSelected) {
            HStack(spacing: .horizontalDefault) {
                RoundCorneredFittingImage(
                    urlString: logoUrlString,
                    size: CGSize(width: .organizationLogoSizeSmall, height: .organizationLogoSizeSmall)
                )

                Text(title)
                    .font(.moloSourceSelection)
                    .lineLimit(1)
                    .foregroundStyle(Colors.Text.default.swiftUIColor)
            }
        }
        .tint(Colors.Toggle.selected.swiftUIColor)
    }
}

#Preview {
    @Previewable @State var isSelected = true
    ToggleRow(logoUrlString: "https://picsum.photos/100/100", title: "SAMPLE ORG", isSelected: $isSelected)
}
