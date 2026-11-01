//
//  SquareImage.swift
//  moloUI
//

import Assets
import Kingfisher
import SwiftUI

public struct SquareImage: View {
    private let imageUrlString: String
    private let imageSize: Double

    public init(imageUrlString: String, imageSize: Double) {
        self.imageUrlString = imageUrlString
        self.imageSize = imageSize
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
            .frame(width: imageSize)
            .background {
                Colors.Icons.passive.swiftUIColor
            }
            .clipped()
    }
}

#Preview {
    SquareImage(
        imageUrlString: "https://picsum.photos/600/200",
        imageSize: 200
    )
}

#Preview("as Circle") {
    SquareImage(
        imageUrlString: "https://picsum.photos/600/200",
        imageSize: 200
    )
    .clipShape(.circle)
}
