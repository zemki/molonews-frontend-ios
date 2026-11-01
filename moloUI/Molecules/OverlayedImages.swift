//
//  OverlayedImages.swift
//  Organisms
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct OverlayedImages: View {
    private let logoUrlString: String
    private let typeImage: Image

    public init(logoUrlString: String, typeImage: Image) {
        self.logoUrlString = logoUrlString
        self.typeImage = typeImage
    }

    public var body: some View {
        RoundCorneredFittingImage(
            urlString: logoUrlString,
            size: CGSize(width: .organizationLogoSizeDefault, height: .organizationLogoSizeDefault)
        )
        .overlay(alignment: .topTrailing) {
            ResizableFittingImage(typeImage)
                .offset(x: .organizationTypeSize / 2.0, y: .organizationTypeSize / -2.0)
        }
    }
}

private struct OrganizationLogoAndTypeViewPreview: View {
    var body: some View {
        OverlayedImages(
            logoUrlString: "https://picsum.photos/200/200",
            typeImage: Assets.Icons.Organization.news.swiftUIImage
        )
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.app.swiftUIColor
        OrganizationLogoAndTypeViewPreview()
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.newsCard.swiftUIColor
        OrganizationLogoAndTypeViewPreview()
    }
    .colorScheme(.dark)
}
