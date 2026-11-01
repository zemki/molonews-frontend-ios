//
//  InAppEmailViewModel.swift
//  InAppEmail
//

import FactoryKit
import Foundation
import Routing
import Strings
import SwiftUI

@MainActor
public final class InAppEmailViewModel: ObservableObject {
    @Published private(set) var state: InAppEmailState = .idle

    @Published private(set) var emailRecipient: String = L10n.News.Molo.Email.to
    @Published private(set) var emailSubject: String = L10n.News.Molo.Email.subject
    @Published private(set) var emailContent: String = L10n.News.Molo.Email.content

    @Injected(\.coordinator) private var coordinator: Coordinator?

    public init() {
        state = .success
    }
}
