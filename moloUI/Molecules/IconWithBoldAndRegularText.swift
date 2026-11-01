//
//  IconWithBoldAndRegularText.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct IconWithBoldAndRegularText: View {
    private let icon: Image
    private let boldText: String?
    private let regularText: String?
    private let iconColor: Color
    private let textColor: Color
    private let fillSpace: Bool

    public init(
        icon: Image,
        boldText: String? = nil,
        regularText: String? = nil,
        iconColor: Color,
        textColor: Color,
        fillSpace: Bool = true
    ) {
        self.icon = icon
        self.boldText = boldText
        self.regularText = regularText
        self.iconColor = iconColor
        self.textColor = textColor
        self.fillSpace = fillSpace
    }

    public var body: some View {
        HStack(spacing: 0) {
            ResizableFittingImage(
                icon,
                size: CGSize(width: .iconSize, height: .iconSize)
            )
            .tint(iconColor)
            .padding(.trailing, .horizontalMedium)

            if let boldText, !boldText.isEmpty {
                Text(boldText)
                    .font(.moloSubtitleBold)
                    .lineLimit(1)
                    .foregroundStyle(textColor)
            }

            if let boldText, let regularText, !boldText.isEmpty, !regularText.isEmpty {
                Text(", ")
                    .font(.moloSubtitleRegular)
                    .lineLimit(1)
                    .foregroundStyle(textColor)
            }

            if let regularText, !regularText.isEmpty {
                Text(regularText)
                    .font(.moloSubtitleRegular)
                    .lineLimit(1)
                    .foregroundStyle(textColor)
            }
            
            if fillSpace {
                Spacer()
            }
        }
    }
}

#Preview("default") {
    IconWithBoldAndRegularText(
        icon: Assets.Icons.Event.calendar.swiftUIImage,
        boldText: "Samstag",
        regularText: "17. Mai, 15:00",
        iconColor: Colors.Icons.eventCard.swiftUIColor,
        textColor: Colors.Text.default.swiftUIColor
    )
}

#Preview("no bold") {
    IconWithBoldAndRegularText(
        icon: Assets.Icons.Event.calendar.swiftUIImage,
        boldText: nil,
        regularText: "Neustadt",
        iconColor: Colors.Icons.eventCard.swiftUIColor,
        textColor: Colors.Text.default.swiftUIColor
    )
}

#Preview("no regular") {
    IconWithBoldAndRegularText(
        icon: Assets.Icons.Event.calendar.swiftUIImage,
        boldText: "Bremen Shakespeare Company",
        regularText: nil,
        iconColor: Colors.Icons.eventCard.swiftUIColor,
        textColor: Colors.Text.default.swiftUIColor
    )
}
