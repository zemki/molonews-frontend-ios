//
//  LocationSelectionViewModel.swift
//  LocationSelection
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class LocationSelectionViewModel: ObservableObject {
    @Published var state: LocationSelectionState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private let locationSelectionCallback: ((PostingLocation) -> Void)?

    private var cancellables = Set<AnyCancellable>()

    private let postingLocation: PostingLocation?
    private var radius: Double = 10

    private let fallbackLatitude: Double = 51.160812733
    private let fallbackLongitude: Double = 10.442651358
    private let fallbackRadius: Double = 250

    public init(postingLocation: PostingLocation? = nil, locationSelectionCallback: ((PostingLocation) -> Void)? = nil) {
        self.postingLocation = postingLocation
        self.locationSelectionCallback = locationSelectionCallback
    }

    func executeIntent(_ intent: LocationSelectionIntent) {
        switch intent {
        case .willAppear:
            determineLocationToPresent()
        case let .onStartSearch(locationName):
            geocodeByAddress(locationName, forEventLocation: postingLocation != nil)
        case .onClickLocate:
            determineGpsAndSetAsCurrentLocation()
        case let .onChangeRadius(radius):
            changeRadius(to: radius)
        case let .onClickDone(closeAction):
            storeAreaAndClose(closeAction)
        case let .onClickPostingLocationSelected(location):
            if let locationSelectionCallback {
                locationSelectionCallback(location)
            }
            coordinator?.back(on: nil)
        }
    }

    private func setAsCurrentLocation(location: MoloLocation) {
        if let radius = location.radius {
            self.radius = radius
        }

        state = .located(
            name: location.name,
            radius: radius,
            latitude: location.latitude,
            longitude: location.longitude,
            areas: []
        )
        requestAreasForGPSLocation(latitude: location.latitude, longitude: location.longitude)
    }

    private func determineGpsAndSetAsCurrentLocation() {
        determineGPSLocation { [weak self] location in
            guard let self else {
                return
            }
            self.state = .located(
                name: location.name,
                radius: location.radius ?? self.radius,
                latitude: location.latitude,
                longitude: location.longitude,
                areas: []
            )
            if location.radius != fallbackRadius {
                self.requestAreasForGPSLocation(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }

    private func determineLocationToPresent() {
        if var postingLocation {
            if postingLocation.latitude == .zero || postingLocation.longitude == .zero {
                determineGPSLocation { [weak self] location in
                    postingLocation.latitude = location.latitude
                    postingLocation.longitude = location.longitude
                    self?.state = .postingAddressLocated(postingLocation: postingLocation)
                }
            } else {
                state = .postingAddressLocated(postingLocation: postingLocation)
            }
        } else {
            loadCurrentLocation(
                onSuccess: setAsCurrentLocation(location:),
                onError: determineGpsAndSetAsCurrentLocation
            )
        }
    }

    private func loadCurrentLocation(onSuccess: @escaping (MoloLocation) -> Void, onError: @escaping () -> Void) {
        GetStoredAreaUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(location):
                    onSuccess(location)
                case .error:
                    onError()
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func determineGPSLocation(onSuccess: @escaping (MoloLocation) -> Void) {
        GetCurrentGPSLocationUseCase()
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(location):
                    onSuccess(location)
                case let .error(useCaseError):
                    guard let self else {
                        return
                    }
                    onSuccess(MoloLocation(name: nil, latitude: fallbackLatitude, longitude: fallbackLongitude, radius: fallbackRadius))
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func geocodeByAddress(_ address: String, forEventLocation isEventLocation: Bool) {
        GeocodeLocationByNameUseCase(address: address)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(location):
                    guard let self else {
                        return
                    }

                    if isEventLocation {
                        let location = PostingLocation(
                            street: location.street,
                            town: location.town,
                            zipCode: location.zip,
                            latitude: location.latitude,
                            longitude: location.longitude
                        )
                        self.state = .postingAddressLocated(postingLocation: location)
                    } else {
                        self.state = .located(
                            name: location.name,
                            radius: self.radius,
                            latitude: location.latitude,
                            longitude: location.longitude,
                            areas: []
                        )
                        self.requestAreasForGPSLocation(latitude: location.latitude, longitude: location.longitude)
                    }
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func changeRadius(to radius: Double) {
        self.radius = radius.rounded()

        if case let .located(name, _, latitude, longitude, areas) = state {
            state = .located(name: name, radius: radius, latitude: latitude, longitude: longitude, areas: areas)
            requestAreasForGPSLocation(latitude: latitude, longitude: longitude)
        }
    }

    private func requestAreasForGPSLocation(latitude: Double, longitude: Double) {
        guard case let .located(name, radius, latitude, longitude, _) = state else {
            return
        }

        FetchMoloLocationsFromCoordinatesUseCase(latitude: latitude, longitude: longitude, radius: Int(radius))
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case let .success(areas):
                    self?.state = .located(name: name, radius: radius, latitude: latitude, longitude: longitude, areas: areas)
                case .error:
                    break
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func storeAreaAndClose(_ closeAction: (() -> Void)?) {
        guard case let .located(name, radius, latitude, longitude, _) = state else {
            return
        }

        StoreAreaUseCase(name: name, latitude: latitude, longitude: longitude, radius: Float(radius))
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    break
                case .success():
                    NotificationCenter.default.post(name: .locationChangedNotification, object: nil)

                    if let closeAction {
                        closeAction()
                    } else {
                        self?.coordinator?.back(on: nil)
                    }
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
