//
//  CardImagePosting.swift
//  Atoms
//

import Assets
import Dimensions
import Kingfisher
import SwiftUI

public struct CardImagePosting: View {
    private let imageUrlString: String?
    private let imageData: Data?
    private let imageHeight: CGFloat

    public init(imageUrlString: String?, imageData: Data?, imageHeight: CGFloat) {
        self.imageUrlString = imageUrlString
        self.imageData = imageData
        self.imageHeight = imageHeight
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if let imageUrlString, !imageUrlString.isEmpty {
                    KFImage(URL(string: imageUrlString))
                        .resizable()
                        .placeholder {
                            Colors.Icons.passive.swiftUIColor
                        }
                        .foregroundStyle(
                            Colors.Dimming.newsCard.swiftUIColor
                        )
                        .aspectRatio(contentMode: .fill)
                } else {
                    Assets.Icons.Posting.imagePlaceholder.swiftUIImage
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: imageHeight)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .clipped()
            .background {
                Colors.Background.postingImage.swiftUIColor
            }

            if imageUrlString != nil || imageData != nil {
                Assets.Icons.Posting.imageEdit.swiftUIImage
                    .frame(width: .buttonHeight, height: .buttonHeight)
                    .background(
                        Circle()
                            .fill(.white)
                    )
                    .padding(.top, .verticalMedium)
                    .padding(.trailing, .horizontalMedium)
            }
        }
    }
}

#Preview("image") {
    CardImagePosting(
        imageUrlString: "https://picsum.photos/600/500",
        imageData: nil,
        imageHeight: 185
    )
}

#Preview("placeholder") {
    CardImagePosting(
        imageUrlString: nil,
        imageData: nil,
        imageHeight: 185
    )
}
