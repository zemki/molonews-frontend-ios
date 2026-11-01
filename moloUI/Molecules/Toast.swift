//
//  Toast.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct Toast: View {
    public enum ToastPosition {
        case top,
             center,
             bottom
    }

    private let message: String
    private let position: ToastPosition

    public init(message: String, position: ToastPosition = .bottom) {
        self.message = message
        self.position = position
    }

    public var body: some View {
        VStack {
            if position == .bottom {
                Spacer()
            }

            Text(message)
                .font(.moloSubtitleRegular)
                .foregroundColor(
                    Colors.Text.toast.swiftUIColor
                )
                .padding(.horizontal, .horizontalDefault)
                .padding(.vertical, .verticalSmall)
                .background(
                    Colors.Background.toast.swiftUIColor
                )
                .cornerRadius(.cornerRadiusSmall)
                .padding(.horizontal, .horizontalSmall)

            if position == .top {
                Spacer()
            }
        }
        .padding(.vertical, 65)
    }
}

#Preview {
    Toast(message: "Toast")
}
