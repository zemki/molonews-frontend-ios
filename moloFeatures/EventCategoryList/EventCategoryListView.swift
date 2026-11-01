//
//  EventCategoryListView.swift
//  EventList
//

import Assets
import Atoms
import Domain
import Molecules
import Organisms
import Strings
import SwiftUI

public struct EventCategoryListView: View {
    @Binding private var isOverlayHidden: Bool
    @State private var scrollOffset: CGFloat = 0

    private let hideThreshold: CGFloat = 50

    private let categories: [Domain.Category]
    private let searchString: String
    private let execute: (EventCategoryListIntent) -> Void

    public init(
        categories: [Domain.Category],
        searchString: String,
        isOverlayHidden: Binding<Bool>,
        execute: @escaping (EventCategoryListIntent) -> Void
    ) {
        self.categories = categories
        self.searchString = searchString
        _isOverlayHidden = isOverlayHidden
        self.execute = execute
    }

    private var offsetReader: some View {
        GeometryReader { geo in
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: geo.frame(in: .global).minY
                )
        }
        .frame(height: 1)
        .onPreferenceChange(ScrollOffsetKey.self) {
            scrollOffset = $0
        }
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
                offsetReader

                ForEach(categories.indices, id: \.self) { index in
                    let category = categories[index]

                    if category.eventCount > 0, !category.events.isEmpty {
                        VStack {
                            HStack {
                                Text(category.name)
                                    .font(.moloSubheading)
                                    .lineLimit(1)
                                    .foregroundStyle(Colors.Text.default.swiftUIColor)
                                    .padding(.leading, .horizontalDefault)
                                Spacer()
                            }

                            HorizontalEventListView(
                                events: category.events,
                                searchString: searchString,
                                totalCount: category.eventCount,
                                categoryId: category.id ?? 0,
                                execute: execute
                            )
                        }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .onChange(of: scrollOffset) {
            let shouldHide = scrollOffset < hideThreshold
            if shouldHide != isOverlayHidden {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isOverlayHidden = shouldHide
                }
            }
        }
        .refreshable {
            execute(.loadEventCategories(searchString: searchString))
        }
        .safeAreaInset(edge: .top) {
            Spacer()
                .frame(height: 66)
        }
    }
}

private struct HorizontalEventListView: View {
    private let events: [Event]
    private let searchString: String
    private let totalCount: Int
    private let categoryId: Int
    private let execute: (EventCategoryListIntent) -> Void

    init(events: [Event], searchString: String, totalCount: Int, categoryId: Int, execute: @escaping (EventCategoryListIntent) -> Void) {
        self.events = events
        self.searchString = searchString
        self.totalCount = totalCount
        self.categoryId = categoryId
        self.execute = execute
    }

    var body: some View {
        if events.isEmpty {
            Text(L10n.News.Molo.Event.Category.empty)
                .font(.footnote)
                .lineLimit(1)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .padding(.horizontalDefault)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(events.indices, id: \.self) { index in
                        let event = events[index]

                        createEventCard(event: event)
                            .padding(.vertical, .verticalDefault)
                            .padding(.leading, .horizontalDefault)
                            .onAppear {
                                checkScrollingPositionAndLoadMore(index)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .padding(0)
        }
    }

    private func createEventCard(event: Event) -> some View {
        return EventCardView(
            eventId: event.id,
            organizationId: event.organizationid,
            organizationName: event.organizationName ?? "",
            eventImageURLString: event.imageUrl,
            eventDay: event.eventDate?.formatted(.germanWeekday) ?? "",
            eventDateTime: event.eventDate?.formatGermanOmittingTimeIfMidnight() ?? "",
            eventLocation: event.eventLocation ?? "",
            eventTitle: event.title,
            eventContent: event.content,
            town: event.town ?? "",
            watchedCount: event.watchedCount,
            bookmarkedCount: event.bookmarkedCount,
            isPublished: event.isPublished,
            widthFraction: 0.8,
            detailAction: { eventId in
                execute(.onClickEvent(id: eventId))
            },
            organizationDetailAction: { organizationId in
                execute(.onClickOrganization(id: organizationId))
            }
        )
    }

    private func checkScrollingPositionAndLoadMore(_ index: Int) {
        if index >= events.count - 5, totalCount > events.count {
            execute(.loadMoreEventsForCategory(id: categoryId, offset: events.count, searchString: searchString))
        }
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
