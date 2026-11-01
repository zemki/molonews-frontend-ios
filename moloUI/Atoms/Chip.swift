//
//  Chip.swift
//  Atoms
//

import Assets
import SwiftUI
import Dimensions

public struct Chip: View {
    private let title: String
    @Binding private var isSelected: Bool

    public init(title: String, isSelected: Binding<Bool>) {
        self.title = title
        _isSelected = isSelected
    }

    var backgroundColor: Color {
        isSelected ? Colors.Background.topicsSelected.swiftUIColor : Colors.Background.topics.swiftUIColor
    }

    var textColor: Color {
        isSelected ? Colors.Text.topicsSelected.swiftUIColor : Colors.Text.topics.swiftUIColor
    }

    var borderColor: Color {
        isSelected ? Colors.Border.topicsSelected.swiftUIColor : Colors.Border.topics.swiftUIColor
    }

    public var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(title)
                .font(.moloSubtitleBold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(borderColor, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("light") {
    @Previewable @State var isSelected = true
    ZStack {
        Colors.Background.default.swiftUIColor

        Chip(title: "Kategorie", isSelected: $isSelected)
            .colorScheme(.light)
    }
}

#Preview("dark") {
    @Previewable @State var isSelected = true
    ZStack {
        Colors.Background.default.swiftUIColor
        Chip(title: "Kategorie", isSelected: $isSelected)
    }
    .colorScheme(.dark)
}
