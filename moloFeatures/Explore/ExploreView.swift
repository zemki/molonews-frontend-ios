//
//  ExploreView.swift
//  Explore
//

import ArticleList
import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI

@MainActor
public struct ExploreView: View {
    @AppStorage(L10n.Storage.App.darkMode) private var isDarkMode: Bool?

    @StateObject private var viewModel: ExploreViewModel

    @State private var search: String = ""
    @State private var hasLoaded: Bool = false

    public init(viewModel: ExploreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public init() {
        _viewModel = StateObject(wrappedValue: ExploreViewModel())
    }

    public var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
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
                    filter: .constant(.all),
                    isOverlayHidden: .constant(true),
                    isSearchable: true,
                    isDeletable: false,
                    execute: viewModel.executeIntent
                )
                .onAppear {
                    search = searchString
                }
            }
        }
        .task {
            if !hasLoaded {
                hasLoaded = true
                viewModel.executeIntent(.loadArticles())
            }
        }
        .onChange(of: isDarkMode) { oldValue, _ in
            if oldValue != nil {
                viewModel.executeIntent(.loadArticles())
            }
        }
        .padding(0)
    }
}
