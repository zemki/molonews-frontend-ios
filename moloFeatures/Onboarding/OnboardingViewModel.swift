//
//  OnboardingViewModel.swift
//  Onboarding
//

import Combine
import Domain
import FactoryKit
import Routing
import SwiftUI

@MainActor
public final class OnboardingViewModel: ObservableObject {
    @Published private(set) var state: OnboardingState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    private var currentStepIndex: Int = 0
    private let steps: [OnboardingState] = [
        .step1,
        .step2,
        .step3,
        .step4
    ]

    public init() {}

    func executeIntent(_ intent: OnboardingIntent) {
        switch intent {
        case .willAppear:
            state = .step1
        case .onClickNext:
            currentStepIndex += 1
            state = currentStepIndex < steps.count ? steps[currentStepIndex] : .done

            if case .done = state {
                StoreOnboardingShownUseCase(isShown: true)
                    .execute()
                    .sink { @MainActor _ in }
                    .store(in: &cancellables)
            }
        case .onClickPrevious:
            currentStepIndex = max(currentStepIndex - 1, 0)
            state = steps[currentStepIndex]
        }
    }
}
