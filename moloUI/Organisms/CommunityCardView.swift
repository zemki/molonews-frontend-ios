//
//  CommunityCardView.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import Molecules
import SwiftUI

public struct CommunityCardView: View {
    private let imageHeight: CGFloat = 150
    private let cardHeight: CGFloat = 380

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
    private let isPublished: Bool

    private let menuAction: (Int) -> Void
    private let bookmarkAction: (Int) -> Void
    private let detailAction: (Int) -> Void
    private let organizationDetailAction: (Int) -> Void

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
        isPublished: Bool,
        menuAction: @escaping (Int) -> Void,
        bookmarkAction: @escaping (Int) -> Void,
        detailAction: @escaping (Int) -> Void,
        organizationDetailAction: @escaping (Int) -> Void
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
        self.isPublished = isPublished

        self.menuAction = menuAction
        self.bookmarkAction = bookmarkAction
        self.detailAction = detailAction
        self.organizationDetailAction = organizationDetailAction
    }

    private var organizationNameDateView: some View {
        VStack(alignment: .leading, spacing: 0) {
            CardNameText(organizationName)

            CardDateText(newsDate)
        }
        .padding(.horizontal, .horizontalDefault)
    }

    private var organizationHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            OverlayedImages(logoUrlString: organizationLogoUrlString, typeImage: organizationTypeImage)

            organizationNameDateView
        }
        .onTapGesture {
            organizationDetailAction(organizationId)
        }
        .padding(.top, .verticalLarge)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            organizationHeader

            CardTextContent(title: newsTitle, titleLineLimit: 1, content: newsContent)
                .padding(.top, .verticalDefault)

            ZStack {
                CardImage(imageUrlString: newsImageUrlString, imageHeight: imageHeight)
                    .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
                    .cornerRadius(.cornerRadiusLarge)

                if !isPublished {
                    Assets.Icons.Posting.draft.swiftUIImage
                }
            }

            if let watchedCount, let bookmarkedCount {
                HStack(spacing: 0) {
                    Spacer()

                    WatchedAndBookmarkedStack(watchedCount: watchedCount, bookmarkedCount: bookmarkedCount)
                }
                .padding(.top, .verticalDefault)
            }
        }
        .padding(.horizontal, .horizontalDefault)
        .padding(.vertical, .verticalLarge)
        .background {
            Group {
                isPublished ?
                    Colors.Background.newsCard.swiftUIColor :
                    Colors.Background.draftCard.swiftUIColor
            }
            .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
            .background {
                CardShadow()
            }
        }
        .frame(height: cardHeight)
        .onTapGesture {
            detailAction(articleId)
        }
    }
}

private struct PreviewCommunityCardView: View {
    var body: some View {
        CommunityCardView(
            articleId: 1,
            organizationId: 1,
            organizationName: "Berk Alkoç",
            organizationLogoUrlString: "https://picsum.photos/200/300",
            organizationTypeImage: Assets.Icons.Organization.community.swiftUIImage,
            newsDate: "13:29 Uhr",
            newsTitle: "Lichter der City - Bild- und Video-Projektionen beleuchten Bremer Stadtzentrum",
            newsImageUrlString: "https://picsum.photos/200/300",
            newsContent: "Vom 3. bis 19. Januar 2025 werden die Fassaden zahlreicher Gebäude im Stadtzentrum beleuchtet und bringen mit Bild- und Video-Projektionen Licht in die dunkle Jahreszeit. #LichterderCity2025",
            watchedCount: 5,
            bookmarkedCount: 0,
            isPublished: false,
            menuAction: { articleId in
                print("menu pressed: \(articleId)")
            },
            bookmarkAction: { articleId in
                print("watch pressed: \(articleId)")
            },
            detailAction: { articleId in
                print("detail pressed: \(articleId)")
            },
            organizationDetailAction: { organizationId in
                print("organization detail pressed: \(organizationId)")
            }
        )
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PreviewCommunityCardView()
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PreviewCommunityCardView()
    }
    .colorScheme(.dark)
}
