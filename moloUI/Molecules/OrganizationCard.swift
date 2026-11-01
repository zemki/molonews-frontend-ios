//
//  OrganizationCard.swift
//  moloFeatures
//
import Assets
import Atoms
import Dimensions
import SwiftUI

public struct OrganizationCard: View {
    private let imageUrl: String
    private let organizationName: String
    private let location: String

    public init(imageUrl: String, organizationName: String, location: String) {
        self.imageUrl = imageUrl
        self.organizationName = organizationName
        self.location = location
    }

    public var body: some View {
        HStack {
            SquareImage(imageUrlString: imageUrl, imageSize: 80)
                .cornerRadius(.cornerRadiusLarge)
                .padding()

            VStack(alignment: .leading) {
                Text(organizationName)
                    .font(.moloSubtitleBold)
                    .foregroundColor(Colors.Text.default.swiftUIColor)

                Spacer()

                Text(location)
                    .font(.moloFooterMedium)
                    .foregroundColor(Colors.Text.default.swiftUIColor)
            }
            .frame(height: 80)
            .padding(.trailing, .horizontalDefault)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Colors.Background.eventOrganization.swiftUIColor
                .clipShape(.rect(cornerRadius: .cornerRadiusMedium))
        )
        .background {
            CardShadow()
        }
    }
}
