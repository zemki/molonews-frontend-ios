//
//  ToastNotification.swift
//  moloApp
//

import Atoms
import Foundation
import Molecules
import SwiftUI
import UIKit

@MainActor
class ToastNotification: ObservableObject {
    static let shared = ToastNotification()

    private var window: PassthroughWindow?

    private init() {}

    func show(_ message: String, duration: TimeInterval = 2.0) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        let toastView = UIHostingController(rootView: Toast(message: message))
        toastView.view.backgroundColor = .clear

        let newWindow = PassthroughWindow(windowScene: scene)
        newWindow.rootViewController = toastView
        newWindow.windowLevel = .alert + 1
        newWindow.backgroundColor = .clear
        newWindow.isHidden = false
        newWindow.makeKeyAndVisible()

        window = newWindow

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.window?.isHidden = true
            self.window = nil
        }
    }
}
