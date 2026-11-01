//
//  ArticleDetailViewModel.swift
//  Explore
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class ArticleDetailViewModel: ObservableObject {
    @Published private(set) var state: ArticleDetailState = .idle

    @Published var showShareIntent: Bool = false
    @Published var showMoreMenu: Bool = false

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private let articleId: Int

    public init(articleId: Int) {
        self.articleId = articleId
    }
    
    func executeIntent(_ intent: ArticleDetailIntent) {
        switch intent {
        case .loadArticle:
            loadArticle()
        case .onClickBack:
            coordinator?.back(on: nil)
        case .onClickShare:
            toggleShareIntent()
        case .onClickBookmark:
            toggleBookmark()
        case .onClickMore:
            toggleMoreMenu()
        case .onClickReport:
            reportArticle()
        }
    }

    private func loadArticle() {
        FetchArticleUseCase(articleId: articleId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(article):
                    self?.state = .success(article: article)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func toggleShareIntent() {
        showShareIntent = true
    }

    private func toggleBookmark() {
        guard case var .success(article) = state else {
            loadArticle()
            return
        }

        ToggleBookmarkArticleUseCase(articleId: articleId, isBookmarked: article.bookmarked)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    article.bookmarked = !article.bookmarked
                    self?.state = .success(article: article)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func toggleMoreMenu() {
        showMoreMenu.toggle()
    }

    private func reportArticle() {
        guard case let .success(article) = state else {
            loadArticle()
            return
        }

        ReportArticleUseCase(articleId: articleId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    NotificationCenter.default.post(name: .articleReportedNotification, object: article)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
