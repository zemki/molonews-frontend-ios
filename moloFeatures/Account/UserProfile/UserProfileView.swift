//
//  UserProfileView.swift
//  Account
//

import Assets
import Atoms
import Domain
import Foundation
import Molecules
import PhotosUI
import Strings
import SwiftUI

public struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel

    public init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(userProfile):
                Profile(userProfile: userProfile, execute: viewModel.executeIntent(_:))
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .padding(0)
    }
}

private struct Profile: View {
    private let execute: (UserProfileIntent) -> Void

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var displayName: String = ""
    @State private var description: String = ""
    @State private var area: Area?
    @State private var location: String = ""
    @State private var email: String = ""
    @State private var homepage: String = ""

    @State private var presentPhotosPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    @State private var presentSourceAlert: Bool = false
    @State private var sourceName: String = ""

    @State private var presentSaveAlert: Bool = false

    private let userProfile: UserProfile

    @State private var dataHasChanged: Bool = false

    init(userProfile: UserProfile, execute: @escaping (UserProfileIntent) -> Void) {
        _firstName = State(initialValue: userProfile.firstName)
        _lastName = State(initialValue: userProfile.lastName)
        _displayName = State(initialValue: userProfile.displayName)
        _description = State(initialValue: userProfile.description)
        _area = State(initialValue: userProfile.area)
        _location = State(initialValue: userProfile.area?.name ?? "")
        _email = State(initialValue: userProfile.email)
        _homepage = State(initialValue: userProfile.homepage)

        self.execute = execute

        self.userProfile = userProfile
    }

    private var publicInputStack: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.prename,
                textContentType: .givenName,
                contentBinding: $firstName,
                errorBinding: .constant(false)
            )
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.lastname,
                textContentType: .familyName,
                contentBinding: $lastName,
                errorBinding: .constant(false)
            )
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.displayName,
                textContentType: .username,
                contentBinding: $displayName,
                errorBinding: .constant(false)
            )
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.description,
                textContentType: nil,
                reserveSpace: true,
                contentBinding: $description,
                errorBinding: .constant(false)
            )
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.location,
                textContentType: .addressCity,
                contentBinding: $location,
                errorBinding: .constant(false)
            )
        }
    }

    private var privateInputStack: some View {
        VStack(alignment: .leading, spacing: .verticalLarge) {
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.email,
                textContentType: .emailAddress,
                contentBinding: $email,
                errorBinding: .constant(false)
            )
            ProfileTextField(
                label: L10n.News.Molo.Profile.Input.homepage,
                textContentType: .URL,
                contentBinding: $homepage,
                errorBinding: .constant(false)
            )
        }
    }

    private var publicTitleText: some View {
        Text(L10n.News.Molo.Profile.Title.public)
            .font(.moloSubheading)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }

    private var privateTitleText: some View {
        Text(L10n.News.Molo.Profile.Title.private)
            .font(.moloSubheading)
            .lineLimit(1)
            .foregroundStyle(Colors.Text.default.swiftUIColor)
    }

    private var submitButton: some View {
        PrimaryButton(
            text: L10n.News.Molo.Profile.Action.save,
            onClick: onSave
        )
    }

    private var onSave: () -> Void {
        {
            execute(
                .onClickSave(
                    userProfile: UserProfile(
                        username: displayName,
                        firstName: firstName,
                        lastName: lastName,
                        description: description,
                        email: email,
                        displayName: displayName,
                        area: area,
                        homepage: homepage
                    ),
                    imageData: selectedImageData,
                    filename: "\(UUID().uuidString).jpg",
                    source: sourceName
                )
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileImage(imageUrlString: userProfile.imageUrl, imageData: selectedImageData)
                    .padding(.bottom, .verticalXLarge)
                    .onTapGesture {
                        presentPhotosPicker = true
                    }

                VStack(alignment: .leading, spacing: 0) {
                    publicTitleText
                        .padding(.bottom, .verticalDefault)

                    publicInputStack
                        .padding(.bottom, .verticalXLarge)

                    privateTitleText
                        .padding(.bottom, .verticalDefault)

                    privateInputStack
                        .padding(.bottom, .verticalXLarge)
                }

                submitButton
                    .frame(height: .buttonHeight)
                    .padding(.bottom, 200)
            }
        }
        .padding(.horizontal, .horizontalDefault)
        .toolbar {
            DetailTopNavigation(
                backAction: {
                    if dataHasChanged {
                        presentSaveAlert = true
                    } else {
                        execute(.onClickBack)
                    }
                }
            )
        }
        .photosPicker(isPresented: $presentPhotosPicker, selection: $selectedPhotoItem)
        .onChange(of: selectedPhotoItem) { _, newValue in
            dataHasChanged = true

            Task {
                if let newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let jpg = uiImage.jpegData(compressionQuality: 1.0) {
                    selectedImageData = jpg
                    presentSourceAlert = true
                }
            }
        }
        .onChange(of: [firstName, lastName, displayName, description, location, email, homepage]) { _, _ in
            dataHasChanged = true
        }
        .alert(L10n.News.Molo.Posting.Image.Alert.title, isPresented: $presentSourceAlert, actions: {
            TextField(L10n.News.Molo.Posting.Image.Alert.placeholder, text: $sourceName)
            Button(L10n.News.Molo.Posting.Image.Alert.ok) {}
                .disabled(sourceName.isEmpty)
        })
        .alert(L10n.News.Molo.Profile.Cancel.Alert.title, isPresented: $presentSaveAlert) {
            Button(L10n.News.Molo.Profile.Cancel.Alert.delete, role: .destructive) {
                execute(.onClickBack)
            }
            Button(L10n.News.Molo.Profile.Cancel.Alert.save, role: .none) {
                onSave()
            }
        } message: {
            Text(L10n.News.Molo.Profile.Cancel.Alert.message)
        }
        .onAppear {
            if selectedImageData == nil {
                selectedImageData = userProfile.imageData
            }

            sourceName = userProfile.displayName
        }
    }
}
