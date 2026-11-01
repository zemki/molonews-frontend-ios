//
//  ToggleButton.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct ToggleButton: View {
    @Binding private var isSelected: Bool

    private let icon: Image
    private let label: String
    private let action: () -> Void

    public init(icon: Image, label: String, isSelected: Binding<Bool>, action: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        _isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        }
        label: {
            HStack(spacing: 0) {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .iconButtonSize, height: .iconButtonSize)
                    .foregroundStyle(isSelected ? Colors.Icons.filterSelected.swiftUIColor : Colors.Icons.filter.swiftUIColor)
                    .padding(.trailing, .horizontalSmall)

                Text(label)
                    .font(.moloFooterMedium)
                    .foregroundStyle(isSelected ? Colors.Text.filterSelected.swiftUIColor : Colors.Text.filter.swiftUIColor)
            }
            .padding(.vertical, .verticalSmall)
            .padding(.horizontal, .horizontalMedium)
            .overlay {
                RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Colors.Border.topics.swiftUIColor)
            }
            .background {
                RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                    .fill(isSelected ? Colors.Background.filterSelected.swiftUIColor : Colors.Background.filter.swiftUIColor)
                    .foregroundStyle(Colors.Border.topics.swiftUIColor)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview("light") {
    VStack {
        ToggleButton(
            icon: Assets.Icons.Filter.news.swiftUIImage,
            label: "Medien",
            isSelected: .constant(true)
        ) {
            print("news pressed")
        }
        ToggleButton(
            icon: Assets.Icons.Filter.official.swiftUIImage,
            label: "Offizielle",
            isSelected: .constant(false)
        ) {
            print("official pressed")
        }
        ToggleButton(
            icon: Assets.Icons.Filter.community.swiftUIImage,
            label: "Community",
            isSelected: .constant(false)
        ) {
            print("community pressed")
        }
    }
    .preferredColorScheme(.light)
}

#Preview("dark") {
    VStack {
        ToggleButton(
            icon: Assets.Icons.Filter.news.swiftUIImage,
            label: "Medien",
            isSelected: .constant(true)
        ) {
            print("news pressed")
        }
        ToggleButton(
            icon: Assets.Icons.Filter.official.swiftUIImage,
            label: "Offizielle",
            isSelected: .constant(false)
        ) {
            print("official pressed")
        }
        ToggleButton(
            icon: Assets.Icons.Filter.community.swiftUIImage,
            label: "Community",
            isSelected: .constant(false)
        ) {
            print("community pressed")
        }
    }
    .preferredColorScheme(.dark)
}

/*

 "news.molo.sources.news.title" = "Medien";
 "news.molo.sources.officials.title" = "Offizielle";
 "news.molo.sources.collectives.title" = "Community";

 */
