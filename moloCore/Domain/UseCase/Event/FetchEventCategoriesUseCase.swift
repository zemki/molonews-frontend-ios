//
//  FetchEventCategoriesUseCase.swift
//  moloCore
//

import Combine
import FactoryKit
import Foundation

public class FetchEventCategoriesUseCase: BaseUseCaseExecuter<[Category]>, UseCaseExecuter {
    @Injected(\.eventsRepository) private var eventsRepository: EventRepositoryType?

    private let searchString: String
    private let offset: Int
    private let limit: Int
    private let startDate: Date?
    private let endDate: Date?

    public init(
        searchString: String,
        offset: Int = 0,
        limit: Int = 10,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.searchString = searchString
        self.offset = offset
        self.limit = limit
        self.startDate = startDate
        self.endDate = endDate
    }

    override func execute(with deviceId: String) async throws -> Result<[Category], RepositoryError> {
        guard let repository = eventsRepository else {
            throw RepositoryError.diError
        }

        let categoryResult = try await repository.fetchCategories(
            for: deviceId,
            dateStart: startDate,
            dateEnd: endDate,
            searchString: searchString.isEmpty ? nil : searchString
        )

        guard case let .success(categories) = categoryResult else {
            return categoryResult
        }

        var enrichedCategories: [Category] = []
        try await withThrowingTaskGroup(of: Category?.self) { group in
            for var category in categories {
                guard let categoryId = category.id else {
                    continue
                }

                group.addTask {
                    let eventsResult = try await repository.fetchEventsByCategory(
                        for: deviceId,
                        dateStart: self.startDate,
                        dateEnd: self.endDate,
                        categoryId: categoryId,
                        offset: self.offset,
                        limit: self.limit,
                        searchString: self.searchString.isEmpty ? nil : self.searchString
                    )

                    switch eventsResult {
                    case let .success(pagedEvents):
                        category.events = pagedEvents.results
                        category.eventCount = pagedEvents.count
                        return category
                    case .failure:
                        return nil
                    }
                }
            }

            for try await enrichedCategory in group {
                if let cat = enrichedCategory {
                    enrichedCategories.append(cat)
                }
            }
        }

        enrichedCategories.sort { ($0.order ?? 0) < ($1.order ?? 0) }

        return .success(enrichedCategories)
    }
}
