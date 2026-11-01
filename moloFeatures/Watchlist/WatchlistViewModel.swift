//
//  WatchlistViewModel.swift
//  Watchlist
//

import ArticleList
import Combine
import EventList
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class WatchlistViewModel: ObservableObject {
    @Published private(set) var articleListState: ArticleListState = .idle
    @Published private(set) var eventListState: EventListState = .idle

    @Published var searchString: String = ""

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private let articleListViewModel = ArticleListViewModel(listType: .watchlist)
    private let eventListViewModel = EventListViewModel(listType: .watchlist)

    private var cancellables = Set<AnyCancellable>()

    public init() {
        articleListViewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articleListState in
                self?.articleListState = articleListState
            }
            .store(in: &cancellables)

        eventListViewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] eventListState in
                self?.eventListState = eventListState
            }
            .store(in: &cancellables)
    }

    func executeArticleIntent(_ intent: ArticleListIntent) {
        switch intent {
        case .loadArticles:
            articleListViewModel.loadArticles()
        case let .loadMoreArticles(offset, _):
            articleListViewModel.loadMoreArticles(from: offset)
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

    func executeEventIntent(_ intent: EventListIntent) {
        switch intent {
        case .loadEvents:
            eventListViewModel.loadEvents()
        case let .loadMoreEvents(offset):
            eventListViewModel.loadMoreEvents(from: offset)
        case let .onClickEvent(id):
            coordinator?.showSheet(Coordinator.SheetRoute.eventDetail(id: id))
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: false))
        case .pullToRefresh:
            eventListViewModel.loadEvents()
        case .onClickDeletePosting(id: _):
            fatalError("[Error] Deletion of event must not be permitted by ui")
        }
    }
}
