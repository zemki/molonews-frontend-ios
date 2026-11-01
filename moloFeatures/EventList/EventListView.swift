//
//  EventListView.swift
//  EventList
//

import Assets
import Atoms
import Domain
import Molecules
import Organisms
import Strings
import SwiftUI

public struct EventListView: View {
    @Binding private var searchString: String

    @State private var showDialog = false

    private let events: [Domain.Event]
    private let totalCount: Int
    private let isDeletable: Bool
    private let execute: (EventListIntent) -> Void

    public init(
        events: [Domain.Event],
        totalCount: Int,
        searchString: Binding<String>,
        isDeletable: Bool,
        execute: @escaping (EventListIntent) -> Void
    ) {
        self.events = events
        self.totalCount = totalCount
        _searchString = searchString
        self.isDeletable = isDeletable
        self.execute = execute
    }

    private var eventScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(events.indices, id: \.self) { index in
                    let event = events[index]

                    createEventCard(event: event)
                        .overlay {
                            if isDeletable {
                                deleteOverlayForEvent(event)
                            }
                        }
                        .onAppear {
                            checkScrollingPositionAndLoadMore(index)
                        }
                        .alert(L10n.News.Molo.Posting.Delete.Alert.title, isPresented: $showDialog) {
                            Button(L10n.News.Molo.Posting.Delete.Alert.ok) {
                                execute(.onClickDeletePosting(id: event.id))
                            }
                            Button(L10n.News.Molo.Posting.Delete.Alert.cancel, role: .cancel) {
                                showDialog = false
                            }
                        } message: {
                            Text(L10n.News.Molo.Posting.Delete.Alert.message)
                        }
                }
                .padding(.vertical, .verticalDefault)
                .padding(.horizontal, .horizontalDefault)
            }
        }
        .refreshable {
            execute(.loadEvents(searchString: searchString))
        }
        .padding(0)
        .contentMargins(.bottom, .verticalScrollMarginBottom)
    }

    public var body: some View {
        eventScrollView
    }

    private func createEventCard(event: Event) -> some View {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "d. MMMM, HH:mm"

        return EventCardView(
            eventId: event.id,
            organizationId: event.organizationid,
            organizationName: event.organizationName ?? "",
            eventImageURLString: event.imageUrl,
            eventDay: dayFormatter.string(from: event.eventDate ?? Date()),
            eventDateTime: dateTimeFormatter.string(from: event.eventDate ?? Date()) + L10n.News.Molo.Events.Time.appendix,
            eventLocation: event.eventLocation ?? "",
            eventTitle: event.title,
            eventContent: event.content,
            town: event.town ?? "",
            watchedCount: event.watchedCount,
            bookmarkedCount: event.bookmarkedCount,
            isPublished: event.isPublished,
            widthFraction: .cardWidthFraction,
            detailAction: { id in
                execute(.onClickEvent(id: id))
            },
            organizationDetailAction: { organizationId in
                execute(.onClickOrganization(id: organizationId))
            }
        )
    }

    private func deleteOverlayForEvent(_ event: Event) -> some View {
        HStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                Button {
                    showDialog = true
                }
                label: {
                    Image(systemName: "trash.circle")
                        .resizable()
                        .foregroundStyle(Colors.Icons.button.swiftUIColor)
                        .frame(width: .iconButtonSize, height: .iconButtonSize)
                        .padding(.verticalDefault)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusSmall))
                }

                Spacer()
            }
        }
        .padding(.vertical, .verticalXLarge)
        .padding(.horizontal, .horizontalLarge)
    }

    private func checkScrollingPositionAndLoadMore(_ index: Int) {
        if index >= events.count - 5, totalCount > events.count {
            execute(.loadMoreEvents(offset: events.count))
        }
    }
}
