//
//  SearchViewModel.swift
//  Search
//

import ArticleList
import Combine
import Domain
import EventList
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class SearchViewModel: ObservableObject {
    @Published private(set) var state: SearchState = .idle
    @Published private(set) var articleListState: ArticleListState = .idle
    @Published private(set) var eventListState: EventListState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private let articleListViewModel = ArticleListViewModel(listType: .search)
    private let eventListViewModel = EventListViewModel(listType: .search)

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

    func executeIntent(_ intent: SearchIntent) {
        switch intent {
        case .willAppear:
            loadHistoryFromCache()
        case let .onStartSearch(query, force, type):
            addToHistory(query: query)
            switch type {
            case .articles:
                loadArticles(query: query, force: force)
            case .events:
                loadEvents(query: query, force: force)
            }
        case .backToHistory:
            loadHistoryFromCache()
        case .onClickClearHistory:
            clearHistory()
        case let .onClickRemoveFromHistory(query):
            removeFromHistory(query: query)
        }
    }

    private func loadHistoryFromCache() {
        LoadHistoryUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(items):
                    self?.state = .history(items: items)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                }
            }
            .store(in: &cancellables)
    }

    private func addToHistory(query: String) {
        AddToHistoryUseCase(item: SearchItem(query: query))
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { useCaseState in
                switch useCaseState {
                case .isLoading,
                     .success:
                    break
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                }
            }
            .store(in: &cancellables)
    }

    private func removeFromHistory(query: String) {
        RemoveFromHistoryUseCase(item: SearchItem(query: query))
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success:
                    self?.loadHistoryFromCache()
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                }
            }
            .store(in: &cancellables)
    }

    private func clearHistory() {
        ClearHistoryUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success:
                    self?.state = .history(items: [])
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                }
            }
            .store(in: &cancellables)
    }

    private func loadArticles(query: String, force: Bool) {
        if force {
            executeArticleIntent(.loadArticles(searchString: query))
        } else if case .idle = articleListState, !query.isEmpty {
            executeArticleIntent(.loadArticles(searchString: query))
        }
        state = .searchResults(query: query)
    }

    private func loadEvents(query: String, force: Bool) {
        if force {
            executeEventIntent(.loadEvents(searchString: query))
        } else if case .idle = eventListState, !query.isEmpty {
            executeEventIntent(.loadEvents(searchString: query))
        }
        state = .searchResults(query: query)
    }

    func executeArticleIntent(_ intent: ArticleListIntent) {
        switch intent {
        case let .loadArticles(query, _):
            articleListViewModel.loadArticles(searchString: query)
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
        case let .loadEvents(query):
            eventListViewModel.loadEvents(searchString: query)
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
