//
//  PostingDetailLayout.swift
//  Templates
//

import Assets
import Atoms
import Dimensions
import Flow
import Strings
import SwiftUI

public struct PostingDetailLayout<Inputs: View, SectionTitle: View, TopicSelection: View>: View {
    private let postingDetailInputs: Inputs
    private let postingSectionTitle: SectionTitle
    private let postingTopicSelection: TopicSelection

    public init(postingDetailInputs: Inputs, postingSectionTitle: SectionTitle, postingTopicSelection: TopicSelection) {
        self.postingDetailInputs = postingDetailInputs
        self.postingSectionTitle = postingSectionTitle
        self.postingTopicSelection = postingTopicSelection
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .verticalXLarge * 2) {
            postingDetailInputs
            postingSectionTitle
            postingTopicSelection
        }
    }
}
