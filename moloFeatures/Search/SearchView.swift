//
//  SearchView.swift
//  Search
//

import ArticleList
import Assets
import Atoms
import Dimensions
import Domain
import EventList
import Molecules
import Strings
import SwiftUI
import Templates

@MainActor
public struct SearchView: View {
    @StateObject var viewModel: SearchViewModel

    public init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public init() {
        _viewModel = StateObject(wrappedValue: SearchViewModel())
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .history(items):
                SearchHistoryView(searchItems: items, execute: viewModel.executeIntent(_:))
            case let .searchResults(query):
                SearchResultsView(
                    query: query,
                    articleListState: viewModel.articleListState,
                    eventListState: viewModel.eventListState,
                    execute: viewModel.executeIntent(_:),
                    executeArticleIntent: viewModel.executeArticleIntent(_:),
                    executeEventIntent: viewModel.executeEventIntent(_:)
                )
            }
        }
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .navigationBarBackButtonHidden(true)
        .padding(0)
    }
}

private struct SearchHistoryView: View {
    @StateObject private var speech = SpeechToTextService()

    @State private var isSearchFocused: Bool = false
    @State private var query: String = ""

    @FocusState private var isSearchTextFieldFocused: Bool

    private let searchItems: [SearchItem]
    private let execute: (SearchIntent) -> Void

    init(searchItems: [SearchItem], execute: @escaping (SearchIntent) -> Void) {
        self.searchItems = searchItems
        self.execute = execute
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(L10n.News.Molo.Search.History.title)
                    .font(.moloSubheading)
                    .lineLimit(1)

                Spacer()

                Button {
                    execute(.onClickClearHistory)
                } label: {
                    Text(L10n.News.Molo.Search.History.clear)
                        .foregroundStyle(Colors.Text.button.swiftUIColor)
                        .font(.moloSubtitleRegular)
                        .frame(maxHeight: .buttonHeight)
                }
            }
            .padding(.horizontal, .horizontalLarge)

            Spacer()

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(searchItems.indices, id: \.self) { index in
                        let item = searchItems[index]
                        SearchHistoryRow(
                            title: item.query,
                            onClick: {
                                execute(.onStartSearch(query: item.query, force: true, type: .events))
                            },
                            onClickDelete: { query in
                                execute(.onClickRemoveFromHistory(query: query))
                            }
                        )
                    }
                    .padding(.vertical, .verticalDefault)
                    .padding(.horizontal, .horizontalDefault)
                }
            }
            .padding(0)
            .contentMargins(.bottom, .verticalScrollMarginBottom)
        }
        .searchable(text: $query)
        .searchFocused($isSearchTextFieldFocused)
        .onSubmit(of: .search) {
            isSearchFocused = false
            speech.stop()
            execute(.onStartSearch(query: query, force: true, type: .events))
        }
        .onChange(of: isSearchTextFieldFocused) {
            isSearchFocused = isSearchTextFieldFocused
        }
        .padding(0)
        .toolbar {
            if #available(iOS 26.0, *) {
                ToolbarItem(placement: .topBarLeading) {
                    Text(L10n.News.Molo.Tabbar.search)
                        .font(.moloTitleXLarge)
                        .foregroundStyle(Colors.Text.default.swiftUIColor)
                        .fixedSize()
                }
                .sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItem(placement: .topBarLeading) {
                    Text(L10n.News.Molo.Tabbar.search)
                        .font(.moloTitleXLarge)
                        .foregroundStyle(Colors.Text.default.swiftUIColor)
                        .fixedSize()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fabMicOverlay(isRecording: $speech.isRecording, isSearchFocused: $isSearchFocused) {
            if speech.isRecording {
                speech.stop()
            } else {
                isSearchTextFieldFocused = true
                speech.start(into: { partial in
                    if !partial.isEmpty {
                        self.query = partial
                    }
                }, onFinal: { final in
                    if !final.isEmpty {
                        self.query = final
                    }
                })
            }
        }
    }
}

private struct SearchResultsView: View {
    @State private var selectedPage: Int = 0

    private let articleListState: ArticleListState
    private let eventListState: EventListState

    @State private var query: String

    private let execute: (SearchIntent) -> Void
    private let executeArticleIntent: (ArticleListIntent) -> Void
    private let executeEventIntent: (EventListIntent) -> Void

    private let topInset: CGFloat = 140

    init(
        query: String?,
        articleListState: ArticleListState,
        eventListState: EventListState,
        execute: @escaping (SearchIntent) -> Void,
        executeArticleIntent: @escaping (ArticleListIntent) -> Void,
        executeEventIntent: @escaping (EventListIntent) -> Void
    ) {
        self.query = query ?? ""
        self.articleListState = articleListState
        self.eventListState = eventListState
        self.execute = execute
        self.executeArticleIntent = executeArticleIntent
        self.executeEventIntent = executeEventIntent
    }

    private var tabView: some View {
        TabView(selection: $selectedPage) {
            Group {
                switch eventListState {
                case .idle:
                    EmptyView()
                case .loading:
                    LoadingView()
                case let .success(events, count, _):
                    EventListView(
                        events: events,
                        totalCount: count,
                        searchString: $query,
                        isDeletable: false,
                        execute: executeEventIntent
                    )
                    .safeAreaInset(edge: .top) {
                        Spacer()
                            .frame(height: topInset)
                    }
                }
            }
            .tag(0)
            .id(0)

            Group {
                switch articleListState {
                case .idle:
                    EmptyView()
                case .loading:
                    LoadingView()
                case let .success(articles, count, _):
                    ArticleListView(
                        articles: articles,
                        totalCount: count,
                        searchString: $query,
                        filter: .constant(.all),
                        isOverlayHidden: .constant(true),
                        isSearchable: false,
                        isDeletable: false,
                        execute: executeArticleIntent
                    )
                    .safeAreaInset(edge: .top) {
                        Spacer()
                            .frame(height: topInset)
                    }
                }
            }
            .tag(1)
            .id(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: selectedPage) {
            execute(.onStartSearch(query: query, force: false, type: selectedPage == 1 ? .articles : .events))
        }
        .ignoresSafeArea()
    }

    private var picker: some View {
        Picker("", selection: $selectedPage) {
            Text(L10n.News.Molo.Search.Events.tab).tag(0)
            Text(L10n.News.Molo.Search.Articles.tab).tag(1)
        }
        .pickerStyle(.segmented)
    }

    var body: some View {
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
                    .allowsHitTesting(false)
            }
        }
        .toolbar {
            DetailTopNavigation(
                iconColor: Colors.Icons.navigation.swiftUIColor,
                backAction: {
                    execute(.backToHistory)
                }
            )
        }
    }
}
