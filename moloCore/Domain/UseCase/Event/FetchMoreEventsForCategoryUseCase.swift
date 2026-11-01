//
//  FetchEventsByCategoryUseCase.swift
//  moloCore
//

import Combine
import FactoryKit
import Foundation

public class FetchMoreEventsForCategoryUseCase: BaseUseCaseExecuter<PagedEvents>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventsRepository: EventRepositoryType?

    private let searchString: String
    private let offset: Int
    private let limit: Int
    private let startDate: Date?
    private let endDate: Date?
    private let categoryId: Int

    public init(
        searchString: String,
        offset: Int = 0,
        limit: Int = 10,
        startDate: Date? = nil,
        endDate: Date? = nil,
        categoryId: Int = 0
    ) {
        self.searchString = searchString
        self.offset = offset
        self.limit = limit
        self.startDate = startDate
        self.endDate = endDate
        self.categoryId = categoryId
    }

    override func execute(with deviceId: String) async throws -> Result<PagedEvents, RepositoryError> {
        guard let eventsRepository else {
            throw RepositoryError.diError
        }

        return try await eventsRepository.fetchEventsByCategory(
            for: deviceId,
            dateStart: startDate,
            dateEnd: endDate,
            categoryId: categoryId,
            offset: offset,
            limit: limit,
            searchString: searchString.isEmpty ? nil : searchString
        )
    }
}
