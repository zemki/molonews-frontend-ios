//
//  PostingPreviewEventCardView.swift
//  Organisms
//

import Assets
import Atoms
import Dimensions
import Kingfisher
import Modifiers
import Molecules
import SwiftUI

public struct PostingPreviewEventCardView: View {
    private let imageHeight: CGFloat = 150
    private let eventContentHeight: CGFloat = 170

    private let organizationName: String
    private let eventImageURLString: String?
    private let eventImageData: Data?
    private let eventDay: String
    private let eventDateTime: String
    private let eventLocation: String
    private let eventTitle: String
    private let eventContent: String
    private let town: String

    private let fraction: CGFloat

    private let imageAction: () -> Void

    public init(
        organizationName: String,
        eventImageURLString: String?,
        eventImageData: Data?,
        eventDay: String,
        eventDateTime: String,
        eventLocation: String,
        eventTitle: String,
        eventContent: String,
        town: String,
        widthFraction: CGFloat?,
        imageAction: @escaping () -> Void
    ) {
        self.organizationName = organizationName
        self.eventImageURLString = eventImageURLString
        self.eventImageData = eventImageData
        self.eventDay = eventDay
        self.eventDateTime = eventDateTime
        self.eventLocation = eventLocation
        self.eventTitle = eventTitle
        self.eventContent = eventContent
        self.town = town

        fraction = widthFraction ?? 1.0

        self.imageAction = imageAction
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

                Spacer()
            }

            Spacer()
        }
        .padding(.horizontal, .horizontalDefault)
        .padding(.top, .verticalDefault)
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            Colors.Background.newsCard.swiftUIColor

            VStack(spacing: .verticalDefault) {
                CardImagePosting(
                    imageUrlString: eventImageURLString,
                    imageData: eventImageData,
                    imageHeight: imageHeight
                )
                .cornerRadius(.cornerRadiusLarge)
                .padding(.top, .verticalLarge)
                .padding(.horizontal, .horizontalDefault)
                .onTapGesture {
                    imageAction()
                }

                eventDateAndLocationView

                eventContentView
            }
        }
        .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
        .widthProportional(fraction)
        .frame(height: imageHeight + eventContentHeight + 70)
        .background {
            Colors.Shadow.newsCard.swiftUIColor
                .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
                .shadow(radius: 0, x: 0, y: 1)
                .blur(radius: 4)
        }
    }
}

private struct PreviewEventPostingCardView: View {
    var body: some View {}
}

#Preview("image light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        PostingPreviewEventCardView(
            organizationName: "Bremerkunst",
            eventImageURLString: "https://picsum.photos/200/300",
            eventImageData: nil,
            eventDay: "Samstag",
            eventDateTime: "17. Mai, 15:00",
            eventLocation: "Bremen Shakespeare Company, Neustadt",
            eventTitle: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
            eventContent: "Der Wetterdienst warnt vor Glatteis in Norddeutschland. Im Laufe des Tages können auch der Osten, die Mitte des Landes sowie Süddeutschland betroffen sein. 🎭",
            town: "Bremerhaven",
            widthFraction: nil,
            imageAction: {
                print("action")
            }
        )
    }
    .colorScheme(.light)
}

#Preview("no image dark") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingPreviewEventCardView(
            organizationName: "Bremerkunst",
            eventImageURLString: nil,
            eventImageData: nil,
            eventDay: "Samstag",
            eventDateTime: "17. Mai, 15:00",
            eventLocation: "Bremen Shakespeare Company, Neustadt",
            eventTitle: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
            eventContent: "Der Wetterdienst warnt vor Glatteis in Norddeutschland. Im Laufe des Tages können auch der Osten, die Mitte des Landes sowie Süddeutschland betroffen sein. 🎭",
            town: "Bremerhaven",
            widthFraction: nil,
            imageAction: {
                print("action")
            }
        )
    }
    .colorScheme(.dark)
}
