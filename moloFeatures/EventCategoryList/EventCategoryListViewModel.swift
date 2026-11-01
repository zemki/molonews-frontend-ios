//
//  EventCategoryListViewModel.swift
//  EventList
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class EventCategoryListViewModel: ObservableObject {
    @Published public var state: EventCategoryListState = .idle

    private var cancellables = Set<AnyCancellable>()

    private var isCurrentlyLoading: Bool = false

    public init() {
        handleLocationChangedNotification()
        handleEventTagsChangedNotification()
        handleNewEventPostedNotification()
    }

    private func handleLocationChangedNotification() {
        NotificationCenter.default
            .publisher(for: .locationChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.loadCategories(searchString: "")
            }
            .store(in: &cancellables)
    }

    private func handleEventTagsChangedNotification() {
        NotificationCenter.default
            .publisher(for: .eventTagsChangedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.loadCategories(searchString: "")
            }
            .store(in: &cancellables)
    }

    private func handleNewEventPostedNotification() {
        NotificationCenter.default
            .publisher(for: .eventPostedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.loadCategories(searchString: "")
            }
            .store(in: &cancellables)
    }

    public func loadCategories(startDate: Date? = nil, endDate: Date? = nil, searchString: String) {
        FetchEventCategoriesUseCase(searchString: searchString, startDate: startDate, endDate: endDate)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                    self?.isCurrentlyLoading = true
                case let .success(categories):
                    self?.state = .success(categories: categories, searchString: searchString)
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

    public func loadMoreEventsFor(
        categoryId: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        from offset: Int = 0,
        searchString: String
    ) {
        guard case .success(var categories, let searchString) = state else {
            return
        }

        FetchMoreEventsForCategoryUseCase(searchString: searchString, offset: offset, startDate: startDate, endDate: endDate, categoryId: categoryId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(pagedEvents):
                    if let index = categories.firstIndex(where: { $0.id == categoryId }) {
                        categories[index].events.append(contentsOf: pagedEvents.results)
                    }

                    self?.state = .success(categories: categories, searchString: searchString)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
