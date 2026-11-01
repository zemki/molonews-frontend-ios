//
//  PassthroughWindow.swift
//  moloApp
//

import UIKit

class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
