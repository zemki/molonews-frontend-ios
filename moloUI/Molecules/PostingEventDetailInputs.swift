//
//  PostingEventDetailInputs.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct PostingEventDetailInputs: View {
    @Binding private var venueTitle: String
    private let address: String
    private let date: String
    @Binding private var linkUrlString: String
    @Binding private var ticketUrlString: String

    private let venueTitlePlaceholder: String
    private let addressPlaceholder: String
    private let datePlaceholder: String
    private let linkPlaceholder: String
    private let ticketLinkPlaceholder: String

    private let locationSelectionAction: () -> Void
    private let dateAction: () -> Void

    public init(
        venueTitle: Binding<String>,
        address: String,
        date: String,
        linkUrlString: Binding<String>,
        ticketUrlString: Binding<String>,
        venueTitlePlaceholder: String,
        addressPlaceholder: String,
        datePlaceholder: String,
        linkPlaceholder: String,
        ticketLinkPlaceholder: String,
        locationSelectionAction: @escaping () -> Void,
        dateAction: @escaping () -> Void
    ) {
        _venueTitle = venueTitle
        self.address = address
        self.date = date
        _linkUrlString = linkUrlString
        _ticketUrlString = ticketUrlString
        self.venueTitlePlaceholder = venueTitlePlaceholder
        self.addressPlaceholder = addressPlaceholder
        self.datePlaceholder = datePlaceholder
        self.linkPlaceholder = linkPlaceholder
        self.ticketLinkPlaceholder = ticketLinkPlaceholder
        self.locationSelectionAction = locationSelectionAction
        self.dateAction = dateAction
    }

    public var body: some View {
        VStack(spacing: .verticalMedium) {
            PostingDetailTextField(text: $venueTitle, icon: Assets.Icons.Posting.venue.swiftUIImage, placeholder: venueTitlePlaceholder)
            PostingActionTextField(
                text: address,
                icon: Assets.Icons.Posting.address.swiftUIImage,
                placeholder: addressPlaceholder,
                action: locationSelectionAction
            )
            PostingActionTextField(text: date, icon: Assets.Icons.Posting.date.swiftUIImage, placeholder: datePlaceholder, action: dateAction)
            PostingDetailTextField(text: $linkUrlString, icon: Assets.Icons.Posting.link.swiftUIImage, placeholder: linkPlaceholder)
            PostingDetailTextField(text: $ticketUrlString, icon: Assets.Icons.Posting.ticketLink.swiftUIImage, placeholder: ticketLinkPlaceholder)
        }
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingEventDetailInputs(
            venueTitle: .constant(""),
            address: "",
            date: "",
            linkUrlString: .constant(""),
            ticketUrlString: .constant(""),
            venueTitlePlaceholder: "Veranstaltungsort (optional)",
            addressPlaceholder: "Adresse",
            datePlaceholder: "Datum",
            linkPlaceholder: "Link (optional)",
            ticketLinkPlaceholder: "Tickets (optional)",
            locationSelectionAction: {},
            dateAction: {}
        )
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor

        PostingEventDetailInputs(
            venueTitle: .constant("ÖVB-Arena Bremen"),
            address: "Am Bahnhof 1, 28195 Bremen",
            date: "12.12.2002 19:15 - 12.12.2002 20:15",
            linkUrlString: .constant("https://www.link.de"),
            ticketUrlString: .constant("https://www.tickets.de"),
            venueTitlePlaceholder: "Veranstaltungsort",
            addressPlaceholder: "Adresse",
            datePlaceholder: "Datum",
            linkPlaceholder: "Link (optional)",
            ticketLinkPlaceholder: "Tickets (optional)",
            locationSelectionAction: {},
            dateAction: {}
        )
    }
    .colorScheme(.dark)
}
