//
//  FabMicOverlay.swift
//  Templates
//

import Assets
import Atoms
import Dimensions
import Foundation
import SwiftUI

public struct FabMicOverlay: ViewModifier {
    @Binding private var isRecording: Bool
    @Binding private var isSearchFocused: Bool

    private let toggleFab: () -> Void

    public init(isRecording: Binding<Bool>, isSearchFocused: Binding<Bool>, toggleFab: @escaping () -> Void) {
        _isRecording = isRecording
        _isSearchFocused = isSearchFocused
        self.toggleFab = toggleFab
    }

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                FloatingActionButton(icon: Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill")) {
                    toggleFab()
                }
                .padding(.trailing, isSearchFocused ? .horizontalSmall : .horizontalNavigationBar)
                .padding(.bottom, isSearchFocused ? .verticalLarge + .verticalKeyboardMarginBottom : .verticalLarge)
                .clipShape(Rectangle())
            }
    }
}

public extension View {
    func fabMicOverlay(isRecording: Binding<Bool>, isSearchFocused: Binding<Bool>, _ action: @escaping () -> Void) -> some View {
        modifier(FabMicOverlay(isRecording: isRecording, isSearchFocused: isSearchFocused, toggleFab: action))
    }
}
