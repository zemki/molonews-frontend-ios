//
//  SearchHistoryRow.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct SearchHistoryRow: View {
    private let title: String
    private let onClick: () -> Void
    private let onClickDelete: (String) -> Void

    public init(title: String, onClick: @escaping () -> Void, onClickDelete: @escaping (String) -> Void) {
        self.title = title
        self.onClick = onClick
        self.onClickDelete = onClickDelete
    }

    public var body: some View {
        HStack(alignment: .center, spacing: .horizontalMedium) {
            Text(title)
                .font(.moloMenuItemDefault)
                .lineLimit(2)
                .foregroundStyle(Colors.Text.default.swiftUIColor)

            Spacer()

            IconButton(icon: Assets.Icons.Button.close.swiftUIImage, color: Colors.Text.default.swiftUIColor) {
                onClickDelete(title)
            }
        }
        .padding(.horizontal, .horizontalDefault)
        .frame(height: 70)
        .overlay {
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Colors.Border.topics.swiftUIColor)
            }
        }
        .onTapGesture {
            onClick()
        }
    }
}

#Preview {
    ZStack {
        Colors.Background.default.swiftUIColor

        SearchHistoryRow(
            title: "Theater Bremen am Wochenende und wenn der Text noch viel länger wird, dann ist irgendwann",
            onClick: {
                print("on click")
            },
            onClickDelete: { title in
                print("remove", title)
            }
        )
    }
    .colorScheme(.dark)
}
