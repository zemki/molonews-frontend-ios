//
//  ArticleCardView.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import Molecules
import SwiftUI

public struct ArticleCardView: View {
    private let imageHeight: CGFloat = 150
    private let newsContentHeight: CGFloat = 210

    private let articleId: Int
    private let organizationId: Int
    private let organizationName: String
    private let organizationLogoUrlString: String
    private let organizationTypeImage: Image
    private let newsDate: String
    private let newsTitle: String
    private let newsImageUrlString: String
    private let newsContent: String
    private let watchedCount: Int?
    private let bookmarkedCount: Int?

    private let organizationDetailAction: (Int) -> Void
    private let detailAction: (Int) -> Void

    public init(
        articleId: Int,
        organizationId: Int,
        organizationName: String,
        organizationLogoUrlString: String,
        organizationTypeImage: Image,
        newsDate: String,
        newsTitle: String,
        newsImageUrlString: String,
        newsContent: String,
        watchedCount: Int?,
        bookmarkedCount: Int?,
        organizationDetailAction: @escaping (Int) -> Void,
        detailAction: @escaping (Int) -> Void
    ) {
        self.articleId = articleId
        self.organizationId = organizationId

        self.organizationName = organizationName
        self.organizationLogoUrlString = organizationLogoUrlString
        self.organizationTypeImage = organizationTypeImage
        self.newsDate = newsDate
        self.newsTitle = newsTitle
        self.newsImageUrlString = newsImageUrlString
        self.newsContent = newsContent
        self.watchedCount = watchedCount
        self.bookmarkedCount = bookmarkedCount

        self.organizationDetailAction = organizationDetailAction
        self.detailAction = detailAction
    }

    private var imageAndTextContent: some View {
        VStack(spacing: 0) {
            CardImage(imageUrlString: newsImageUrlString, imageHeight: imageHeight)

            CardTextContent(title: newsTitle, titleLineLimit: 2, content: newsContent)
                .padding(.horizontal, .horizontalDefault)
                .padding(.top, 55)
                .frame(height: newsContentHeight)
                .background {
                    Colors.Background.newsCard.swiftUIColor
                }

            if let watchedCount, let bookmarkedCount {
                HStack(spacing: 0) {
                    Spacer()

                    WatchedAndBookmarkedStack(watchedCount: watchedCount, bookmarkedCount: bookmarkedCount)
                }
            }
        }
    }

    private var organizationNameDateView: some View {
        HStack(alignment: .center, spacing: 0) {
            CardNameText(organizationName)
                .onTapGesture {
                    organizationDetailAction(organizationId)
                }

            Spacer()

            CardDateText(newsDate)
        }
        .padding(.leading, .horizontalMedium)
        .padding(.trailing, .horizontalDefault)
    }

    private var organizationHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            OverlayedImages(
                logoUrlString: organizationLogoUrlString,
                typeImage: organizationTypeImage
            )
            .padding(.leading, .horizontalDefault)

            organizationNameDateView
        }
        .frame(alignment: .bottom)
        .onTapGesture {
            organizationDetailAction(organizationId)
        }
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            imageAndTextContent

            organizationHeader
                .offset(y: -26)
        }
        .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
        .frame(height: imageHeight + newsContentHeight)
        .background {
            CardShadow()
        }
        .onTapGesture {
            detailAction(articleId)
        }
    }
}

private struct PreviewNewsCardView: View {
    var body: some View {
        ArticleCardView(
            articleId: 123,
            organizationId: 456,
            organizationName: "taz",
            organizationLogoUrlString: "https://picsum.photos/300/300",
            organizationTypeImage: Assets.Icons.Organization.news.swiftUIImage,
            newsDate: "18:07 Uhr",
            newsTitle: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
            newsImageUrlString: "https://picsum.photos/300/200",
            newsContent: "Der Wetterdienst warnt vor **Glatteis** in Norddeutschland.\nIm Laufe des Tages können auch der *Osten*, die *Mitte* des Landes sowie *Süddeutschland* betroffen sein. Und wenn der Text hier noch länger ist, werden maximal vier Zeilen Text angezeigt",
            watchedCount: 5,
            bookmarkedCount: 0,
            organizationDetailAction: { organizationId in
                print("navigate to organization: \(organizationId)")
            },
            detailAction: { articleId in
                print("navigate to detail: \(articleId)")
            }
        )
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PreviewNewsCardView()
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PreviewNewsCardView()
    }
    .colorScheme(.dark)
}
