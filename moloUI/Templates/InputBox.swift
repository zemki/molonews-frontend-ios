//
//  InputBox.swift
//  Templates
//

import Assets
import Atoms
import Foundation
import SwiftUI

public struct InputBox: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                    .fill(Colors.Background.mapInputs.swiftUIColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                            .stroke(Color.black, lineWidth: 0.5)
                    }
            }
    }
}

public extension View {
    func inputBox() -> some View {
        modifier(InputBox())
    }
}
