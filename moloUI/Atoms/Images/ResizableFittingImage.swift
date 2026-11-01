//
//  ResizableIconView.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct ResizableFittingImage: View {
    let image: Image
    let size: CGSize

    public init(_ image: Image, size: CGSize = .init(width: .organizationTypeSize, height: .organizationTypeSize)) {
        self.image = image
        self.size = size
    }

    public var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width, height: size.height)
            .clipped()
    }
}

#Preview {
    ResizableFittingImage(Assets.Icons.Organization.news.swiftUIImage)
}
