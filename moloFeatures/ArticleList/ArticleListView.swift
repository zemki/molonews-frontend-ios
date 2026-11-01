//
//  ArticleListView.swift
//  ArticleList
//

import Assets
import Atoms
import Dimensions
import Domain
import Molecules
import Organisms
import Strings
import SwiftUI

public struct ArticleListView: View {
    @Binding private var searchString: String
    @Binding private var filter: OrganizationType
    @Binding private var isOverlayHidden: Bool

    @State private var scrollOffset: CGFloat = 0

    @State private var showDialog = false

    private let hideThreshold: CGFloat = 125

    private let articles: [Article]
    private let totalCount: Int
    private let execute: (ArticleListIntent) -> Void

    private let isSearchable: Bool
    private let isDeletable: Bool

    public init(
        articles: [Article],
        totalCount: Int,
        searchString: Binding<String>,
        filter: Binding<OrganizationType>,
        isOverlayHidden: Binding<Bool>,
        isSearchable: Bool,
        isDeletable: Bool,
        execute: @escaping (ArticleListIntent) -> Void
    ) {
        self.articles = articles
        self.totalCount = totalCount
        _searchString = searchString
        _filter = filter
        _isOverlayHidden = isOverlayHidden
        self.isSearchable = isSearchable
        self.isDeletable = isDeletable
        self.execute = execute
    }

    private var offsetReader: some View {
        GeometryReader { geo in
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: geo.frame(in: .global).minY
                )
        }
        .frame(height: 1)
        .onPreferenceChange(ScrollOffsetKey.self) {
            scrollOffset = $0
        }
    }

    private var articleScrollView: some View {
        ScrollView {
            LazyVStack {
                offsetReader

                ForEach(articles.indices, id: \.self) { index in
                    let article = articles[index]

                    Group {
                        switch article.organizationType {
                        case .collective:
                            createRowForCollective(article: article)
                        case .news:
                            createRowForNews(article: article)
                        case .official:
                            createRowForOfficials(article: article)
                        case .unknown:
                            createRowForNews(article: article)
                        case .all:
                            fatalError("[ERROR] cannot create card for type all")
                        @unknown default:
                            fatalError("[ERROR] cannot create card for unknown type")
                        }
                    }
                    .overlay {
                        if isDeletable {
                            deleteOverlayForArticle(article)
                        }
                    }
                    .onAppear {
                        checkScrollingPositionAndLoadMore(index)
                    }
                    .alert(L10n.News.Molo.Posting.Delete.Alert.title, isPresented: $showDialog) {
                        Button(L10n.News.Molo.Posting.Delete.Alert.ok) {
                            execute(.onClickDeletePosting(id: article.id))
                        }
                        Button(L10n.News.Molo.Posting.Delete.Alert.cancel, role: .cancel) {
                            showDialog = false
                        }
                    } message: {
                        Text(L10n.News.Molo.Posting.Delete.Alert.message)
                    }
                }
            }
            .padding(.vertical, .verticalDefault)
            .padding(.horizontal, .horizontalDefault)
        }
        .refreshable {
            execute(.loadArticles(searchString: searchString, filter: filter))
        }
        .padding(0)
        .contentMargins(.bottom, .verticalScrollMarginBottom)
        .onChange(of: scrollOffset) {
            let shouldHide = scrollOffset < hideThreshold
            if shouldHide != isOverlayHidden {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isOverlayHidden = shouldHide
                }
            }
        }
    }

    public var body: some View {
        articleScrollView
    }

    private func deleteOverlayForArticle(_ article: Article) -> some View {
        HStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                Button {
                    showDialog = true
                }
                label: {
                    Image(systemName: "trash.circle")
                        .resizable()
                        .foregroundStyle(Colors.Icons.button.swiftUIColor)
                        .frame(width: .iconButtonSize, height: .iconButtonSize)
                        .padding(.verticalDefault)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusSmall))
                }

                Spacer()
            }
        }
        .padding(.vertical, .verticalDefault)
        .padding(.horizontal, .horizontalSmall)
    }

    private func createRowForCollective(article: Article) -> some View {
        CommunityCardView(
            articleId: article.id,
            organizationId: article.organizationId,
            organizationName: article.organizationName,
            organizationLogoUrlString: article.organizationLogoUrlString ?? "",
            organizationTypeImage: Assets.Icons.Organization.community.swiftUIImage,
            newsDate: createArticleDateString(article.date),
            newsTitle: article.title,
            newsImageUrlString: article.imageUrlString ?? article.organizationLogoUrlString ?? "",
            newsContent: article.abstract,
            watchedCount: article.watchedCount,
            bookmarkedCount: article.bookmarkedCount,
            isPublished: article.isPublished,
            menuAction: { _ in },
            bookmarkAction: { _ in },
            detailAction: { articleId in
                execute(.onClickArticle(id: articleId))
            },
            organizationDetailAction: { organizationId in
                execute(.onClickOrganization(id: organizationId))
            }
        )
        .id(article.id)
    }

    private func createRowForNews(article: Article) -> some View {
        ArticleCardView(
            articleId: article.id,
            organizationId: article.organizationId,
            organizationName: article.organizationName,
            organizationLogoUrlString: article.organizationLogoUrlString ?? "",
            organizationTypeImage: Assets.Icons.Organization.news.swiftUIImage,
            newsDate: createArticleDateString(article.date),
            newsTitle: article.title,
            newsImageUrlString: article.imageUrlString ?? article.organizationLogoUrlString ?? "",
            newsContent: article.abstract,
            watchedCount: article.watchedCount,
            bookmarkedCount: article.bookmarkedCount,
            organizationDetailAction: { organizationId in
                execute(.onClickOrganization(id: organizationId))
            },
            detailAction: { articleId in
                execute(.onClickArticle(id: articleId))
            }
        )
        .id(article.id)
    }

    private func createRowForOfficials(article: Article) -> some View {
        ArticleCardView(
            articleId: article.id,
            organizationId: article.organizationId,
            organizationName: article.organizationName,
            organizationLogoUrlString: article.organizationLogoUrlString ?? "",
            organizationTypeImage: Assets.Icons.Organization.official.swiftUIImage,
            newsDate: createArticleDateString(article.date),
            newsTitle: article.title,
            newsImageUrlString: article.imageUrlString ?? article.organizationLogoUrlString ?? "",
            newsContent: article.abstract,
            watchedCount: article.watchedCount,
            bookmarkedCount: article.bookmarkedCount,
            organizationDetailAction: { organizationId in
                execute(.onClickOrganization(id: organizationId))
            },
            detailAction: { articleId in
                execute(.onClickArticle(id: articleId))
            }
        )
        .id(article.id)
    }

    private func checkScrollingPositionAndLoadMore(_ index: Int) {
        if index >= articles.count - 5, totalCount > articles.count {
            execute(.loadMoreArticles(offset: articles.count, filter: filter))
        }
    }

    private func createArticleDateString(_ date: Date?) -> String {
        guard let date else {
            return ""
        }

        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return date.formatted(.germanTime) + " " + L10n.News.Molo.Time.appendix
        }

        return date.formatted(.germanDate)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
