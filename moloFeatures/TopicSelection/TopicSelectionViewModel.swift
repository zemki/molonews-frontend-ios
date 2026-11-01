//
//  TopicSelectionViewModel.swift
//  Account
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class TopicSelectionViewModel: ObservableObject {
    @Published private(set) var state: TopicSelectionState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private let storingTimeoutInMillisenconds = 750
    private let articleSelectionChangedSubject = PassthroughSubject<Void, Never>()
    private let eventSelectionChangedSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    public init() {
        articleSelectionChangedSubject
            .debounce(for: .milliseconds(storingTimeoutInMillisenconds), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storeArticleTagSelection()
            }
            .store(in: &cancellables)

        eventSelectionChangedSubject
            .debounce(for: .milliseconds(storingTimeoutInMillisenconds), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storeEventTagSelection()
            }
            .store(in: &cancellables)
    }

    func executeIntent(_ intent: TopicSelectionIntent) {
        switch intent {
        case .loadSelection:
            loadArticleTags()
            loadEventTags()
        case let .toggleArticleTopic(id, categoryId):
            toggleArticleTopic(id: id, in: categoryId)
        case let .toggleEventTopic(id, categoryId):
            toggleEventTopic(id: id, in: categoryId)
        case .onClickBack:
            coordinator?.back(on: nil)
        }
    }

    private func toggleArticleTopic(id: Int, in categoryId: Int) {
        guard
            case .success(var articleCategories, let eventCategories) = state,
            let categoryIndex = articleCategories.firstIndex(
                where: { category in
                    category.id == categoryId
                }
            ),
            let tagIndex = articleCategories[categoryIndex].tags.firstIndex(
                where: { tag in
                    tag.id == id
                }
            ) else {
            return
        }

        var tag = articleCategories[categoryIndex].tags[tagIndex]
        tag.isSelected.toggle()

        articleCategories[categoryIndex].tags[tagIndex] = tag
        articleSelectionChangedSubject.send(())

        state = .success(articleCategories: articleCategories, eventCategories: eventCategories)
    }

    private func toggleEventTopic(id: Int, in categoryId: Int) {
        guard
            case .success(let articleCategories, var eventCategories) = state,
            let categoryIndex = eventCategories.firstIndex(
                where: { category in
                    category.id == categoryId
                }
            ),
            let tagIndex = eventCategories[categoryIndex].tags.firstIndex(
                where: { tag in
                    tag.id == id
                }
            ) else {
            return
        }

        var tag = eventCategories[categoryIndex].tags[tagIndex]
        tag.isSelected.toggle()

        eventCategories[categoryIndex].tags[tagIndex] = tag
        eventSelectionChangedSubject.send(())

        state = .success(articleCategories: articleCategories, eventCategories: eventCategories)
    }

    private func loadArticleTags() {
        FetchTagSelectionUseCase(tagType: .article)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(categories):
                    if case let .success(_, eventCategories) = self?.state {
                        self?.state = .success(articleCategories: categories, eventCategories: eventCategories)
                    } else {
                        self?.state = .success(articleCategories: categories, eventCategories: [])
                    }
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                }
            }
            .store(in: &cancellables)
    }

    private func loadEventTags() {
        FetchTagSelectionUseCase(tagType: .event)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(categories):
                    if case let .success(articleCategories, _) = self?.state {
                        self?.state = .success(articleCategories: articleCategories, eventCategories: categories)
                    } else {
                        self?.state = .success(articleCategories: [], eventCategories: categories)
                    }
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                }
            }
            .store(in: &cancellables)
    }

    private func storeArticleTagSelection() {
        guard case let .success(articleCategories, eventCategories) = state else {
            return
        }

        let selectedTags = articleCategories.flatMap { category in
            category.tags.compactMap { tag in
                tag.isSelected ? tag.id : nil
            }
        }

        StoreTagSelectionUseCase(tagType: .article, selectedTags: selectedTags)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success:
                    self?.state = .success(articleCategories: articleCategories, eventCategories: eventCategories)
                    NotificationCenter.default.post(name: .articleTagsChangedNotification, object: articleCategories)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func storeEventTagSelection() {
        guard case let .success(articleCategories, eventCategories) = state else {
            return
        }

        let selectedTags = eventCategories.flatMap { category in
            category.tags.compactMap { tag in
                tag.isSelected ? tag.id : nil
            }
        }

        StoreTagSelectionUseCase(tagType: .event, selectedTags: selectedTags)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success:
                    self?.state = .success(articleCategories: articleCategories, eventCategories: eventCategories)
                    NotificationCenter.default.post(name: .eventTagsChangedNotification, object: eventCategories)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
