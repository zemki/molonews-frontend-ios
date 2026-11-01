//
//  CardShadow.swift
//  Atoms
//
import Assets
import Dimensions
import SwiftUI

public struct CardShadow: View {
    public init() {}

    public var body: some View {
        Colors.Shadow.newsCard.swiftUIColor
            .clipShape(.rect(cornerRadius: .cornerRadiusLarge))
            .shadow(radius: 0, x: 0, y: 1)
            .blur(radius: 4)
    }
}

#Preview {
    CardShadow()
}
