//
//  CardImage.swift
//  Atoms
//

import Assets
import Kingfisher
import SwiftUI

public struct CardImage: View {
    private let imageUrlString: String
    private let imageHeight: CGFloat

    public init(imageUrlString: String, imageHeight: CGFloat) {
        self.imageUrlString = imageUrlString
        self.imageHeight = imageHeight
    }

    public var body: some View {
        KFImage(URL(string: imageUrlString))
            .resizable()
            .placeholder {
                Colors.Icons.passive.swiftUIColor
            }
            .foregroundStyle(
                Colors.Dimming.newsCard.swiftUIColor
            )
            .aspectRatio(contentMode: .fill)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: imageHeight)
            .contentShape(Rectangle())
            .clipped()
            .background {
                Colors.Icons.passive.swiftUIColor
            }
    }
}

#Preview {
    CardImage(
        imageUrlString: "https://picsum.photos/600/500",
        imageHeight: 185
    )
}
