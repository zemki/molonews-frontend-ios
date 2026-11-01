//
//  OnboardingView.swift
//  Onboarding
//

import Assets
import Atoms
import Foundation
import LocationSelection
import Molecules
import Organisms
import Strings
import SwiftUI
import Templates
import TopicSelection

public struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle:
                    EmptyView()
                        .transition(.opacity)
                case .step1:
                    Step1View(execute: viewModel.executeIntent(_:))
                        .transition(.opacity)
                case .step2:
                    Step2View(execute: viewModel.executeIntent(_:))
                        .transition(.opacity)
                case .step3:
                    Step3View(execute: viewModel.executeIntent(_:))
                        .transition(.opacity)
                case .step4:
                    Step4View(execute: viewModel.executeIntent(_:))
                        .transition(.opacity)
                case .done:
                    LoadingView()
                }
            }
            .animation(.easeInOut(duration: 0.5), value: viewModel.state)
        }
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .navigationBarBackButtonHidden(true)
        .padding(0)
    }
}

private struct Step1View: View {
    private let execute: (OnboardingIntent) -> Void

    init(execute: @escaping (OnboardingIntent) -> Void) {
        self.execute = execute
    }

    public var body: some View {
        OnboardingPageView(
            titleImage: Assets.Images.Onboarding.headshot1.swiftUIImage,
            backButtonImage: nil,
            pageIndicatorImage: Assets.Images.Onboarding.page1.swiftUIImage,
            titleString1: L10n.News.Molo.Onboarding.Step1.title1,
            titleString2: L10n.News.Molo.Onboarding.Step1.title2,
            titleString1Color: Colors.Text.onboardingAccent.swiftUIColor,
            titleString2Color: Colors.Text.onboarding.swiftUIColor,
            descriptionString: L10n.News.Molo.Onboarding.Step1.description,
            buttonString: L10n.News.Molo.Onboarding.Step1.next,
            buttonImage: Assets.Icons.Button.arrow.swiftUIImage,
            backAction: nil,
            action: { execute(.onClickNext) }
        )
    }
}

private struct Step2View: View {
    @StateObject var locationSelectionViewModel: LocationSelectionViewModel = LocationSelectionViewModel()
    
    @State private var showLocationSelection = false

    private let execute: (OnboardingIntent) -> Void

    init(execute: @escaping (OnboardingIntent) -> Void) {
        self.execute = execute
    }

    public var body: some View {
        OnboardingPageView(
            titleImage: Assets.Images.Onboarding.headshot2.swiftUIImage,
            backButtonImage: Assets.Icons.Button.arrowBack.swiftUIImage,
            pageIndicatorImage: Assets.Images.Onboarding.page2.swiftUIImage,
            titleString1: L10n.News.Molo.Onboarding.Step2.title1,
            titleString2: L10n.News.Molo.Onboarding.Step2.title2,
            titleString1Color: Colors.Text.onboarding.swiftUIColor,
            titleString2Color: Colors.Text.onboardingAccent.swiftUIColor,
            descriptionString: L10n.News.Molo.Onboarding.Step2.description,
            buttonString: L10n.News.Molo.Onboarding.Step2.next,
            buttonImage: Assets.Icons.Button.arrow.swiftUIImage,
            backAction: { execute(.onClickPrevious) },
            action: { showLocationSelection = true }
        )
        .sheet(
            isPresented: $showLocationSelection,
            onDismiss: {
                execute(.onClickNext)
            },
            content: {
                LocationSelectionView(viewModel: locationSelectionViewModel) {
                    showLocationSelection.toggle()
                }
                .interactiveDismissDisabled(true)
            }
        )
    }
}

private struct Step3View: View {
    @State private var showTopicSelection = false

    private let execute: (OnboardingIntent) -> Void

    init(execute: @escaping (OnboardingIntent) -> Void) {
        self.execute = execute
    }

    public var body: some View {
        OnboardingPageView(
            titleImage: Assets.Images.Onboarding.headshot3.swiftUIImage,
            backButtonImage: Assets.Icons.Button.arrowBack.swiftUIImage,
            pageIndicatorImage: Assets.Images.Onboarding.page3.swiftUIImage,
            titleString1: L10n.News.Molo.Onboarding.Step3.title1,
            titleString2: L10n.News.Molo.Onboarding.Step3.title2,
            titleString1Color: Colors.Text.onboardingAccent.swiftUIColor,
            titleString2Color: Colors.Text.onboarding.swiftUIColor,
            descriptionString: L10n.News.Molo.Onboarding.Step3.description,
            buttonString: L10n.News.Molo.Onboarding.Step3.next,
            buttonImage: Assets.Icons.Button.arrow.swiftUIImage,
            backAction: { execute(.onClickPrevious) },
            action: { showTopicSelection = true }
        )
        .sheet(
            isPresented: $showTopicSelection,
            onDismiss: {
                execute(.onClickNext)
            },
            content: {
                TopicSelectionView(viewModel: TopicSelectionViewModel(), initialSelection: 0) {
                    showTopicSelection.toggle()
                }
                .interactiveDismissDisabled(true)
            }
        )
    }
}

private struct Step4View: View {
    private let execute: (OnboardingIntent) -> Void

    init(execute: @escaping (OnboardingIntent) -> Void) {
        self.execute = execute
    }

    public var body: some View {
        OnboardingPageView(
            titleImage: Assets.Images.Onboarding.headshot4.swiftUIImage,
            backButtonImage: Assets.Icons.Button.arrowBack.swiftUIImage,
            pageIndicatorImage: Assets.Images.Onboarding.page4.swiftUIImage,
            titleString1: L10n.News.Molo.Onboarding.Step4.title1,
            titleString2: L10n.News.Molo.Onboarding.Step4.title2,
            titleString1Color: Colors.Text.onboardingAccent.swiftUIColor,
            titleString2Color: Colors.Text.onboarding.swiftUIColor,
            descriptionString: L10n.News.Molo.Onboarding.Step4.description,
            buttonString: L10n.News.Molo.Onboarding.Step4.next,
            buttonImage: Assets.Icons.Button.arrow.swiftUIImage,
            backAction: { execute(.onClickPrevious) },
            action: { execute(.onClickNext) }
        )
    }
}

#Preview("light") {
    OnboardingView(viewModel: OnboardingViewModel())
        .preferredColorScheme(.light)
}

#Preview("dark") {
    OnboardingView(viewModel: OnboardingViewModel())
        .preferredColorScheme(.dark)
}
