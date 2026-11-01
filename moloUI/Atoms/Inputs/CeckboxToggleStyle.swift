//
//  CeckboxToggleStyle.swift
//  Atoms
//

import Assets
import Foundation
import SwiftUI

public struct CheckboxToggleStyle: ToggleStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                ZStack {
                    Assets.Icons.Account.box.swiftUIImage

                    if configuration.isOn {
                        Assets.Icons.Account.checkmark.swiftUIImage
                    }
                }

                configuration.label
            }
        })
    }
}
