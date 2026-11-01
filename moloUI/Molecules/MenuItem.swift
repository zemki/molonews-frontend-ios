//
//  MenuItem.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct MenuItem: View {
    private let image: Image
    private let title: String
    private let onClick: () -> Void

    public init(image: Image, title: String, onClick: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.onClick = onClick
    }

    public var body: some View {
        HStack(spacing: .horizontalLarge) {
            ResizableFittingImage(image, size: CGSize(width: .menuIcon, height: .menuIcon))
                .frame(width: .menuIconBackground, height: .menuIconBackground)
                .background(
                    Colors.Background.menuItem.swiftUIColor
                        .clipShape(.rect(cornerRadius: .cornerRadiusSmall))
                )

            Text(title)
                .font(.moloMenuItemDefault)
                .lineLimit(1)
                .foregroundStyle(Colors.Text.default.swiftUIColor)

            Spacer()
        }
        .contentShape(.rect)
        .onTapGesture {
            onClick()
        }
    }
}

#Preview {
    ZStack {
        Colors.Background.default.swiftUIColor

        MenuItem(
            image: Assets.Icons.Participate.info.swiftUIImage,
            title: "Profil",
            onClick: {
                print("on click")
            }
        )
    }
    .colorScheme(.dark)
}
