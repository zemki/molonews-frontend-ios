//
//  EventPostingViewModel.swift
//  Postings
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class EventPostingViewModel: ObservableObject {
    @Published private(set) var state: EventPostingState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private var event: PostingEvent = .init()

    private let tagCategoriesLoadedPublisher = PassthroughSubject<Void, Never>()
    private let tagSelectionLoadedPublisher = PassthroughSubject<Void, Never>()

    public init(eventId: Int?) {
        event.userProfile = Container.shared.userProfile() ?? UserProfile()
        event.id = eventId
    }

    func executeIntent(_ intent: EventPostingIntent) {
        switch intent {
        case .willAppear:
            if let eventId = event.id {
                loadEvent(id: eventId)
            } else {
                navigateToTitleAndDescription()
            }
        case let .onClickToDetails(title, description):
            observeDetailLoadingSuccess()
            setupDetails(title: title, description: description)
        case .onClickToPreview:
            navigateToPreview()
        case .onClickPrevious:
            navigateToPrevious()
        case .onClickLocationSelection:
            coordinator?.showSheet(
                .selectEventLocation(
                    location: event.location,
                    result: { [weak self] location in
                        self?.updateLocationSelection(location: location)
                    }
                ), stacked: true
            )
        case .onClickDateSelection:
            coordinator?.showSheet(
                .selectEventDateRange(
                    start: event.startDate,
                    end: event.endDate,
                    result: { [weak self] selectedStart, selectedEnd in
                        self?.updateDateSelection(startDate: selectedStart, endDate: selectedEnd)
                    }
                ), stacked: true
            )
        case let .onImageSelected(data, filename):
            event.imageData = data
            event.imageFilename = filename
        case let .onImageSourceSet(name):
            event.imageSource = name
        case let .storeEventData(venue, link, ticketLink, tags):
            event.location.eventLocation = venue
            event.link = link
            event.ticketUrl = ticketLink
            event.tags = tags
        case let .onClickSubmit(asDraft):
            event.published = !asDraft
            if event.id != nil {
                updateEvent()
            } else {
                postEvent()
            }
        case .onClose:
            coordinator?.back(on: nil)
        }
    }

    private func setupDetails(title: String, description: String) {
        event.title = title
        event.content = description

        if event.categories.isEmpty {
            loadEventTagCategories()
        } else {
            tagCategoriesLoadedPublisher.send(())
        }

        if event.tags.isEmpty {
            loadSelectedTags(title: event.title, content: event.content)
        } else {
            tagSelectionLoadedPublisher.send(())
        }
    }

    private func navigateToPrevious() {
        switch state {
        case .idle,
             .loading,
             .firstStep:
            break
        case .secondStep:
            navigateToTitleAndDescription()
        case .previewStep:
            navigateToDetails()
        }
    }

    private func navigateToTitleAndDescription() {
        state = .firstStep(event: event)
    }

    private func navigateToDetails() {
        var categories = event.categories
        for catIndex in categories.indices {
            for index in categories[catIndex].tags.indices {
                categories[catIndex].tags[index].isSelected = event.tags.contains(categories[catIndex].tags[index].id)
            }
        }
        event.categories = categories

        state = .secondStep(event: event)
    }

    private func updateLocationSelection(location: PostingLocation) {
        guard case .secondStep = state else {
            return
        }

        event.location = location
        state = .secondStep(event: event)
    }

    private func updateDateSelection(startDate: Date, endDate: Date) {
        guard case .secondStep = state else {
            return
        }

        event.startDate = startDate
        event.endDate = endDate
        state = .secondStep(event: event)
    }

    private func navigateToPreview() {
        state = .previewStep(event: event)
    }

    private func loadEvent(id: Int) {
        FetchEventUseCase(eventId: id)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(event):
                    self?.event = event.toEventPosting()
                    self?.event.userProfile = Container.shared.userProfile() ?? UserProfile()
                    self?.navigateToTitleAndDescription()
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    func observeDetailLoadingSuccess() {
        Publishers.CombineLatest(tagCategoriesLoadedPublisher, tagSelectionLoadedPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigateToDetails()
            }
            .store(in: &cancellables)
    }

    private func loadEventTagCategories() {
        FetchTagSelectionUseCase(tagType: .event)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(categories):
                    self?.event.categories = categories
                    self?.tagCategoriesLoadedPublisher.send(())
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func loadSelectedTags(title: String, content: String) {
        GetTagPostingPreselectionUseCase(tagType: .event, title: title, content: content)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(tags):
                    self?.event.tags = Set(
                        tags.map { tag in
                            tag.id
                        }
                    )
                    self?.tagSelectionLoadedPublisher.send(())
                case let .error(useCaseError):
                    self?.tagSelectionLoadedPublisher.send(())
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func postEvent() {
        PostEventUseCase(event: event)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(id):
                    self?.event.id = id
                    if self?.event.imageData != nil {
                        self?.uploadImage()
                    } else {
                        NotificationCenter.default.post(name: .eventPostedNotification, object: nil)
                        self?.coordinator?.back(on: nil)
                    }
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    self.state = .previewStep(event: self.event)
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func updateEvent() {
        UpdateEventUseCase(event: event)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    if self?.event.imageData != nil {
                        self?.uploadImage()
                    } else {
                        self?.coordinator?.back(on: nil)
                    }
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    self.state = .previewStep(event: self.event)
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func uploadImage() {
        guard let eventId = event.id,
              let data = event.imageData else {
            return
        }

        UploadEventImageUseCase(eventId: eventId, file: data, filename: event.imageFilename, source: event.imageSource)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case .success:
                    NotificationCenter.default.post(name: .eventPostedNotification, object: nil)
                    self?.coordinator?.back(on: nil)
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    self.state = .previewStep(event: self.event)
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
