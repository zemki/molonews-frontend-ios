//
//  MailView.swift
//  Atoms
//

import Foundation
import MessageUI
import SwiftUI
import UIKit

public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation

    private let recipient: String
    private let subject: String
    private let content: String

    public init(recipient: String, subject: String, content: String) {
        self.recipient = recipient
        self.subject = subject
        self.content = content
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode

        public init(presentation: Binding<PresentationMode>) {
            _presentation = presentation
        }

        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)
            presentation.dismiss()
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation)
    }

    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients([recipient])
        vc.setSubject(subject)
        vc.setMessageBody(content, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
