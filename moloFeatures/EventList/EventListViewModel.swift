//
//  EventListViewModel.swift
//  EventList
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class EventListViewModel: ObservableObject {
    @Published public var state: EventListState = .idle

    public enum ListType {
        case watchlist,
             organization(id: Int),
             postings,
             search
    }

    private let listType: ListType

    private var cancellables = Set<AnyCancellable>()

    private var isCurrentlyLoading: Bool = false

    public init(listType: ListType) {
        self.listType = listType
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

                self.loadEvents()
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

                self.loadEvents()
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

                self.loadEvents()
            }
            .store(in: &cancellables)
    }

    public func loadEvents(searchString: String = "") {
        switch listType {
        case .watchlist:
            return loadWatchlistEvents()
        case let .organization(id):
            return loadEventsForOrganization(id)
        case .postings:
            return loadPostedEvents()
        case .search:
            return loadSearchEvents(query: searchString)
        }
    }

    private func loadSearchEvents(query: String) {
        FetchEventsUseCase(query: query)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                    self?.isCurrentlyLoading = true
                case let .success(pagedEvents):
                    self?.state = .success(events: pagedEvents.results, count: pagedEvents.count, searchString: query)
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

    private func loadWatchlistEvents() {
        FetchBookmarkedEventsUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                    self?.isCurrentlyLoading = true
                case let .success(pagedEvents):
                    self?.state = .success(events: pagedEvents.results, count: pagedEvents.count, searchString: "")
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

    private func loadPostedEvents() {
        FetchPostedEventsUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                    self?.isCurrentlyLoading = true
                case let .success(pagedEvents):
                    self?.state = .success(events: pagedEvents.results, count: pagedEvents.count, searchString: "")
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

    private func loadEventsForOrganization(_ organizationId: Int) {
        FetchEventsForOrganizationUseCase(organizationId: organizationId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                    self?.isCurrentlyLoading = true
                case let .success(pagedEvents):
                    self?.state = .success(events: pagedEvents.results, count: pagedEvents.count, searchString: "")
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

    public func loadMoreEvents(from offset: Int) {
        switch listType {
        case .watchlist:
            return loadMoreWatchlistEvents(from: offset)
        case let .organization(id):
            return loadMoreEventsForOrganization(id, from: offset)
        case .postings:
            return loadMorePostedEvents(from: offset)
        case .search:
            return loadMoreSearchEvents(from: offset)
        }
    }

    private func loadMoreSearchEvents(from offset: Int) {
        guard case let .success(events, _, searchString) = state else {
            return
        }

        FetchEventsUseCase(query: searchString, offset: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(pagedEvents):
                    self?.state = .success(events: events + pagedEvents.results, count: pagedEvents.count, searchString: searchString)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadMoreWatchlistEvents(from offset: Int) {
        guard case let .success(events, _, _) = state else {
            return
        }

        FetchBookmarkedEventsUseCase(offset: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(pagedEvents):
                    self?.state = .success(events: events + pagedEvents.results, count: pagedEvents.count, searchString: "")
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadMorePostedEvents(from offset: Int) {
        guard case let .success(events, _, _) = state else {
            return
        }

        FetchPostedEventsUseCase(offset: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(pagedEvents):
                    self?.state = .success(events: events + pagedEvents.results, count: pagedEvents.count, searchString: "")
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadMoreEventsForOrganization(_ organizationId: Int, from offset: Int) {
        guard case let .success(events, _, _) = state else {
            return
        }

        FetchEventsForOrganizationUseCase(organizationId: organizationId, at: offset)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(pagedEvents):
                    self?.state = .success(events: events + pagedEvents.results, count: pagedEvents.count, searchString: "")
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
