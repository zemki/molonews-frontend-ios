//
//  EventsViewModel.swift
//  Events
//

import Combine
import Domain
import EventCategoryList
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class EventsViewModel: ObservableObject {
    @Published private(set) var state: EventCategoryListState = .idle

    @Published var startDate: Date?
    @Published var endDate: Date?

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private let eventCategoryListViewModel = EventCategoryListViewModel()

    public init() {
        eventCategoryListViewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] eventCategoryListState in
                self?.state = eventCategoryListState
            }
            .store(in: &cancellables)
    }

    func executeIntent(_ intent: EventCategoryListIntent) {
        switch intent {
        case let .loadEventCategories(searchString):
            eventCategoryListViewModel.loadCategories(startDate: startDate, endDate: endDate, searchString: searchString)
        case let .loadMoreEventsForCategory(id, offset, searchString):
            eventCategoryListViewModel.loadMoreEventsFor(categoryId: id, startDate: startDate, endDate: endDate, from: offset, searchString: searchString)
        case let .onClickEvent(id):
            coordinator?.showSheet(Coordinator.SheetRoute.eventDetail(id: id))
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: false))
        case let .pullToRefresh(searchString):
            eventCategoryListViewModel.loadCategories(startDate: startDate, endDate: endDate, searchString: searchString)
        }
    }
}
