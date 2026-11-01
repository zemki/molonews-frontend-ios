//
//  FeedView.swift
//  Feed
//

import ArticleList
import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI

@MainActor
public struct FeedView: View {
    @AppStorage(L10n.Storage.App.darkMode) private var isDarkMode: Bool?

    @StateObject var viewModel: FeedViewModel

    @State private var search: String = ""
    @State private var filter: OrganizationType = .all
    @State private var hasLoaded: Bool = false

    @State private var selectedIndex: Int? = nil
    @State private var isSelected: [Bool] = [false, false, false]

    @State private var isFilterHidden: Bool = false

    let options: [(icon: Image, label: String, type: OrganizationType, isSelected: Bool)] = [
        (Assets.Icons.Filter.news.swiftUIImage, L10n.News.Molo.Sources.News.title, .news, false),
        (Assets.Icons.Filter.official.swiftUIImage, L10n.News.Molo.Sources.Officials.title, .official, false),
        (Assets.Icons.Filter.community.swiftUIImage, L10n.News.Molo.Sources.Collectives.title, .collective, false)
    ]

    public init(viewModel: FeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public init() {
        _viewModel = StateObject(wrappedValue: FeedViewModel())
    }

    private var segmentedControlView: some View {
        HStack(spacing: 0) {
            Spacer()

            ForEach(0 ..< options.count, id: \.self) { index in
                ToggleButton(icon: options[index].icon, label: options[index].label, isSelected: $isSelected[index]) {
                    if selectedIndex == index {
                        selectedIndex = nil
                    } else {
                        selectedIndex = index
                    }
                }
                .padding(.horizontal, .horizontalSmall)
            }

            Spacer()
        }
        .padding(.vertical, .verticalDefault)
    }

    public var body: some View {
        ZStack {
            VStack {
                switch viewModel.state {
                case .idle:
                    LoadingView()
                case let .loading(searchString):
                    LoadingView(searchString: $search, isSearchable: true)
                        .onAppear {
                            search = searchString
                        }
                case let .success(articles, count, searchString):
                    ArticleListView(
                        articles: articles,
                        totalCount: count,
                        searchString: $search,
                        filter: $filter,
                        isOverlayHidden: $isFilterHidden,
                        isSearchable: true,
                        isDeletable: false,
                        execute: viewModel.executeIntent
                    )
                    .onAppear {
                        search = searchString
                    }
                    .safeAreaInset(edge: .top) {
                        Spacer()
                            .frame(height: 66)
                    }
                }
            }
            .task {
                if !hasLoaded {
                    hasLoaded = true
                    viewModel.executeIntent(.loadArticles())
                }
            }
            .onChange(of: selectedIndex) { _, newValue in
                if let index = newValue {
                    isSelected[0] = index == 0
                    isSelected[1] = index == 1
                    isSelected[2] = index == 2

                    filter = options[index].type

                    viewModel.executeIntent(
                        .loadArticles(filter: filter)
                    )
                } else {
                    isSelected[0] = false
                    isSelected[1] = false
                    isSelected[2] = false

                    filter = .all

                    viewModel.executeIntent(
                        .loadArticles(filter: .all)
                    )
                }
            }
            .onChange(of: viewModel.deactivateFilter, {
                isSelected[0] = false
                isSelected[1] = false
                isSelected[2] = false
                
                filter = .all
            })
            .onChange(of: isDarkMode) { oldValue, _ in
                if oldValue != nil {
                    viewModel.executeIntent(.loadArticles(filter: filter))
                }
            }
            .padding(0)

            if !isFilterHidden {
                VStack(spacing: 0) {
                    ViewThatFits {
                        if #available(iOS 26.0, *) {
                            segmentedControlView
                                .glassEffect(.regular)
                                .padding(.horizontal, .horizontalNavigationBar)
                            ScrollView(.horizontal, showsIndicators: false) {
                                segmentedControlView
                                    .glassEffect(.regular)
                                    .padding(.horizontal, .horizontalNavigationBar)
                            }
                        } else {
                            segmentedControlView
                            ScrollView(.horizontal, showsIndicators: false) {
                                segmentedControlView
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .padding(0)
    }
}
