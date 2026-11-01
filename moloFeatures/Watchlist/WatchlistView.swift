//
//  WatchlistView.swift
//  Watchlist
//

import ArticleList
import Assets
import Atoms
import Domain
import EventList
import Molecules
import Strings
import SwiftUI

@MainActor
public struct WatchlistView: View {
    @AppStorage(L10n.Storage.App.darkMode) private var isDarkMode: Bool?

    @StateObject var viewModel: WatchlistViewModel

    @State private var selectedPage = 0

    private let topInset: CGFloat = 140

    public init(viewModel: WatchlistViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public init() {
        _viewModel = StateObject(wrappedValue: WatchlistViewModel())
    }

    private var tabView: some View {
        TabView(selection: $selectedPage) {
            Group {
                switch viewModel.eventListState {
                case .idle:
                    EmptyView()
                case .loading:
                    LoadingView()
                case let .success(events, count, _):
                    EventListView(
                        events: events,
                        totalCount: count,
                        searchString: .constant(""),
                        isDeletable: false,
                        execute: viewModel.executeEventIntent
                    )
                    .safeAreaInset(edge: .top) {
                        Spacer()
                            .frame(height: topInset)
                    }
                }
            }
            .tag(0)
            
            Group {
                switch viewModel.articleListState {
                case .idle:
                    EmptyView()
                case .loading:
                    LoadingView()
                case let .success(articles, count, _):
                    ArticleListView(
                        articles: articles,
                        totalCount: count,
                        searchString: .constant(""),
                        filter: .constant(.all),
                        isOverlayHidden: .constant(true),
                        isSearchable: false,
                        isDeletable: false,
                        execute: viewModel.executeArticleIntent
                    )
                    .safeAreaInset(edge: .top) {
                        Spacer()
                            .frame(height: topInset)
                    }
                }
            }
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }

    private var picker: some View {
        Picker("", selection: $selectedPage) {
            Text(L10n.News.Molo.Watchlist.Events.tab).tag(0)
            Text(L10n.News.Molo.Watchlist.Articles.tab).tag(1)
        }
        .pickerStyle(.segmented)
    }

    public var body: some View {
        ZStack {
            tabView

            VStack(spacing: 0) {
                if #available(iOS 26.0, *) {
                    picker
                        .glassEffect(.regular)
                        .padding(.horizontal, .horizontalNavigationBar)
                } else {
                    picker
                        .padding(.horizontal, .horizontalNavigationBar)
                }
                Spacer()
            }
        }
        .task {
            viewModel.executeArticleIntent(.loadArticles())
            viewModel.executeEventIntent(.loadEvents())
        }
        .onChange(of: isDarkMode) { oldValue, _ in
            if oldValue != nil {
                viewModel.executeArticleIntent(.loadArticles())
                viewModel.executeEventIntent(.loadEvents())
            }
        }
        .padding(0)
    }
}
