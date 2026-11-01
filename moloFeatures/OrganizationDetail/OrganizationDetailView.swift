//
//  OrganizationDetailView.swift
//  OrganizationDetail
//

import ArticleList
import Assets
import Atoms
import Dimensions
import Domain
import EventList
import Molecules
import Strings
import SwiftUI

public struct OrganizationDetailView: View {
    @ObservedObject var viewModel: OrganizationDetailViewModel

    private let showArticles: Bool

    public init(viewModel: OrganizationDetailViewModel, showArticles: Bool) {
        self.viewModel = viewModel
        self.showArticles = showArticles
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(organization, isUserAsOrganization):
                OrganizationView(
                    isUserAsOrganization: isUserAsOrganization,
                    showArticles: showArticles,
                    logoUrlString: organization.imageUrlString,
                    name: organization.name,
                    description: organization.description,
                    execute: viewModel.executeIntent,
                    articleListState: viewModel.articleListState,
                    executeArticle: viewModel.executeArticleIntent,
                    eventListState: viewModel.eventListState,
                    executeEvent: viewModel.executeEventIntent
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.loadOrganization()
            viewModel.executeArticleIntent(.loadArticles())
            viewModel.executeEventIntent(.loadEvents())
        }
        .padding(0)
    }
}

private struct OrganizationView: View {
    @State private var selectedPage = 0

    private let isUserAsOrganization: Bool
    private let logoUrlString: String
    private let name: String
    private let description: String
    private let execute: (OrganizationDetailIntent) -> Void
    private let articleListState: ArticleListState
    private let executeArticle: (ArticleListIntent) -> Void
    private let eventListState: EventListState
    private let executeEvent: (EventListIntent) -> Void

    init(
        isUserAsOrganization: Bool,
        showArticles: Bool,
        logoUrlString: String,
        name: String,
        description: String,
        execute: @escaping (OrganizationDetailIntent) -> Void,
        articleListState: ArticleListState,
        executeArticle: @escaping (ArticleListIntent) -> Void,
        eventListState: EventListState,
        executeEvent: @escaping (EventListIntent) -> Void
    ) {
        self.isUserAsOrganization = isUserAsOrganization
        _selectedPage = State(initialValue: showArticles ? 0 : 1)
        self.logoUrlString = logoUrlString
        self.name = name
        self.description = description
        self.execute = execute
        self.articleListState = articleListState
        self.executeArticle = executeArticle
        self.eventListState = eventListState
        self.executeEvent = executeEvent
    }

    private var organizationHeader: some View {
        HStack(alignment: .top, spacing: 0) {
            Group {
                if isUserAsOrganization, logoUrlString.isEmpty || logoUrlString == "https://redaktion.molo.news//media/" {
                    Assets.Icons.Posting.imagePlaceholder.swiftUIImage
                } else {
                    RoundCorneredFittingImage(
                        urlString: logoUrlString,
                        size: CGSize(width: .organizationLogoSizeLarge, height: .organizationLogoSizeLarge)
                    )
                    .onTapGesture {
                        if isUserAsOrganization {
                            execute(.onClickEditProfile)
                        }
                    }
                }
            }
            .padding(.horizontal, .horizontalSmall)
            .padding(.vertical, .verticalLarge)

            VStack(alignment: .leading, spacing: .verticalSmall) {
                Text(name)
                    .font(.moloTitleDefault)
                    .foregroundStyle(Colors.Text.organizationTitle.swiftUIColor)
                Text(description)
                    .font(.moloSubtitleRegular)
                    .foregroundStyle(Colors.Text.default.swiftUIColor)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, .horizontalMedium)
            .padding(.vertical, .verticalLarge)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .horizontalDefault)
    }

    private var picker: some View {
        Picker("", selection: $selectedPage) {
            Text(isUserAsOrganization ?L10n.News.Molo.OrganizationDetail.User.Articles.tab : L10n.News.Molo.OrganizationDetail.Articles.tab).tag(0)
            Text(isUserAsOrganization ? L10n.News.Molo.OrganizationDetail.User.Events.tab : L10n.News.Molo.OrganizationDetail.Events.tab).tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, .horizontalDefault)
        .padding(.vertical, .verticalLarge)
    }

    private var articleList: some View {
        Group {
            switch articleListState {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(articles, count, _):
                ArticleListView(
                    articles: articles,
                    totalCount: count,
                    searchString: .constant(""),
                    filter: .constant(.all),
                    isOverlayHidden: .constant(true),
                    isSearchable: false,
                    isDeletable: isUserAsOrganization,
                    execute: executeArticle
                )
            }
        }
    }

    private var eventList: some View {
        Group {
            switch eventListState {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(events, count, _):
                EventListView(
                    events: events,
                    totalCount: count,
                    searchString: .constant(""),
                    isDeletable: isUserAsOrganization,
                    execute: executeEvent
                )
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            organizationHeader

            picker

            TabView(selection: $selectedPage) {
                articleList
                    .tag(0)

                eventList
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .toolbar {
            DetailTopNavigation(
                backAction: {
                    execute(.onClickBack)
                },
                actions: isUserAsOrganization ?
                    [
                        (icon: Assets.Icons.Navigation.edit.swiftUIImage, toggledIcon: nil, isToggled: nil, onClick: { execute(.onClickEditProfile) })
                    ] :
                    []
            )
        }
        .toolbarBackground(Colors.Background.topNavigation.swiftUIColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
