//
//  ArticlePostingView.swift
//  Postings
//

import Assets
import Atoms
import Dimensions
import Domain
import FactoryKit
import Foundation
import MapKit
import Molecules
import Organisms
import PhotosUI
import Strings
import SwiftUI
import Templates

public struct ArticlePostingView: View {
    @ObservedObject var viewModel: ArticlePostingViewModel

    public init(viewModel: ArticlePostingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .firstStep(article):
                TitleAndDescriptionView(
                    article: article,
                    execute: viewModel.executeIntent(_:)
                )
            case let .secondStep(article):
                DetailsView(
                    article: article,
                    execute: viewModel.executeIntent(_:)
                )
            case let .previewStep(article):
                PostingPreview(
                    article: article,
                    execute: viewModel.executeIntent(_:)
                )
            }
        }
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .navigationBarBackButtonHidden(true)
        .padding(0)
    }
}

private struct TitleAndDescriptionView: View {
    private let article: PostingArticle

    @State private var showIncompleteDialog: Bool = false

    @State private var title: String
    @State private var description: String
    @State private var presentDeleteAlert: Bool = false

    private let execute: (ArticlePostingIntent) -> Void

    init(article: PostingArticle,
         execute: @escaping (ArticlePostingIntent) -> Void) {
        self.article = article
        title = article.title
        description = article.content
        self.execute = execute
    }

    var body: some View {
        PostingInputs(
            title: $title,
            content: $description,
            titlePlaceholder: Strings.L10n.News.Molo.Posting.Article.Title.placeholder,
            contentPlaceholder: Strings.L10n.News.Molo.Posting.Article.Description.placeholder,
            imageUrlString: article.userProfile.imageUrl
        )
        .padding(.horizontal, .horizontalDefault)
        .toolbar {
            PostingToolbar(
                leadingAction: (
                    icon: Assets.Icons.Posting.close.swiftUIImage,
                    onClick: {
                        presentDeleteAlert = true
                    }
                ),
                trailingAction: (
                    icon: Assets.Icons.Posting.arrow.swiftUIImage,
                    onClick: {
                        if isIncomplete() {
                            showIncompleteDialog = true
                        } else {
                            execute(.onClickToDetails(title: title, description: description))
                        }
                    }
                ),
                title: ""
            )
        }
        .alert(L10n.News.Molo.Posting.Incomplete.Alert.title, isPresented: $showIncompleteDialog) {
            Button(L10n.News.Molo.Posting.Incomplete.Alert.ok, role: .cancel) {
                showIncompleteDialog = false
            }
        } message: {
            Text(L10n.News.Molo.Posting.Incomplete.Alert.message(getIncompletionReasons()))
        }
        .alert(L10n.News.Molo.Posting.Cancel.Alert.title, isPresented: $presentDeleteAlert) {
            Button(L10n.News.Molo.Posting.Cancel.Alert.delete, role: .destructive) {
                execute(.onClose)
            }
            Button(L10n.News.Molo.Posting.Cancel.Alert.save, role: .none) {
                execute(.onClickSubmit(asDraft: true))
            }
        } message: {
            Text(L10n.News.Molo.Posting.Cancel.Alert.message)
        }
    }

    private func isIncomplete() -> Bool {
        return title.isEmpty || description.isEmpty
    }

    private func getIncompletionReasons() -> String {
        var reasons: [String] = []
        if title.isEmpty {
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Article.Title.placeholder)")
        }
        if description.isEmpty {
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Article.Description.placeholder)")
        }
        return reasons.joined(separator: "\n")
    }
}

private struct DetailsView: View {
    @State private var article: PostingArticle

    @State private var showIncompleteDialog: Bool = false

    @State private var linkUrlString: String
    @State private var selectedTags: Set<Int> = []

    private let execute: (ArticlePostingIntent) -> Void

    init(
        article: PostingArticle,
        execute: @escaping (ArticlePostingIntent) -> Void
    ) {
        self.article = article
        linkUrlString = article.link
        _selectedTags = State(initialValue: article.tags)

        self.execute = execute
    }

    private var inputs: some View {
        PostingArticleDetailInputs(
            linkUrlString: $linkUrlString,
            linkPlaceholder: Strings.L10n.News.Molo.Posting.Article.Link.placeholder
        )
    }

    private var sectionHeader: some View {
        PostingSectionTitle(
            title: L10n.News.Molo.Posting.topics,
            content: L10n.News.Molo.Posting.Topics.description
        )
    }

