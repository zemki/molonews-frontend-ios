//
//  ArticleListViewModel.swift
//  ArticleList
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class ArticleListViewModel: ObservableObject {
    @Published public var state: ArticleListState = .idle

    public enum ListType {
        case feed,
             watchlist,
             organization(id: Int),
             postings,
             search
    }

    private let listType: ListType

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    private var isCurrentlyLoading: Bool = false
    private var feedSearchString: String = ""
    private var exploreSearchString: String = ""
    private var feedOffset: Int = 0
    private var exploreOffset: Int = 0

    public init(listType: ListType) {
        self.listType = listType
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
                guard let self else {
                    return
                }

                if case .search = self.listType {
                    self.loadArticles()
                }
                if case .feed = self.listType {
                    self.loadArticles()
                }
            }
            .store(in: &cancellables)
    }

    private func handleArticleTagsChangedNotification() {
        NotificationCenter.default
            .publisher(for: .articleTagsChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                if case .search = self.listType {
                    self.loadArticles()
                }
                if case .feed = self.listType {
                    self.loadArticles()
                }
            }
            .store(in: &cancellables)
    }

    private func handleSourceSelectionChanged() {
        NotificationCenter.default
            .publisher(for: .sourceSelectionChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                if case .feed = self.listType {
                    self.loadArticles()
                }
            }
            .store(in: &cancellables)
    }

    private func handleNewPostingNotification() {
        NotificationCenter.default
            .publisher(for: .articlePostedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                if case .feed = self.listType {
                    self.loadArticles()
                }
            }
            .store(in: &cancellables)
    }

    public func loadArticles(searchString: String = "", filter: OrganizationType = .all) {
        switch listType {
        case .search:
            if exploreSearchString != searchString {
                searchCancellable?.cancel()
            }
            exploreSearchString = searchString
            searchCancellable = loadSearchArticles(searchString: searchString, ignoreUserSelection: true)
            return
        case .feed:
            return loadArticleList(searchString: searchString, filter: filter, ignoreUserSelection: false)
        case .watchlist:
            return loadBookmarkList()
        case let .organization(id):
            return loadArticlesForOrganization(id)
        case .postings:
            return loadPostingsList()
        }
    }

    private func loadSearchArticles(searchString: String, ignoreUserSelection: Bool) -> AnyCancellable {
        FetchArticlesUseCase(searchString: searchString, offset: 0, ignoreUserSelection: ignoreUserSelection)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading(searchString: searchString)
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
    }

    private func loadArticleList(searchString: String, filter: OrganizationType, ignoreUserSelection: Bool) {
        FetchArticlesUseCase(searchString: searchString, filter: filter, offset: 0, ignoreUserSelection: ignoreUserSelection)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading(searchString: searchString)
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadBookmarkList() {
        FetchBookmarkedArticlesUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading(searchString: "")
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: pagedArticles.results, count: pagedArticles.count, searchString: "")
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadPostingsList() {
        FetchPostedArticlesUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading(searchString: "")
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: pagedArticles.results, count: pagedArticles.count, searchString: "")
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadArticlesForOrganization(_ organizationId: Int) {
        FetchArticlesForOrganizationUseCase(organizationId: organizationId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading(searchString: "")
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: pagedArticles.results, count: pagedArticles.count, searchString: "")
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    public func loadMoreArticles(from offset: Int, filter: OrganizationType = .all) {
        guard case let .success(articles, _, searchString) = state else {
            return loadArticles()
        }

        switch listType {
        case .search:
            if exploreSearchString != searchString || exploreOffset == offset {
                searchCancellable?.cancel()
            }
            exploreSearchString = searchString
            exploreOffset = offset
            searchCancellable = loadMoreSearchArticles(from: offset, ignoreUserSelection: true, searching: searchString, alreadyLoaded: articles)
            return
        case .feed:
            return loadMoreInArticleList(from: offset, filter: filter, ignoreUserSelection: false, searching: searchString, alreadyLoaded: articles)
        case .watchlist:
            return loadMoreInBookmarkList(from: offset, searching: searchString, alreadyLoaded: articles)
        case let .organization(id):
            return loadMoreInArticlesForOrganization(id, from: offset, searching: searchString, alreadyLoaded: articles)
        case .postings:
            return loadMoreInPostingsList(from: offset, searching: searchString, alreadyLoaded: articles)
        }
    }

    private func loadMoreInArticleList(
        from offset: Int,
        filter: OrganizationType,
        ignoreUserSelection: Bool,
        searching searchString: String,
        alreadyLoaded articles: [Article]
    ) {
        FetchArticlesUseCase(searchString: searchString, filter: filter, offset: offset, ignoreUserSelection: ignoreUserSelection)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: articles + pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadMoreSearchArticles(
        from offset: Int,
        ignoreUserSelection: Bool,
        searching searchString: String,
        alreadyLoaded articles: [Article]
    ) -> AnyCancellable {
        FetchArticlesUseCase(searchString: searchString, offset: offset, ignoreUserSelection: ignoreUserSelection)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: articles + pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
    }

    private func loadMoreInBookmarkList(from offset: Int, searching searchString: String, alreadyLoaded articles: [Article]) {
        FetchBookmarkedArticlesUseCase(offset: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: articles + pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadMoreInPostingsList(from offset: Int, searching searchString: String, alreadyLoaded articles: [Article]) {
        FetchPostedArticlesUseCase(offset: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: articles + pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadMoreInArticlesForOrganization(
        _ organizationId: Int,
        from offset: Int,
        searching searchString: String,
        alreadyLoaded articles: [Article]
    ) {
        FetchArticlesForOrganizationUseCase(organizationId: organizationId, at: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.isCurrentlyLoading = true
                case let .success(pagedArticles):
                    self?.state = .success(articles: articles + pagedArticles.results, count: pagedArticles.count, searchString: searchString)
                    self?.isCurrentlyLoading = false
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                    self?.isCurrentlyLoading = false
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
