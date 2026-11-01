//
//  WebContentViewModel.swift
//  WebContent
//

import FactoryKit
import Foundation
import Routing
import SwiftUI

@MainActor
public final class WebContentViewModel: ObservableObject {
    @Published private(set) var state: WebContentState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    public init(urlString: String) {
        state = .success(url: urlString)
    }

    func executeIntent(_ intent: WebContentIntent) {
        switch intent {
        case .onClickBack:
            coordinator?.back(on: nil)
        }
    }
}
