//
//  ProfileImage.swift
//  Atoms
//

import Assets
import Dimensions
import Kingfisher
import SwiftUI

public struct ProfileImage: View {
    private let imageWidthHeight: CGFloat = 222

    private let imageUrlString: String?
    private let imageData: Data?

    public init(imageUrlString: String?, imageData: Data?) {
        self.imageUrlString = imageUrlString
        self.imageData = imageData
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
            .frame(width: imageWidthHeight, height: imageWidthHeight)
            .background {
                Colors.Background.postingImage.swiftUIColor
            }
            .clipShape(
                RoundedRectangle(cornerRadius: .cornerRadiusSmall)
            )

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
    ProfileImage(
        imageUrlString: "https://picsum.photos/600/500",
        imageData: nil
    )
}

#Preview("placeholder") {
    ProfileImage(
        imageUrlString: nil,
        imageData: nil
    )
}
