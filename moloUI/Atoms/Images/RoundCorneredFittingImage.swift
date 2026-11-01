//
//  RoundCorneredFittingImage.swift
//  Atoms
//

import Assets
import Dimensions
import Kingfisher
import SwiftUI

public struct RoundCorneredFittingImage: View {
    private let urlString: String
    private let size: CGSize

    public init(urlString: String, size: CGSize) {
        self.urlString = urlString
        self.size = size
    }

    public var body: some View {
        ZStack {
            Color.white

            KFImage(URL(string: urlString))
                .resizable()
                .placeholder {
                    Colors.Icons.passive.swiftUIColor
                }
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: size.width, height: size.height)
        .clipShape(.rect(cornerRadius: .cornerRadiusSmall))
        .background {
            Colors.Shadow.logo.swiftUIColor
                .shadow(radius: 0, x: 0, y: 5.5)
                .blur(radius: 2.5)
        }
    }
}

#Preview {
    ZStack {
        Colors.Background.default.swiftUIColor

        RoundCorneredFittingImage(urlString: "https://picsum.photos/100/100", size: CGSize(width: 64, height: 64))
    }
}
