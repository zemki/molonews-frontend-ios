//
//  ArticleDetailView.swift
//  Explore
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI

public struct ArticleDetailView: View {
    @ObservedObject var viewModel: ArticleDetailViewModel

    public init(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(article):
                DetailView(
                    article: article,
                    showShare: $viewModel.showShareIntent,
                    showMoreMenu: $viewModel.showMoreMenu,
                    execute: viewModel.executeIntent
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.loadArticle)
        }
        .padding(0)
    }
}

private struct DetailView: View {
    @Binding private var showShare: Bool
    @Binding private var showMoreMenu: Bool

    private let article: Article
    private let execute: (ArticleDetailIntent) -> Void

    init(article: Article, showShare: Binding<Bool>, showMoreMenu: Binding<Bool>, execute: @escaping (ArticleDetailIntent) -> Void) {
        self.article = article
        self.execute = execute
        _showShare = showShare
        _showMoreMenu = showMoreMenu
    }

    var body: some View {
        MoloWebView(urlString: article.link)
            .toolbar {
                DetailTopNavigation(
                    backAction: {
                        execute(.onClickBack)
                    },
                    actions: [
                        (
                            icon: Assets.Icons.Navigation.share.swiftUIImage,
                            toggledIcon: nil,
                            isToggled: nil,
                            onClick: {
                                execute(.onClickShare)
                            }
                        ),
                        (
                            icon: Assets.Icons.Navigation.bookmark.swiftUIImage,
                            toggledIcon: Assets.Icons.Navigation.bookmarked.swiftUIImage,
                            isToggled: article.bookmarked,
                            onClick: {
                                execute(.onClickBookmark)
                            }
                        )
                    ],
                    moreMenuTitleAndActions: [
                        (L10n.News.Molo.Report.article, { execute(.onClickReport) })
                    ]
                )
            }
            .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showShare) {
                ShareSheet(activityItems: [L10n.News.Molo.Share.article(article.title, article.link ?? "") + L10n.News.Molo.Share.links])
                    .presentationDetents([.medium])
            }
            .padding(0)
    }
}

#Preview("light") {
    @Previewable @State var showShare = false
    @Previewable @State var showMoreMenu = false

    DetailView(
        article: Article(id: 1, link: "https://example.com", bookmarked: true, isPublished: true),
        showShare: $showShare,
        showMoreMenu: $showShare,
        execute: { _ in }
    )
    .colorScheme(.light)
}

#Preview("dark") {
    @Previewable @State var showShare = false
    @Previewable @State var showMoreMenu = false

    DetailView(
        article: Article(id: 1, link: "https://example.com", bookmarked: false, isPublished: false),
        showShare: $showShare,
        showMoreMenu: $showMoreMenu,
        execute: { _ in }
    )
    .colorScheme(.dark)
}
