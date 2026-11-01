//
//  InAppEmailView.swift
//  InAppEmail
//

import Atoms
import Foundation
import Molecules
import SwiftUI

public struct InAppEmailView: View {
    @ObservedObject var viewModel: InAppEmailViewModel

    public init(viewModel: InAppEmailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .success:
            EmailView(to: viewModel.emailRecipient, subject: viewModel.emailSubject, content: viewModel.emailContent)
        }
    }
}

private struct EmailView: View {
    private let to: String
    private let subject: String
    private let content: String

    init(to: String, subject: String, content: String) {
        self.to = to
        self.subject = subject
        self.content = content
    }

    var body: some View {
        MailView(recipient: to, subject: subject, content: content)
    }
}
