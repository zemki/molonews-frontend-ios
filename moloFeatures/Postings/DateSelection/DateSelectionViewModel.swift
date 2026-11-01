//
//  DateSelectionViewModel.swift
//  Postings
//

import Combine
import Domain
import EventCategoryList
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class DateSelectionViewModel: ObservableObject {
    @Published private(set) var state: DateSelectionState = .idle

    private let startDate: Date?
    private let endDate: Date?

    private let dateSelectionCallback: (Date, Date) -> Void

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    public init(startDate: Date?, endDate: Date?, dateSelectionCallback: @escaping (Date, Date) -> Void) {
        self.startDate = startDate
        self.endDate = endDate
        self.dateSelectionCallback = dateSelectionCallback
    }

    func executeIntent(_ intent: DateSelectionIntent) {
        switch intent {
        case .willAppear:
            state = .success(start: startDate, end: endDate)
        case let .onDateSelectionSubmit(start, end):
            dateSelectionCallback(start, end)
            coordinator?.back(on: nil)
        case .onDateSelectionCancel:
            coordinator?.back(on: nil)
        }
    }
}
