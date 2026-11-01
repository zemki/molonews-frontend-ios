//
//  SourceSelectionView.swift
//  SourceSelection
//

import Assets
import Atoms
import Domain
import Molecules
import Strings
import SwiftUI
import Templates

public struct SourceSelectionView: View {
    @ObservedObject var viewModel: SourceSelectionViewModel

    public init(viewModel: SourceSelectionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case .success:
                SourcesAccordion(
                    news: viewModel.newsOrganizations,
                    officials: viewModel.officialOrganizations,
                    collectives: viewModel.collectiveOrganizations,
                    execute: viewModel.executeIntent
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.loadOrganizations()
        }
        .padding(0)
    }
}

private struct SourcesAccordion: View {
    private let news: [Organization]
    private let officials: [Organization]
    private let collectives: [Organization]
    private let execute: (SourceSelectionIntent) -> Void

    init(
        news: [Organization],
        officials: [Organization],
        collectives: [Organization],
        execute: @escaping (SourceSelectionIntent) -> Void
    ) {
        self.news = news
        self.officials = officials
        self.collectives = collectives
        self.execute = execute
    }

    private var newsAccordion: some View {
        AccordionLayout(image: Assets.Icons.Organization.news.swiftUIImage, title: L10n.News.Molo.Sources.News.title) {
            ForEach(news, id: \.self) { organization in
                createRowFor(organization)
            }
        }
    }

    private var officialsAccordion: some View {
        AccordionLayout(image: Assets.Icons.Organization.official.swiftUIImage, title: L10n.News.Molo.Sources.Officials.title) {
            ForEach(officials, id: \.self) { organization in
                createRowFor(organization)
            }
        }
    }

    private var collectivesAccordion: some View {
        AccordionLayout(image: Assets.Icons.Organization.community.swiftUIImage, title: L10n.News.Molo.Sources.Collectives.title) {
            ForEach(collectives, id: \.self) { organization in
                createRowFor(organization)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(L10n.News.Molo.Sources.title)
                    .font(.moloSourceSelectionTitle)
                    .lineLimit(1)
                    .foregroundStyle(Colors.Text.organizationTitle.swiftUIColor)
                    .padding(.vertical, .verticalLarge)

                newsAccordion
                    .padding(.bottom, .verticalDefault)
                officialsAccordion
                    .padding(.bottom, .verticalDefault)
                collectivesAccordion
                    .padding(.bottom, .verticalDefault)
            }
            .padding(.horizontal, .horizontalDefault)
        }
        .toolbar {
            DetailTopNavigation(
                backAction: {
                    execute(.onClickBack)
                },
                actions: []
            )
        }
        .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .foregroundStyle(Colors.Icons.topNavigation.swiftUIColor)
    }

    private func createRowFor(_ organization: Organization) -> some View {
        ToggleRow(
            logoUrlString: organization.imageUrlString,
            title: organization.name, isSelected:
            Binding(
                get: {
                    organization.isSelected
                }, set: { _ in
                    switch organization.type {
                    case .all,
                         .unknown:
                        break
                    case .news:
                        execute(.toggleNews(id: organization.id))
                    case .collective:
                        execute(.toggleCollective(id: organization.id))
                    case .official:
                        execute(.toggleOfficial(id: organization.id))
                    }
                }
            )
        )
        .padding(.bottom, .verticalSmall)
        .onTapGesture {
            execute(.onClickOrganization(id: organization.id))
        }
    }
}
