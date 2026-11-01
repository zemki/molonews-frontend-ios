//
//  WebContentView.swift
//  WebContent
//

import Atoms
import Foundation
import Molecules
import SwiftUI
import Assets

public struct WebContentView: View {
    @ObservedObject var viewModel: WebContentViewModel

    public init(viewModel: WebContentViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case let .success(url):
                WebView(urlString: url, execute: viewModel.executeIntent)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct WebView: View {
    private let urlString: String
    private let execute: (WebContentIntent) -> Void

    init(urlString: String, execute: @escaping (WebContentIntent) -> Void) {
        self.urlString = urlString
        self.execute = execute
    }

    var body: some View {
        MoloWebView(urlString: urlString)
            .toolbar {
                DetailTopNavigation(
                    backAction: {
                        execute(.onClickBack)
                    }
                )
            }
            .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding(0)
    }
}
