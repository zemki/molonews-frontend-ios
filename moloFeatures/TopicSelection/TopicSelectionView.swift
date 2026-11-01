//
//  TopicSelectionView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI
import Templates

public struct TopicSelectionView: View {
    @ObservedObject var viewModel: TopicSelectionViewModel
    private let initialSelection: Int

    private let customSubmitAction: (() -> Void)?

    public init(viewModel: TopicSelectionViewModel, initialSelection: Int, customSubmitAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.initialSelection = initialSelection
        self.customSubmitAction = customSubmitAction
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(articleCategories, eventCategories):
                TopicsView(
                    articleCategories: articleCategories,
                    eventCategories: eventCategories,
                    selectedPage: initialSelection,
                    execute: viewModel.executeIntent(_:),
                    customSubmitAction: customSubmitAction
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.loadSelection)
        }
        .padding(0)
    }
}

private struct TopicsView: View {
    @State private var selectedPage = 0

    private let articleCategories: [Domain.Category]
    private let eventCategories: [Domain.Category]
    private let execute: (TopicSelectionIntent) -> Void
    private let customSubmitAction: (() -> Void)?

    init(articleCategories: [Domain.Category],
         eventCategories: [Domain.Category],
         selectedPage: Int,
         execute: @escaping (TopicSelectionIntent) -> Void,
         customSubmitAction: (() -> Void)?) {
        self.articleCategories = articleCategories.sorted { lhs, rhs in
            lhs.order ?? 0 < rhs.order ?? 0
        }
        self.eventCategories = eventCategories.sorted { lhs, rhs in
            lhs.order ?? 0 < rhs.order ?? 0
        }
        self._selectedPage = State(initialValue: selectedPage)
        self.execute = execute
        self.customSubmitAction = customSubmitAction
    }

    private var articleTopicsScrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(articleCategories, id: \.id) { category in
                    let topics = category.tags.map { tag in
                        (
                            tag.id,
                            Binding(
                                get: {
                                    tag.isSelected
                                }, set: { _ in
                                    execute(.toggleArticleTopic(id: tag.id, in: category.id!))
                                }
                            ),
                            tag.name
                        )
                    }

                    TopicCategoryLayout(categoryTitle: category.name, topics: topics)
                        .padding(.horizontal, .horizontalDefault)
                        .padding(.bottom, .verticalXLarge)
                }
            }
        }
    }

    private var eventTopicsScrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(eventCategories, id: \.id) { category in
                    let topics = category.tags.map { tag in
                        (
                            tag.id,
                            Binding(
                                get: {
                                    tag.isSelected
                                }, set: { _ in
                                    execute(.toggleEventTopic(id: tag.id, in: category.id!))
                                }
                            ),
                            tag.name
                        )
                    }

                    TopicCategoryLayout(categoryTitle: category.name, topics: topics)
                        .padding(.horizontal, .horizontalDefault)
                        .padding(.bottom, .verticalXLarge)
                }
            }
        }
    }

    private var submitButton: some View {
        PrimaryButton(text: L10n.News.Molo.Location.submit) {
            if let customSubmitAction {
                customSubmitAction()
            }
        }
    }

    private var onboardingOverlay: some View {
        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 0) {
                Spacer()

                submitButton
                    .frame(width: 150)
                    .padding(.bottom, .verticalLarge)
                    .padding(.horizontal, .horizontalDefault)
            }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                Picker("", selection: $selectedPage) {
                    Text(L10n.News.Molo.Tags.Articles.tab).tag(0)
                    Text(L10n.News.Molo.Tags.Events.tab).tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, .horizontalDefault)
                .padding(.vertical, .verticalLarge)

                TabView(selection: $selectedPage) {
                    articleTopicsScrollView
                        .tag(0)

                    eventTopicsScrollView
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.News.Molo.Topics.title)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
                if customSubmitAction == nil {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        IconButton(icon: Assets.Icons.Navigation.back.swiftUIImage, color: Colors.Icons.navigation.swiftUIColor) {
                            execute(.onClickBack)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding(0)

            if customSubmitAction != nil {
                onboardingOverlay
            }
        }
    }
}

#Preview {
    TopicsView(
        articleCategories: [],
        eventCategories: [
            Category(
                id: 1,
                name: "Kunst, Kultur & Performance",
                order: 1,
                tags: [
                    Tag(id: 1, name: "🎭 Bühne & Performance", isSelected: false, color: ""),
                    Tag(id: 2, name: "🎵 Musik & Konzerte", isSelected: false, color: ""),
                    Tag(id: 3, name: "📚 Literatur & Lesung", isSelected: true, color: ""),
                    Tag(id: 4, name: "🎨 Kunst & Ausstellung", isSelected: false, color: ""),
                    Tag(id: 5, name: "🍿 Film & Kino", isSelected: false, color: ""),
                    Tag(id: 6, name: "🥁 Festival", isSelected: true, color: ""),
                    Tag(id: 7, name: "🥳 Party & Nachtleben", isSelected: false, color: "")
                ]
            ),

            Category(
                id: 2,
                name: "Lernen, Bildung & Wissen",
                order: 2,
                tags: [
                    Tag(id: 8, name: "🔭 Bildung & Wissen", isSelected: true, color: ""),
                    Tag(id: 9, name: "🪚 Workshops & DIY", isSelected: false, color: ""),
                    Tag(id: 10, name: "🧭 Führungen & Natur", isSelected: false, color: "")
                ]
            ),

            Category(
                id: 3,
                name: "Lernen, Bildung & Wissen",
                order: 2,
                tags: [
                    Tag(id: 8, name: "🔭 Bildung & Wissen", isSelected: true, color: ""),
                    Tag(id: 9, name: "🪚 Workshops & DIY", isSelected: false, color: ""),
                    Tag(id: 10, name: "🧭 Führungen & Natur", isSelected: false, color: "")
                ]
            ),

            Category(
                id: 4,
                name: "Lernen, Bildung & Wissen",
                order: 2,
                tags: [
                    Tag(id: 8, name: "🔭 Bildung & Wissen", isSelected: true, color: ""),
                    Tag(id: 9, name: "🪚 Workshops & DIY", isSelected: false, color: ""),
                    Tag(id: 10, name: "🧭 Führungen & Natur", isSelected: false, color: "")
                ]
            )
        ],
        selectedPage: 1,
        execute: { _ in },
        customSubmitAction: {}
    )
}