    private var topicSelection: some View {
        LazyVStack(alignment: .leading) {
            ForEach(article.categories, id: \.id) { category in
                let topics = category.tags.map { tag in
                    (
                        tag.id,
                        Binding<Bool>(
                            get: {
                                selectedTags.contains(tag.id)
                            }, set: { isSelected in
                                if isSelected {
                                    selectedTags.insert(tag.id)
                                } else {
                                    selectedTags.remove(tag.id)
                                }
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

    var body: some View {
        ScrollView(showsIndicators: false) {
            PostingDetailLayout(
                postingDetailInputs: inputs,
                postingSectionTitle: sectionHeader,
                postingTopicSelection: topicSelection
            )
        }
        .padding(.horizontal, .horizontalDefault)
        .toolbar {
            PostingToolbar(
                leadingAction: (
                    icon: Assets.Icons.Posting.arrowBack.swiftUIImage,
                    onClick: {
                        execute(.storeArticleData(link: linkUrlString, tags: selectedTags))
                        execute(.onClickPrevious)
                    }
                ),
                trailingAction: (
                    icon: Assets.Icons.Posting.arrow.swiftUIImage,
                    onClick: {
                        execute(.storeArticleData(link: linkUrlString, tags: selectedTags))
                        if isIncomplete() {
                            showIncompleteDialog = true
                        } else {
                            execute(.onClickToPreview)
                        }
                    }
                ),
                title: ""
            )
        }
        .alert(L10n.News.Molo.Posting.Incomplete.Alert.title, isPresented: $showIncompleteDialog) {
            Button(L10n.News.Molo.Posting.Incomplete.Alert.ok, role: .cancel) {
                showIncompleteDialog = false
            }
        } message: {
            Text(L10n.News.Molo.Posting.Incomplete.Alert.message(getIncompletionReasons()))
        }
    }

    private func isIncomplete() -> Bool {
        return selectedTags.isEmpty
    }

    private func getIncompletionReasons() -> String {
        var reasons: [String] = []
        if selectedTags.isEmpty {
            reasons.append("• \(L10n.News.Molo.Posting.topics)")
        }
        return reasons.joined(separator: "\n")
    }
}

private struct PostingPreview: View {
    private let article: PostingArticle
    private let execute: (ArticlePostingIntent) -> Void

    @State private var presentPhotosPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    @State private var presentSourceAlert: Bool = false
    @State private var sourceName: String = ""

    init(
        article: PostingArticle,
        execute: @escaping (ArticlePostingIntent) -> Void
    ) {
        self.article = article
        self.execute = execute
    }

    private var card: some View {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "d. MMMM, HH:mm"

        return PostingPreviewArticleCardView(
            organizationName: article.userProfile.displayName,
            organizationLogoUrlString: article.userProfile.imageUrl,
            articleImageURLString: article.imageURLString,
            articleImageData: selectedImageData,
            articleTitle: article.title,
            articleContent: article.content,
            widthFraction: .cardWidthFraction,
            imageAction: {
                presentPhotosPicker = true
            }
        )
        .photosPicker(isPresented: $presentPhotosPicker, selection: $selectedPhotoItem)
        .onChange(of: selectedPhotoItem) { _, newValue in
            Task {
                if let newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let jpg = uiImage.jpegData(compressionQuality: 1.0) {
                    selectedImageData = jpg
                    execute(.onImageSelected(imageData: jpg, filename: "\(UUID().uuidString).jpg"))
                    presentSourceAlert = true
                }
            }
        }
        .alert(L10n.News.Molo.Posting.Image.Alert.title, isPresented: $presentSourceAlert, actions: {
            TextField(L10n.News.Molo.Posting.Image.Alert.placeholder, text: $sourceName)
            Button(L10n.News.Molo.Posting.Image.Alert.ok) {
                execute(.onImageSourceSet(name: sourceName))
            }
            .disabled(sourceName.isEmpty)
        })
        .onAppear {
            if selectedImageData == nil {
                selectedImageData = article.imageData
            }

            sourceName = Container.shared.userProfile()?.displayName ?? ""
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            card

            Spacer()

            PrimaryButton(text: L10n.News.Molo.Posting.Post.action) {
                execute(.onClickSubmit(asDraft: false))
            }
            .padding(.bottom, .verticalMedium)

            SecondaryButton(text: L10n.News.Molo.Posting.Draft.action) {
                execute(.onClickSubmit(asDraft: true))
            }
        }
        .background(
            Colors.Background.default.swiftUIColor
        )
        .padding(.horizontal, .horizontalDefault)
        .padding(.vertical, .verticalXLarge)
        .toolbar {
            PostingToolbar(
                leadingAction: (
                    icon: Assets.Icons.Posting.arrowBack.swiftUIImage,
                    onClick: {
                        execute(.onClickPrevious)
                    }
                ),
                trailingAction: nil,
                title: ""
            )
        }
    }
}
