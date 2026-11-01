//
//  LocationSelectionView.swift
//  LocationSelection
//

import Assets
import Atoms
import Dimensions
import Domain
import Foundation
import MapKit
import Molecules
import Organisms
import Strings
import SwiftUI
import Templates

public struct LocationSelectionView: View {
    @ObservedObject var viewModel: LocationSelectionViewModel

    private let customSubmitAction: (() -> Void)?

    public init(viewModel: LocationSelectionViewModel, customSubmitAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.customSubmitAction = customSubmitAction
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .located(name, radius, latitude, longitude, areas):
                LocationSelection(
                    locationName: name,
                    latitude: latitude,
                    longitude: longitude,
                    radius: radius,
                    areas: areas,
                    execute: viewModel.executeIntent(_:),
                    customSubmitAction: customSubmitAction
                )
            case let .postingAddressLocated(postingLocation):
                PostingLocationSelection(
                    postingLocation: postingLocation,
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

private struct LocationSelection: View {
    @FocusState private var isFocused: Bool
    @State private var selection: TextSelection?

    @State private var locationName: String
    @State private var radius: Double

    @State private var cameraPosition: MapCameraPosition

    private let latitude: Double
    private let longitude: Double
    private let areas: [Area]

    private var location: CLLocationCoordinate2D

    private let execute: (LocationSelectionIntent) -> Void
    private let customSubmitAction: (() -> Void)?

    private let minRadius: Double = 1
    private let maxRadius: Double = 150

    private var invalidSelection: Bool {
        radius > maxRadius
    }

    init(
        locationName: String,
        latitude: Double,
        longitude: Double,
        radius: Double,
        areas: [Area],
        execute: @escaping (LocationSelectionIntent) -> Void,
        customSubmitAction: (() -> Void)?
    ) {
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.areas = areas
        self.execute = execute
        self.customSubmitAction = customSubmitAction

        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion.region(
                center: location.shifted(latitudeOffsetKm: radius / 2.0),
                radiusInKm: radius + radius / 2.0
            )
        )
    }

    private var locationInput: some View {
        TextField("", text: $locationName, selection: $selection)
            .textContentType(.addressCity)
            .autocorrectionDisabled(false)
            .textInputAutocapitalization(.words)
            .keyboardType(.default)
            .submitLabel(.search)
            .font(.moloContentDefault)
            .padding(.vertical, .verticalMedium)
            .padding(.leading, 45)
            .focused($isFocused)
            .onChange(of: isFocused) {
                if isFocused {
                    selection = .init(range: locationName.startIndex ..< locationName.endIndex)
                }
            }
            .onSubmit {
                execute(.onStartSearch(locationName: locationName))
            }
            .overlay(
                HStack {
                    Assets.Icons.Button.search.swiftUIImage

                    Spacer()

                    Assets.Icons.Button.locate.swiftUIImage
                        .frame(width: .buttonWidth, height: .buttonHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            execute(.onClickLocate)
                        }
                }
                .padding(.horizontal, .horizontalDefault)
            )
    }

    private var sliderLabelText: some View {
        Text(L10n.News.Molo.Location.radius)
            .font(.moloContentDefault)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }

    private var sliderValueText: some View {
        Text("\(Int(radius)) " + L10n.News.Molo.Location.km)
            .opacity(invalidSelection ? 0.0 : 1.0)
            .font(.moloContentDefault)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }

    private var slider: some View {
        Slider(value: $radius, in: minRadius ... maxRadius, step: 1) { isEditing in
            if !isEditing {
                execute(.onChangeRadius(radius: radius))
            }
        }
        .onChange(of: radius) { _, _ in
            updateCameraPosition()
        }
        .tint(Colors.Map.overlay.swiftUIColor)
    }

    private var sliderInput: some View {
        VStack {
            HStack(spacing: 0) {
                sliderLabelText

                Spacer()

                sliderValueText
            }
            .padding(.bottom, .verticalXLarge)

            slider
        }
        .padding(.horizontal, .horizontalDefault)
        .padding(.vertical, .verticalLarge)
    }

    private var submitButton: some View {
        PrimaryButton(text: L10n.News.Molo.Location.submit) {
            execute(.onClickDone(closeAction: customSubmitAction))
        }
        .disabled(invalidSelection)
    }

    public var body: some View {
        ZStack(alignment: .top) {
            MapReader { _ in
                Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
                    ForEach(areas, id: \.self) { area in
                        if let latitude = Double(area.latitude),
                           let longitude = Double(area.longitude) {
                            Marker(
                                area.name,
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            )
                        }
                    }

                    if radius <= maxRadius {
                        MapCircle(
                            center: location,
                            radius: CLLocationDistance(radius * 1000)
                        )
                        .foregroundStyle(Colors.Map.overlay.swiftUIColor)
                        .mapOverlayLevel(level: .aboveLabels)
                    }

                    Annotation("", coordinate: location) {
                        Circle()
                            .fill(Colors.Map.locationPin.swiftUIColor)
                            .frame(width: 23, height: 23)
                            .overlay {
                                Circle()
                                    .stroke(Colors.Map.locationPinBorder.swiftUIColor, lineWidth: 5)
                            }
                    }
                }
                .mapStyle(.standard)
            }

            VStack(spacing: .verticalDefault) {
                locationInput
                    .inputBox()
                    .padding(.horizontal, .horizontalDefault)

                sliderInput
                    .inputBox()
                    .padding(.horizontal, .horizontalDefault)
            }
            .padding(.top, .verticalXLarge)

            VStack(spacing: 0) {
                Spacer()

                HStack(spacing: 0) {
                    Spacer()

                    submitButton
                        .frame(width: 150)
                }
            }
            .padding(.bottom, .verticalLarge)
            .padding(.horizontal, .horizontalDefault)
        }
    }

    private func updateCameraPosition() {
        cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion.region(
                center: location.shifted(latitudeOffsetKm: radius / 2.0),
                radiusInKm: radius + radius / 2.0
            )
        )
    }
}

