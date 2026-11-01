//
//  TopicCategoryLayout.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import Flow
import Strings
import SwiftUI

public struct TopicCategoryLayout: View {
    private let categoryTitle: String
    private let topics: [(Int, Binding<Bool>, String)]

    public init(categoryTitle: String, topics: [(Int, Binding<Bool>, String)]) {
        self.categoryTitle = categoryTitle
        self.topics = topics
    }

    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    public var body: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            HStack(alignment: .bottom, spacing: 0) {
                Text(categoryTitle)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(Colors.Text.topics.swiftUIColor)

                Spacer()

                Button(L10n.News.Molo.Topics.selectAll) {
                    if allSelected() {
                        deselectAll()
                    } else {
                        selectAll()
                    }
                }
                .font(.moloSubtitleBold)
                .foregroundStyle(Colors.Text.topics.swiftUIColor)
            }

            HFlow {
                ForEach(topics, id: \.0) { indexedSelectedTopic in
                    let (_, isSelected, title) = indexedSelectedTopic
                    Chip(title: title, isSelected: isSelected)
                }
            }
        }
    }

    private func selectAll() {
        for (_, isSelected, _) in topics {
            if !isSelected.wrappedValue {
                isSelected.wrappedValue = true
            }
        }
    }

    private func deselectAll() {
        for (_, isSelected, _) in topics {
            if isSelected.wrappedValue {
                isSelected.wrappedValue = false
            }
        }
    }

    private func allSelected() -> Bool {
        if topics.first(where: { _, isSelected, _ in
            isSelected.wrappedValue == false
        }) != nil {
            return false
        }

        return true
    }
}

private struct CategoryPreview: View {
    @State var toggle1 = true
    @State var toggle2 = false
    @State var toggle3 = false
    @State var toggle4 = false
    @State var toggle5 = false
    @State var toggle6 = true
    @State var toggle7 = false

    var body: some View {
        TopicCategoryLayout(
            categoryTitle: "Kunst, Kultur & Performance",
            topics: [
                (1, $toggle1, "🎭 Bühne & Performance"),
                (2, $toggle2, "🎵 Musik & Konzerte"),
                (3, $toggle3, "📚 Literatur & Lesung"),
                (4, $toggle4, "🎨 Kunst & Ausstellung"),
                (5, $toggle5, "🍿 Film & Kino"),
                (6, $toggle6, "🥁 Festival"),
                (7, $toggle7, "🥳 Party & Nachtleben")
            ]
        )
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        CategoryPreview()
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor
        CategoryPreview()
    }
    .colorScheme(.dark)
}
