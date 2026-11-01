//
//  LoadingView.swift
//  Atoms
//

import Assets
import Foundation
import Strings
import SwiftUI

public struct LoadingView: View {
    @Binding private var searchString: String
    private let isSearchable: Bool

    public init(searchString: Binding<String> = .constant(""), isSearchable: Bool = false) {
        _searchString = searchString
        self.isSearchable = isSearchable
    }

    private var progressIndicator: some View {
        ProgressView(L10n.News.Molo.Loading.progress)
    }

    public var body: some View {
        /*
        Group {
            if isSearchable {
                progressIndicator
                    .searchable(
                        text: $searchString,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: L10n.News.Molo.Search.hint
                    )
            } else {
                progressIndicator
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        */
        
        progressIndicator
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
