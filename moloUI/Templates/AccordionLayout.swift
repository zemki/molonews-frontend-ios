//
//  AccordionLayout.swift
//  Templates
//

import Assets
import Atoms
import Dimensions
import Foundation
import Molecules
import Strings
import SwiftUI

public struct AccordionLayout<Content: View>: View {
    @State private var isExpanded = false

    private let image: Image
    private let title: String
    private let content: () -> Content

    public init(image: Image, title: String, content: @escaping () -> Content) {
        self.image = image
        self.title = title
        self.content = content
    }

    private var sectionImage: some View {
        ResizableFittingImage(image, size: CGSize(width: 30, height: 30))
    }

    private var arrowImage: some View {
        Group {
            if isExpanded {
                Assets.Icons.Sources.arrowOpened.swiftUIImage
            } else {
                Assets.Icons.Sources.arrowClosed.swiftUIImage
            }
        }
        .animation(.easeInOut, value: isExpanded)
    }

    private var headerContent: some View {
        HStack(alignment: .center, spacing: 0) {
            sectionImage
                .padding(.horizontal, .horizontalDefault)

            Text(title)
                .font(.moloSubtitleRegular)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .lineLimit(1)

            Spacer()

            arrowImage
                .padding(.horizontal, .horizontalDefault)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                headerContent
            }
            .frame(height: 100)
            .background(Colors.Background.sourcesCard.swiftUIColor)
            .clipShape(.rect(cornerRadius: .cornerRadiusLarge))

            if isExpanded {
                content()
            }
        }
    }
}
