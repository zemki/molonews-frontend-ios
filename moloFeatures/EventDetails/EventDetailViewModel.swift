//
//  ArticleDetailViewModel.swift
//  Explore
//

import Combine
import Domain
import EventKit
import FactoryKit
import MapKit
import Routing
import SwiftUI

@MainActor
public final class EventDetailViewModel: ObservableObject {
    @Published private(set) var state: EventDetailState = .idle

    @Published var showShareIntent: Bool = false
    @Published var showMoreMenu: Bool = false

    @Published var showEventEditor: Bool = false

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private(set) var eventId: Int

    public init(eventId: Int) {
        self.eventId = eventId
    }

    func executeIntent(_ intent: EventDetailIntent) {
        switch intent {
        case .loadEventDetails:
            loadEvent()
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: false), stacked: true)
        case .onClickBack:
            coordinator?.back(on: nil)
        case .onClickShare:
            toggleShareIntent()
        case .onClickBookmark:
            toggleBookmark()
        case let .onClickTickets(url):
            openInBrowser(urlString: url)
        case let .onClickWebsite(url):
            openInBrowser(urlString: url)
        case .onClickMore:
            toggleMoreMenu()
        case .onClickReport:
            reportEvent()
        case let .onClickMap(lat, long, title):
            openInMaps(lat: lat, long: long, title: title)
        case .onClickSaveInCalendar:
            storeEventInCalendar()
        }
    }

    private func loadEvent() {
        FetchEventUseCase(eventId: eventId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(event):
                    self?.state = .success(event: event)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func toggleShareIntent() {
        showShareIntent = true
    }

    private func toggleBookmark() {
        guard case var .success(event) = state else {
            loadEvent()
            return
        }

        ToggleBookmarkEventUseCase(eventId: eventId, isBookmarked: event.bookmarked)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    event.bookmarked = !event.bookmarked
                    self?.state = .success(event: event)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func toggleMoreMenu() {
        showMoreMenu.toggle()
    }

    private func reportEvent() {
        guard case let .success(article) = state else {
            loadEvent()
            return
        }

        ReportEventUseCase(eventId: eventId)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    NotificationCenter.default.post(name: .articleReportedNotification, object: article)
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func openInMaps(lat: Double, long: Double, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title

        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    private func openInBrowser(urlString: String) {
        var normalizedUrlString = urlString

        let https = "https://"

        if !normalizedUrlString.hasPrefix(https) {
            let http = "http://"

            if normalizedUrlString.hasPrefix(http) {
                normalizedUrlString.removeFirst(http.count)
            }
            normalizedUrlString = https + normalizedUrlString
        }

        if let url = URL(string: normalizedUrlString) {
            UIApplication.shared.open(url)
        }
    }

    private func storeEventInCalendar() {
        let eventStore = EKEventStore()

        eventStore.requestWriteOnlyAccessToEvents { [weak self] granted, error in
            Task { @MainActor in
                if granted, error == nil {
                    self?.showEventEditor = true
                } else {
                    NotificationCenter.default.post(name: .eventStorageNoAccessNotification, object: nil)
                }
            }
        }
    }
}
