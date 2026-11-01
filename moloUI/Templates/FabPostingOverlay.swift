//
//  FabPostingOverlay.swift
//  Modifiers
//

import Assets
import Atoms
import Foundation
import SwiftUI

public struct FabPostingOverlay: ViewModifier {
    private let onClickFab: () -> Void

    public init(onClickFab: @escaping () -> Void) {
        self.onClickFab = onClickFab
    }

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                FloatingActionButton(icon: Assets.Icons.Fab.vector.swiftUIImage) {
                    onClickFab()
                }
                .padding(.trailing, .horizontalNavigationBar)
                .padding(.bottom, .verticalLarge)
                .clipShape(Rectangle())
            }
    }
}

public extension View {
    func fabPosting(_ action: @escaping () -> Void) -> some View {
        modifier(FabPostingOverlay(onClickFab: action))
    }
}
