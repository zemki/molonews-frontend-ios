//
//  MoloProfileTextFieldStyle.swift
//  Atoms
//

import Assets
import Dimensions
import Foundation
import SwiftUI

public struct MoloProfileTextFieldStyle: TextFieldStyle {
    private let color: Color = Colors.Background.input.swiftUIColor
    private let radius: CGFloat = .cornerRadiusSmall

    private let error: Bool
    private let fixedHeight: Bool

    public init(error: Bool, fixedHeight: Bool = true) {
        self.error = error
        self.fixedHeight = fixedHeight
    }

    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontalMedium)
            .frame(height: fixedHeight ? .textInputHeightDefault : .infinity)
            .background(color)
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(error ? Colors.Text.error.swiftUIColor : color, lineWidth: 1)
            )
    }
}