private struct PostingLocationSelection: View {
    private let postingLocation: PostingLocation
    @State private var address: String
    private let latitude: Double
    private let longitude: Double

    private var location: CLLocationCoordinate2D
    @State private var cameraPosition: MapCameraPosition

    private let execute: (LocationSelectionIntent) -> Void

    init(
        postingLocation: PostingLocation,
        execute: @escaping (LocationSelectionIntent) -> Void
    ) {
        self.postingLocation = postingLocation
        address = postingLocation.addressDescription
        latitude = postingLocation.latitude
        longitude = postingLocation.longitude
        self.execute = execute

        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion.region(
                center: location,
                radiusInKm: 1 / 2.0
            )
        )
    }

    private var locationInput: some View {
        TextField("", text: $address)
            .textContentType(.addressCity)
            .autocorrectionDisabled(false)
            .textInputAutocapitalization(.words)
            .keyboardType(.default)
            .submitLabel(.search)
            .font(.moloContentDefault)
            .padding(.vertical, .verticalMedium)
            .padding(.leading, 45)
            .onSubmit {
                execute(.onStartSearch(locationName: address))
            }
            .overlay(
                HStack {
                    Assets.Icons.Button.search.swiftUIImage

                    Spacer()
                }
                .padding(.horizontal, .horizontalDefault)
            )
    }

    private var submitButton: some View {
        PrimaryButton(text: L10n.News.Molo.Location.submit) {
            execute(.onClickPostingLocationSelected(location: postingLocation))
        }
    }

    public var body: some View {
        ZStack(alignment: .top) {
            MapReader { _ in
                Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
                    Annotation("", coordinate: location) {
                        Circle()
                            .fill(Colors.Map.locationPin.swiftUIColor)
                            .frame(width: 23, height: 23)
                            .overlay {
                                Circle()
                                    .stroke(Colors.Map.locationPinBorder.swiftUIColor, lineWidth: 5)
                            }
                    }
                }
                .mapStyle(.standard)
            }

            VStack(spacing: .verticalDefault) {
                locationInput
                    .inputBox()
                    .padding(.horizontal, .horizontalDefault)
            }
            .padding(.top, .verticalXLarge)

            VStack(spacing: 0) {
                Spacer()

                HStack(spacing: 0) {
                    Spacer()

                    submitButton
                        .frame(width: 150)
                }
            }
            .padding(.bottom, .verticalLarge)
            .padding(.horizontal, .horizontalDefault)
        }
    }
}

#Preview("light") {
    LocationSelection(
        locationName: "Bremen",
        latitude: 53.07516,
        longitude: 8.80777,
        radius: 10,
        areas: [],
        execute: { _ in },
        customSubmitAction: nil
    )
    .preferredColorScheme(.light)
}

#Preview("dark") {
    LocationSelection(
        locationName: "Bremen",
        latitude: 53.07516,
        longitude: 8.80777,
        radius: 10,
        areas: [],
        execute: { _ in },
        customSubmitAction: nil
    )
    .preferredColorScheme(.dark)
}
