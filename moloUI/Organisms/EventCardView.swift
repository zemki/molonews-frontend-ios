//
//  EventCardView.swift
//  moloUI
//

import Assets
import Atoms
import Dimensions
import Kingfisher
import Modifiers
import Molecules
import SwiftUI

public struct EventCardView: View {
    private let imageHeight: CGFloat = 150
    private let eventContentHeight: CGFloat = 170

    private let eventId: Int
    private let organizationId: Int
    private let organizationName: String
    private let eventImageURLString: String
    private let eventDay: String
    private let eventDateTime: String
    private let eventLocation: String
    private let eventTitle: String
    private let eventContent: String
    private let town: String
    private let watchedCount: Int?
    private let bookmarkedCount: Int?
    private let isPublished: Bool

    private let fraction: CGFloat

    private let detailAction: (Int) -> Void
    private let organizationDetailAction: (Int) -> Void

    public init(
        eventId: Int,
        organizationId: Int,
        organizationName: String,
        eventImageURLString: String,
        eventDay: String,
        eventDateTime: String,
        eventLocation: String,
        eventTitle: String,
        eventContent: String,
        town: String,
        watchedCount: Int?,
        bookmarkedCount: Int?,
        isPublished: Bool,
        widthFraction: CGFloat?,
        detailAction: @escaping (Int) -> Void,
        organizationDetailAction: @escaping (Int) -> Void
    ) {
        self.eventId = eventId
        self.organizationId = organizationId

        self.organizationName = organizationName
        self.eventImageURLString = eventImageURLString
        self.eventDay = eventDay
        self.eventDateTime = eventDateTime
        self.eventLocation = eventLocation
        self.eventTitle = eventTitle
        self.eventContent = eventContent
        self.town = town
        self.watchedCount = watchedCount
        self.bookmarkedCount = bookmarkedCount
        self.isPublished = isPublished

        fraction = widthFraction ?? 1.0

        self.detailAction = detailAction
        self.organizationDetailAction = organizationDetailAction
    }

    private var eventDateAndLocationView: some View {
        VStack(alignment: .leading, spacing: .verticalDefault) {
            IconWithBoldAndRegularText(
                icon: Assets.Icons.Event.calendar.swiftUIImage,
                boldText: eventDay,
                regularText: eventDateTime,
                iconColor: Colors.Icons.eventCard.swiftUIColor,
                textColor: Colors.Text.default.swiftUIColor
            )

            IconWithBoldAndRegularText(
                icon: Assets.Icons.Event.pin.swiftUIImage,
                boldText: eventLocation,
                regularText: town,
                iconColor: Colors.Icons.eventCard.swiftUIColor,
                textColor: Colors.Text.default.swiftUIColor
            )
        }
        .padding(.horizontal, .horizontalDefault)
        .padding(.top, .verticalDefault)
    }

    private var eventContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            CardTextContent(title: eventTitle, titleLineLimit: 2, content: eventContent)

            HStack(spacing: 0) {
                Text("@\(organizationName)")
                    .font(.moloContentDefault)
                    .lineLimit(1)
                    .foregroundStyle(Colors.Text.default.swiftUIColor)
                    .onTapGesture {
                        organizationDetailAction(organizationId)
                    }

                Spacer()

                if let watchedCount, let bookmarkedCount {
                    WatchedAndBookmarkedStack(watchedCount: watchedCount, bookmarkedCount: bookmarkedCount)
                }
            }

            Spacer()
        }
        .padding(.horizontal, .horizontalDefault)
        .padding(.top, .verticalDefault)
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            isPublished ? Colors.Background.default.swiftUIColor : Colors.Background.draftCard.swiftUIColor

            VStack(spacing: .verticalDefault) {
                ZStack {
                    CardImage(imageUrlString: eventImageURLString, imageHeight: imageHeight)
                        .cornerRadius(.cornerRadiusLarge)
                        .padding(.top, .verticalLarge)
                        .padding(.horizontal, .horizontalDefault)

                    if !isPublished {
                        Assets.Icons.Posting.draft.swiftUIImage
                    }
                }

                eventDateAndLocationView

                eventContentView
            }
        }
        .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
        .widthProportional(fraction)
        .frame(height: imageHeight + eventContentHeight + 70)
        .background {
            Colors.Background.newsCard.swiftUIColor
                .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
        }
        .background {
            CardShadow()
        }
        .onTapGesture {
            detailAction(eventId)
        }
    }
}

private struct PreviewEventCardView: View {
    var body: some View {
        EventCardView(
            eventId: 123,
            organizationId: 456,
            organizationName: "Bremerkunst",
            eventImageURLString: "https://picsum.photos/200/300",
            eventDay: "Samstag",
            eventDateTime: "17. Mai, 15:00",
            eventLocation: "Bremen Shakespeare Company, Neustadt",
            eventTitle: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
            eventContent: "Der Wetterdienst warnt vor Glatteis in Norddeutschland. Im Laufe des Tages können auch der Osten, die Mitte des Landes sowie Süddeutschland betroffen sein. 🎭",
            town: "Bremerhaven",
            watchedCount: 5,
            bookmarkedCount: 0,
            isPublished: true,
            widthFraction: nil,
            detailAction: { eventId in
                print("navigate to detail: \(eventId)")
            },
            organizationDetailAction: { organizationId in
                print("navigate to organization detail: \(organizationId)")
            }
        )
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PreviewEventCardView()
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PreviewEventCardView()
    }
    .colorScheme(.dark)
}
