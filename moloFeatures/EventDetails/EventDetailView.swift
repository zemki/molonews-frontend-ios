//
//  ArticleDetailView.swift
//  Explore
//

import Assets
import Atoms
import Dimensions
import Domain
import EventKit
import Flow
import Kingfisher
import MapKit
import Molecules
import Strings
import SwiftUI

public struct EventDetailView: View {
    @ObservedObject var viewModel: EventDetailViewModel

    public init(viewModel: EventDetailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(event):
                EventDetailPage(
                    event: event,
                    execute: viewModel.executeIntent(_:),
                    showShare: $viewModel.showShareIntent,
                    showMoreMenu: $viewModel.showMoreMenu,
                    showEventEditor: $viewModel.showEventEditor
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.loadEventDetails)
        }
        .padding(0)
    }
}

private struct EventDetailPage: View {
    private let imageHeight: CGFloat = 200

    private let content: LocalizedStringKey
    private let event: Event
    private let execute: (EventDetailIntent) -> Void
    private var location: CLLocationCoordinate2D?

    @Binding private var showShare: Bool
    @Binding private var showMoreMenu: Bool
    @Binding private var showEventEditor: Bool

    init(
        event: Event,
        execute: @escaping (EventDetailIntent) -> Void,
        showShare: Binding<Bool>,
        showMoreMenu: Binding<Bool>,
        showEventEditor: Binding<Bool>
    ) {
        self.event = event
        content = LocalizedStringKey(event.content)
        self.execute = execute
        if let latitude = event.latitude, let longitude = event.longitude {
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        _showShare = showShare
        _showMoreMenu = showMoreMenu
        _showEventEditor = showEventEditor
    }

    private var eventDateAndLocationView: some View {
        VStack(alignment: .leading, spacing: .verticalDefault) {
            IconWithBoldAndRegularText(
                icon: Assets.Icons.Event.calendar.swiftUIImage,
                boldText: event.eventDate?.formatted(.germanWeekday),
                regularText: event.eventDate?.formatGermanOmittingTimeIfMidnight(),
                iconColor: Colors.Icons.eventCard.swiftUIColor,
                textColor: Colors.Text.default.swiftUIColor
            )

            IconWithBoldAndRegularText(
                icon: Assets.Icons.Event.pin.swiftUIImage,
                boldText: event.eventLocation,
                regularText: event.town,
                iconColor: Colors.Icons.eventCard.swiftUIColor,
                textColor: Colors.Text.default.swiftUIColor
            )
        }
        .padding(.horizontal, .horizontalSmall)
        .padding(.vertical, .verticalSmall)
    }

    private var shareSheet: some View {
        ShareSheet(activityItems: [
            L10n.News.Molo.Share.event(event.title, event.link ?? "") + L10n.News.Molo.Share.links
        ])
    }

    private var topImageStack: some View {
        VStack(spacing: .verticalSmall) {
            CardImage(imageUrlString: event.imageUrl, imageHeight: imageHeight)

            if let source = event.imageSource {
                HStack {
                    Spacer()

                    Text("© " + source)
                        .font(.moloFooterLight)
                        .foregroundStyle(Colors.Text.default80.swiftUIColor)
                }
                .padding(.trailing, .horizontalDefault)
            }
        }
    }

    private var titleDescriptionAndLinksStack: some View {
        VStack(alignment: .leading, spacing: .verticalDefault) {
            if let ticketUrl = event.ticketUrl, !ticketUrl.isEmpty {
                HStack {
                    Spacer()
                    ticketsLink(ticketUrl)
                        .padding(.bottom, .verticalDefault)
                    Spacer()
                }
            }

            Text(event.title)
                .font(.moloTitleSmall)
                .foregroundStyle(Colors.Text.default.swiftUIColor)

            Text(content)
                .font(.moloSubtitleRegular)
                .foregroundStyle(Colors.Text.default.swiftUIColor)

            if let link = event.link, !link.isEmpty {
                websiteLink(link)
            }
        }
    }

    private var dateAndLocationStack: some View {
        VStack(alignment: .leading, spacing: .verticalDefault) {
            Text(L10n.News.Molo.Event.Detail.subheader)
                .font(.moloTitleDefault)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .padding(.top, .verticalLarge)

            eventDateAndLocationView

            if let location, !location.latitude.isZero, !location.longitude.isZero {
                locationMap(location)
            }
        }
    }

    private var organizationAndTagsStack: some View {
        VStack(alignment: .leading, spacing: .verticalDefault) {
            if let name = event.organizationName {
                organizationCard(name: name)
            }

            HFlow {
                ForEach(event.tags, id: \.id) { item in
                    Chip(title: item.name, isSelected: .constant(true))
                }
            }
        }
    }

    var detailTopNavigation: some ToolbarContent {
        DetailTopNavigation(
            backAction: { execute(.onClickBack) },
            actions: [
                (
                    icon: Assets.Icons.Navigation.share.swiftUIImage,
                    toggledIcon: nil,
                    isToggled: nil,
                    onClick: {
                        execute(.onClickShare)
                    }
                ),
                (
                    icon: Assets.Icons.Navigation.bookmark.swiftUIImage,
                    toggledIcon: Assets.Icons.Navigation.bookmarked.swiftUIImage,
                    isToggled: event.bookmarked,
                    onClick: {
                        execute(.onClickBookmark)
                    }
                )
            ],
            moreMenuTitleAndActions: [
                (L10n.News.Molo.Report.event, { execute(.onClickReport) }),
                (L10n.News.Molo.Event.save, { execute(.onClickSaveInCalendar) })
            ]
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .verticalLarge) {
                topImageStack

                VStack(spacing: 0) {
                    titleDescriptionAndLinksStack
                    dateAndLocationStack
                    organizationAndTagsStack
                }
                .padding(.horizontal, .horizontalDefault)
            }
            .sheet(isPresented: $showShare) {
                shareSheet
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showEventEditor) {
                let eventStore = EKEventStore()
                let newEvent = EKEvent(eventStore: eventStore)

                newEvent.title = event.title
                newEvent.startDate = event.eventStartDate ?? Date()
                newEvent.endDate = event.eventEndDate ?? Calendar.current.date(byAdding: .hour, value: 1, to: newEvent.startDate)
                newEvent.notes = event.abstract
                newEvent.calendar = eventStore.defaultCalendarForNewEvents

                return EventEditView(eventStore: eventStore, event: newEvent)
            }
            .toolbar {
                detailTopNavigation
            }
            .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .clipped()
    }

    private func ticketsLink(_ urlString: String) -> some View {
        Button(action: {
            execute(.onClickTickets(url: urlString))
        }) {
            HStack {
                Text(L10n.News.Molo.Event.Detail.tickets)
                    .foregroundStyle(Colors.Text.menuItem.swiftUIColor)
                    .font(.moloSubtitleRegular)
                    .frame(height: .buttonHeight)
                Assets.Icons.Event.ticket.swiftUIImage
                    .frame(height: .buttonHeight)
                    .padding(.leading, .horizontalSmall)
            }
            .padding(.horizontal, .horizontalLarge)
            .background(Colors.Background.primary.swiftUIColor)
            .clipShape(.rect(cornerRadius: .cornerRadiusSmall))
        }
    }

    private func websiteLink(_ urlString: String) -> some View {
        Button(action: {
            execute(.onClickWebsite(url: urlString))
        }) {
            Text(L10n.News.Molo.Event.Detail.website)
                .foregroundStyle(Colors.Text.tabbarSelected.swiftUIColor)
                .font(.moloSubtitleRegular)
                .frame(maxHeight: .buttonHeight)
        }
    }

    private func locationMap(_ location: CLLocationCoordinate2D) -> some View {
        LocationMap(location: location) {
            execute(.onClickMap(lat: location.latitude, long: location.longitude, title: event.title))
        }
    }

    private func organizationCard(name: String) -> some View {
        OrganizationCard(
            imageUrl: event.organizationLogoUrlString ?? event.imageUrl,
            organizationName: name,
            location: event.eventLocation ?? ""
        )
        .padding(.vertical, .verticalDefault)
        .onTapGesture {
            execute(.onClickOrganization(id: event.organizationid))
        }
    }
}

#Preview("light") {
    EventDetailPage(
        event: Event.mock,
        execute: { _ in },
        showShare: Binding.constant(false),
        showMoreMenu: Binding.constant(false),
        showEventEditor: Binding.constant(false)
    )
    .colorScheme(.light)
}

#Preview("dark") {
    EventDetailPage(
        event: Event.mock,
        execute: { _ in },
        showShare: Binding.constant(false),
        showMoreMenu: Binding.constant(false),
        showEventEditor: Binding.constant(false)
    )
    .colorScheme(.dark)
}
