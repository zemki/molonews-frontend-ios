//
//  ExploreViewModel.swift
//  Explore
//

import ArticleList
import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class ExploreViewModel: ObservableObject {
    @Published private(set) var state: ArticleListState = .idle
    @Published var searchString: String = ""

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private let articleListViewModel = ArticleListViewModel(listType: .search)

    public init() {
        articleListViewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articleListState in
                self?.state = articleListState
            }
            .store(in: &cancellables)
    }

    func executeIntent(_ intent: ArticleListIntent) {
        switch intent {
        case let .loadArticles(searchString, _):
            articleListViewModel.loadArticles(searchString: searchString)
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
}
