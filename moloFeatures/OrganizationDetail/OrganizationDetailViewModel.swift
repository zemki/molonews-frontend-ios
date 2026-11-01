//
//  OrganizationDetailViewModel.swift
//  OrganizationDetail
//

import ArticleList
import Combine
import Domain
import EventList
import FactoryKit
import Foundation
import Routing
import Strings
import SwiftUI

@MainActor
public final class OrganizationDetailViewModel: ObservableObject {
    @Published private(set) var state: OrganizationDetailState = .idle
    @Published private(set) var articleListState: ArticleListState = .idle
    @Published private(set) var eventListState: EventListState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private let articleListViewModel: ArticleListViewModel
    private let eventListViewModel: EventListViewModel

    private var cancellables = Set<AnyCancellable>()

    private let organizationId: Int
    private let isUserAsOrganization: Bool

    public init(organizationId: Int) {
        self.organizationId = organizationId
        isUserAsOrganization = Container.shared.userProfile()?.organizationId == organizationId
        articleListViewModel = ArticleListViewModel(listType: isUserAsOrganization ? .postings : .organization(id: organizationId))
        eventListViewModel = EventListViewModel(listType: isUserAsOrganization ? .postings : .organization(id: organizationId))

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

    func executeIntent(_ intent: OrganizationDetailIntent) {
        switch intent {
        case .onClickBack:
            coordinator?.back(on: nil)
        case .onClickEditProfile:
            coordinator?.showSheet(
                .editUserProfile(callback: { [weak self] in
                    self?.loadOrganization()
                }),
                stacked: true
            )
        }
    }

    func loadOrganization() {
        FetchOrganizationUseCase(id: organizationId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(organization):
                    guard let self else {
                        return
                    }
                    self.state = .success(organization: organization, isUserAsOrganization: self.isUserAsOrganization)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
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
            if isUserAsOrganization {
                coordinator?.showSheet(.postArticle(id: id), stacked: true)
            } else {
                coordinator?.showSheet(Coordinator.SheetRoute.articleDetail(id: id))
            }
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: true))
        case let .onClickDeletePosting(id: id):
            deleteArticlePosting(id)
        }
    }

    func executeEventIntent(_ intent: EventListIntent) {
        switch intent {
        case .loadEvents:
            eventListViewModel.loadEvents()
        case let .loadMoreEvents(offset):
            eventListViewModel.loadMoreEvents(from: offset)
        case let .onClickEvent(id):
            if isUserAsOrganization {
                coordinator?.showSheet(.postEvent(id: id), stacked: true)
            } else {
                coordinator?.showSheet(Coordinator.SheetRoute.eventDetail(id: id))
            }
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: false))
        case .pullToRefresh:
            eventListViewModel.loadEvents()
        case let .onClickDeletePosting(id: id):
            deleteEventPosting(id)
        }
    }

    private func deleteArticlePosting(_ id: Int) {
        guard case .success(var articles, let count, let searchString) = articleListState,
              let articleIndex = articles.firstIndex(where: { article in
                  article.id == id
              })
        else {
            return
        }

        DeletePostedArticleUseCase(articleId: id)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    articles.remove(at: articleIndex)
                    self?.articleListState = .success(articles: articles, count: count, searchString: searchString)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func deleteEventPosting(_ id: Int) {
        guard case .success(var events, let count, let searchString) = eventListState,
              let eventIndex = events.firstIndex(where: { event in
                  event.id == id
              })
        else {
            return
        }

        DeletePostedEventUseCase(eventId: id)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    events.remove(at: eventIndex)
                    self?.eventListState = .success(events: events, count: count, searchString: searchString)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
