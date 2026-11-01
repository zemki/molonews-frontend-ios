//
//  WatchedAndBookmarkedStack.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct WatchedAndBookmarkedStack: View {
    private let watchedCount: Int
    private let bookmarkedCount: Int

    public init(watchedCount: Int, bookmarkedCount: Int) {
        self.watchedCount = watchedCount
        self.bookmarkedCount = bookmarkedCount
    }

    public var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "eye")
                .foregroundStyle(Colors.Text.default.swiftUIColor)

            Text("\(watchedCount)")
                .font(.moloContentDefault)
                .lineLimit(1)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .padding(.leading, .horizontalSmall)

            Image(systemName: "bookmark")
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .padding(.leading, .horizontalMedium)

            Text("\(bookmarkedCount)")
                .font(.moloContentDefault)
                .lineLimit(1)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .padding(.leading, .horizontalSmall)
        }
        .padding(.horizontal, .horizontalSmall)
    }
}

#Preview {
    WatchedAndBookmarkedStack(watchedCount: 5, bookmarkedCount: 0)
}
