//
//  FeedViewModel.swift
//  Feed
//

import ArticleList
import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class FeedViewModel: ObservableObject {
    @Published private(set) var state: ArticleListState = .idle

    @Published var searchString: String = ""
    @Published var deactivateFilter: Bool = false

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private let articleListViewModel = ArticleListViewModel(listType: .feed)

    public init() {
        articleListViewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articleListState in
                self?.state = articleListState
            }
            .store(in: &cancellables)

        handleLocationChangedNotification()
        handleArticleTagsChangedNotification()
        handleSourceSelectionChanged()
        handleNewPostingNotification()
    }

    private func handleLocationChangedNotification() {
        NotificationCenter.default
            .publisher(for: .locationChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.deactivateFilter.toggle()
            }
            .store(in: &cancellables)
    }

    private func handleArticleTagsChangedNotification() {
        NotificationCenter.default
            .publisher(for: .articleTagsChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.deactivateFilter.toggle()
            }
            .store(in: &cancellables)
    }

    private func handleSourceSelectionChanged() {
        NotificationCenter.default
            .publisher(for: .sourceSelectionChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.deactivateFilter.toggle()
            }
            .store(in: &cancellables)
    }

    private func handleNewPostingNotification() {
        NotificationCenter.default
            .publisher(for: .articlePostedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.deactivateFilter.toggle()
            }
            .store(in: &cancellables)
    }

    func executeIntent(_ intent: ArticleListIntent) {
        switch intent {
        case let .loadArticles(searchString, filter):
            articleListViewModel.loadArticles(searchString: searchString, filter: filter)
        case let .loadMoreArticles(offset, filter):
            articleListViewModel.loadMoreArticles(from: offset, filter: filter)
        case .pullToRefresh:
            articleListViewModel.loadArticles()
        case let .onClickArticle(id):
            coordinator?.showSheet(Coordinator.SheetRoute.articleDetail(id: id))
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: true))
        case .onClickDeletePosting(id: _):
            fatalError("[Error] Deletion of article must not be permitted by ui")
        }
    }
}
