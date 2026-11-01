//
//  ArticlePostingViewModel.swift
//  Postings
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class ArticlePostingViewModel: ObservableObject {
    @Published private(set) var state: ArticlePostingState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private var article: PostingArticle = .init()

    private let tagCategoriesLoadedPublisher = PassthroughSubject<Void, Never>()
    private let tagSelectionLoadedPublisher = PassthroughSubject<Void, Never>()

    public init(articleId: Int?) {
        article.userProfile = Container.shared.userProfile() ?? UserProfile()
        article.id = articleId
    }

    func executeIntent(_ intent: ArticlePostingIntent) {
        switch intent {
        case .willAppear:
            if let articleId = article.id {
                loadArticle(id: articleId)
            } else {
                navigateToTitleAndDescription()
            }
        case let .onClickToDetails(title, description):
            observeDetailLoadingSuccess()
            setupDetails(title: title, description: description)
        case .onClickToPreview:
            navigateToPreview()
        case .onClickPrevious:
            switch state {
            case .idle,
                 .loading,
                 .firstStep:
                break
            case .secondStep:
                navigateToTitleAndDescription()
            case .previewStep:
                navigateToDetails()
            }
        case let .onImageSelected(data, filename):
            article.imageData = data
            article.imageFilename = filename
        case let .onImageSourceSet(name):
            article.imageSource = name
        case let .storeArticleData(link, tags):
            article.link = link
            article.tags = tags
        case let .onClickSubmit(asDraft):
            article.published = !asDraft
            if article.id != nil {
                updateArticle()
            } else {
                postArticle()
            }
        case .onClose:
            coordinator?.back(on: nil)
        }
    }

    private func setupDetails(title: String, description: String) {
        article.title = title
        article.content = description

        if article.categories.isEmpty {
            loadArticleTagCategories()
        } else {
            tagCategoriesLoadedPublisher.send(())
        }

        if article.tags.isEmpty {
            loadSelectedTags(title: article.title, content: article.content)
        } else {
            tagSelectionLoadedPublisher.send(())
        }
    }

    private func navigateToTitleAndDescription() {
        state = .firstStep(article: article)
    }

    private func navigateToDetails() {
        var categories = article.categories
        for catIndex in categories.indices {
            for index in categories[catIndex].tags.indices {
                categories[catIndex].tags[index].isSelected = article.tags.contains(categories[catIndex].tags[index].id)
            }
        }
        article.categories = categories

        state = .secondStep(article: article)
    }

    private func navigateToPreview() {
        state = .previewStep(article: article)
    }

    private func loadArticle(id: Int) {
        FetchArticleUseCase(articleId: id)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(article):
                    self?.article = article.toArticlePosting()
                    self?.article.userProfile = Container.shared.userProfile() ?? UserProfile()
                    self?.navigateToTitleAndDescription()
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    func observeDetailLoadingSuccess() {
        Publishers.CombineLatest(tagCategoriesLoadedPublisher, tagSelectionLoadedPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigateToDetails()
            }
            .store(in: &cancellables)
    }

    private func loadArticleTagCategories() {
        FetchTagSelectionUseCase(tagType: .article)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(categories):
                    self?.article.categories = categories
                    self?.tagCategoriesLoadedPublisher.send(())
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadSelectedTags(title: String, content: String) {
        GetTagPostingPreselectionUseCase(tagType: .article, title: title, content: content)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(tags):
                    self?.article.tags = Set(
                        tags.map { tag in
                            tag.id
                        }
                    )
                    self?.tagSelectionLoadedPublisher.send(())
                case let .error(useCaseError):
                    self?.tagSelectionLoadedPublisher.send(())
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func postArticle() {
        PostArticleUseCase(article: article)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(id):
                    self?.article.id = id
                    if self?.article.imageData != nil {
                        self?.uploadImage()
                    } else {
                        NotificationCenter.default.post(name: .articlePostedNotification, object: nil)
                        self?.coordinator?.back(on: nil)
                    }
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    self.state = .previewStep(article: self.article)
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func updateArticle() {
        UpdateArticleUseCase(article: article)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    if self?.article.imageData != nil {
                        self?.uploadImage()
                    } else {
                        self?.coordinator?.back(on: nil)
                    }
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    self.state = .previewStep(article: self.article)
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func uploadImage() {
        guard let articleId = article.id,
              let data = article.imageData else {
            return
        }

        UploadArticleImageUseCase(articleId: articleId, file: data, filename: article.imageFilename, source: article.imageSource)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    NotificationCenter.default.post(name: .articlePostedNotification, object: nil)
                    self?.coordinator?.back(on: nil)
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    self.state = .previewStep(article: self.article)
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
