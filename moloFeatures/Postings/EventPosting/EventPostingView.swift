//
//  EventPostingView.swift
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

public struct EventPostingView: View {
    @ObservedObject var viewModel: EventPostingViewModel

    public init(viewModel: EventPostingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .firstStep(event):
                TitleAndDescriptionView(
                    event: event,
                    execute: viewModel.executeIntent(_:)
                )
            case let .secondStep(event):
                DetailsView(
                    event: event,
                    execute: viewModel.executeIntent(_:)
                )
            case let .previewStep(event):
                PostingPreview(
                    event: event,
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
    private let event: PostingEvent

    @State private var showIncompleteDialog: Bool = false

    @State private var title: String
    @State private var description: String
    @State private var presentDeleteAlert: Bool = false

    private let execute: (EventPostingIntent) -> Void

    init(event: PostingEvent,
         execute: @escaping (EventPostingIntent) -> Void) {
        self.event = event
        title = event.title
        description = event.content
        self.execute = execute
    }

    var body: some View {
        PostingInputs(
            title: $title,
            content: $description,
            titlePlaceholder: Strings.L10n.News.Molo.Posting.Event.Title.placeholder,
            contentPlaceholder: Strings.L10n.News.Molo.Posting.Event.Description.placeholder,
            imageUrlString: event.userProfile.imageUrl
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
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Event.Title.placeholder)")
        }
        if description.isEmpty {
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Event.Description.placeholder)")
        }
        return reasons.joined(separator: "\n")
    }
}

private struct DetailsView: View {
    @State private var showIncompleteDialog: Bool = false

    @State private var venueTitle: String
    private let addressDescription: String
    private let dateDescription: String
    @State private var linkUrlString: String
    @State private var ticketUrlString: String

    @State private var event: PostingEvent
    @State private var selectedTags: Set<Int> = []

    private let execute: (EventPostingIntent) -> Void

    init(
        event: PostingEvent,
        execute: @escaping (EventPostingIntent) -> Void
    ) {
        self.event = event
        venueTitle = event.location.eventLocation
        addressDescription = event.location.addressDescription
        dateDescription = event.dateDescription
        linkUrlString = event.link
        ticketUrlString = event.ticketUrl
        _selectedTags = State(initialValue: event.tags)

        self.execute = execute
    }

    private var inputs: some View {
        PostingEventDetailInputs(
            venueTitle: $venueTitle,
            address: addressDescription,
            date: dateDescription,
            linkUrlString: $linkUrlString,
            ticketUrlString: $ticketUrlString,
            venueTitlePlaceholder: Strings.L10n.News.Molo.Posting.Event.Venue.placeholder,
            addressPlaceholder: Strings.L10n.News.Molo.Posting.Event.Address.placeholder,
            datePlaceholder: Strings.L10n.News.Molo.Posting.Event.Date.placeholder,
            linkPlaceholder: Strings.L10n.News.Molo.Posting.Event.Link.placeholder,
            ticketLinkPlaceholder: Strings.L10n.News.Molo.Posting.Event.TicketLink.placeholder,
            locationSelectionAction: {
                execute(.onClickLocationSelection)
            },
            dateAction: {
                execute(.onClickDateSelection)
            }
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
            ForEach(event.categories, id: \.id) { category in
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
                        execute(.storeEventData(venue: venueTitle, link: linkUrlString, ticketLink: ticketUrlString, tags: selectedTags))
                        execute(.onClickPrevious)
                    }
                ),
                trailingAction: (
                    icon: Assets.Icons.Posting.arrow.swiftUIImage,
                    onClick: {
                        execute(.storeEventData(venue: venueTitle, link: linkUrlString, ticketLink: ticketUrlString, tags: selectedTags))
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
        return venueTitle.isEmpty || addressDescription.isEmpty || dateDescription.isEmpty || selectedTags.isEmpty
    }

    private func getIncompletionReasons() -> String {
        var reasons: [String] = []
        if venueTitle.isEmpty {
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Event.Venue.placeholder)")
        }
        if addressDescription.isEmpty {
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Event.Address.placeholder)")
        }
        if dateDescription.isEmpty {
            reasons.append("• \(Strings.L10n.News.Molo.Posting.Event.Date.placeholder)")
        }
        if selectedTags.isEmpty {
            reasons.append("• \(L10n.News.Molo.Posting.topics)")
        }
        return reasons.joined(separator: "\n")
    }
}

private struct PostingPreview: View {
    private let event: PostingEvent
    private let execute: (EventPostingIntent) -> Void

    @State private var presentPhotosPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    @State private var presentSourceAlert: Bool = false
    @State private var sourceName: String = ""

    init(
        event: PostingEvent,
        execute: @escaping (EventPostingIntent) -> Void
    ) {
        self.event = event
        self.execute = execute
    }

    private var card: some View {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "d. MMMM, HH:mm"

        return PostingPreviewEventCardView(
            organizationName: event.userProfile.displayName,
            eventImageURLString: event.imageURLString,
            eventImageData: selectedImageData,
            eventDay: dayFormatter.string(from: event.startDate ?? Date()),
            eventDateTime: dateTimeFormatter.string(from: event.startDate ?? Date()) + L10n.News.Molo.Events.Time.appendix,
            eventLocation: event.location.eventLocation,
            eventTitle: event.title,
            eventContent: event.content,
            town: event.location.town,
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
                selectedImageData = event.imageData
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
