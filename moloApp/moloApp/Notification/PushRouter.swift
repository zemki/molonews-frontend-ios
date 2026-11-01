//
//  PushRouter.swift
//  moloApp
//

import FactoryKit
import Foundation
import Routing
import Strings
import SwiftUI

final class PushRouter: ObservableObject {
    static let shared = PushRouter()

    @Injected(\.coordinator) private var coordinator: Coordinator?

    enum Route {
        case article(id: Int)
        case event(id: Int)
    }

    func handle(userInfo: [AnyHashable: Any]) {
        if let id = userInfo["article_id"] as? String, let article_id = Int(id) {
            Task {
                await coordinator?.showSheet(.articleDetail(id: article_id), stacked: true)
            }
        } else if let id = userInfo["event_id"] as? String, let event_id = Int(id) {
            Task {
                await coordinator?.showSheet(.eventDetail(id: event_id), stacked: true)
            }
        }
    }
}
