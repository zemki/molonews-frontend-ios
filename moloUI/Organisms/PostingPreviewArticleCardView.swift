//
//  PostingPreviewArticleCardView.swift
//  Organisms
//

import Assets
import Atoms
import Dimensions
import Kingfisher
import Modifiers
import Molecules
import SwiftUI

public struct PostingPreviewArticleCardView: View {
    private let imageHeight: CGFloat = 150
    private let cardHeight: CGFloat = 380

    private let organizationName: String
    private let organizationLogoUrlString: String
    private let articleImageURLString: String?
    private let articleImageData: Data?
    private let articleTitle: String
    private let articleContent: String

    private let fraction: CGFloat

    private let imageAction: () -> Void

    public init(
        organizationName: String,
        organizationLogoUrlString: String,
        articleImageURLString: String?,
        articleImageData: Data?,
        articleTitle: String,
        articleContent: String,
        widthFraction: CGFloat?,
        imageAction: @escaping () -> Void
    ) {
        self.organizationName = organizationName
        self.organizationLogoUrlString = organizationLogoUrlString
        self.articleImageURLString = articleImageURLString
        self.articleImageData = articleImageData
        self.articleTitle = articleTitle
        self.articleContent = articleContent

        fraction = widthFraction ?? 1.0

        self.imageAction = imageAction
    }

    private var articleTextAndImage: some View {
        VStack(spacing: 0) {
            CardTextContent(title: articleTitle, titleLineLimit: 1, content: articleContent)
                .padding(.top, .verticalDefault)

            CardImagePosting(
                imageUrlString: articleImageURLString,
                imageData: articleImageData,
                imageHeight: imageHeight
            )
            .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
            .cornerRadius(.cornerRadiusLarge)
            .onTapGesture {
                imageAction()
            }
        }
    }

    private var organizationNameDateView: some View {
        VStack(alignment: .leading, spacing: 0) {
            CardNameText(organizationName)

            CardDateText("Vorschau")
        }
        .padding(.horizontal, .horizontalDefault)
    }

    private var organizationHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            OverlayedImages(
                logoUrlString: organizationLogoUrlString,
                typeImage: Assets.Icons.Organization.community.swiftUIImage
            )

            organizationNameDateView
        }
        .padding(.top, .verticalLarge)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            organizationHeader
            articleTextAndImage
        }
        .padding(.horizontal, .horizontalDefault)
        .padding(.vertical, .verticalLarge)
        .background {
            Colors.Background.newsCard.swiftUIColor
                .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
                .background {
                    CardShadow()
                }
        }
        .frame(height: cardHeight)
    }
}

#Preview("image light") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingPreviewArticleCardView(
            organizationName: "Bremerkunst",
            organizationLogoUrlString: "https://picsum.photos/100/100",
            articleImageURLString: "https://picsum.photos/200/300",
            articleImageData: nil,
            articleTitle: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
            articleContent: "Der Wetterdienst warnt vor Glatteis in Norddeutschland. Im Laufe des Tages können auch der Osten, die Mitte des Landes sowie Süddeutschland betroffen sein. 🎭",
            widthFraction: nil,
            imageAction: {
                print("action")
            }
        )
    }
    .colorScheme(.light)
}

#Preview("no image dark") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingPreviewArticleCardView(
            organizationName: "Bremerkunst",
            organizationLogoUrlString: "https://picsum.photos/100/100",
            articleImageURLString: nil,
            articleImageData: nil,
            articleTitle: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
            articleContent: "Der Wetterdienst warnt vor Glatteis in Norddeutschland. Im Laufe des Tages können auch der Osten, die Mitte des Landes sowie Süddeutschland betroffen sein. 🎭",
            widthFraction: nil,
            imageAction: {
                print("action")
            }
        )
    }
    .colorScheme(.dark)
}
