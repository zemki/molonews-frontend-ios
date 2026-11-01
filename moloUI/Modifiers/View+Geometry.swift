//
//  View+Geometry.swift
//  Modifiers
//

import Foundation
import SwiftUI

public extension View {
    func widthProportional(_ fraction: CGFloat) -> some View {
        let screenWidth = UIScreen.main.bounds.width
        return frame(width: screenWidth * fraction)
    }
}
