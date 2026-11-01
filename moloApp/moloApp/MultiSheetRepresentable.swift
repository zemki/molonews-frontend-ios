//
//  MultiSheetRepresentable.swift
//  moloApp
//

import Account
import ArticleDetail
import Assets
import Atoms
import DataLayer
import Dimensions
import Domain
import EventDetails
import Events
import Explore
import FactoryKit
import Feed
import InAppEmail
import LocationSelection
import MessageUI
import Modifiers
import OrganizationDetail
import Participate
import Postings
import Routing
import SourceSelection
import Strings
import SwiftUI
import TopicSelection
import Watchlist
import WebContent

struct MultiSheetRepresentable: UIViewControllerRepresentable {
    @Binding var presentedSheets: [Routing.Coordinator.SheetRoute]

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        context.coordinator.hostingControllers = []
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        var currentControllers = context.coordinator.hostingControllers
        let targetRoutes = presentedSheets

        while currentControllers.count > targetRoutes.count {
            guard let top = currentControllers.last else {
                break
            }

            currentControllers.removeLast()

            if let presenter = top.presentingViewController {
                presenter.dismiss(animated: true)
            } else {
                top.dismiss(animated: true)
            }
        }

        for (index, route) in targetRoutes.enumerated() {
            if index < currentControllers.count {
                continue
            } else {
                let hosting = UIHostingController(
                    rootView: AnyView(viewForRoute(route))
                        .id(route.id)
                        .onDisappear {
                            // Beim Dismiss den Stack synchronisieren
                            DispatchQueue.main.async {
                                if let idx = presentedSheets.firstIndex(of: route) {
                                    presentedSheets.remove(at: idx)
                                }
                            }
                        }
                )
                currentControllers.append(hosting)

                let presenter = index == 0 ? uiViewController : currentControllers[index - 1]
                presenter.present(hosting, animated: true)
            }
        }

        context.coordinator.hostingControllers = currentControllers
    }

    private func viewForRoute(_ sheet: Routing.Coordinator.SheetRoute) -> any View {
        switch sheet {
        case let .articleDetail(id):
            let articleDetailViewModel = ArticleDetailViewModel(articleId: id)
            return ArticleDetailView(viewModel: articleDetailViewModel)
        case let .eventDetail(id):
            let viewModel = EventDetailViewModel(eventId: id)
            return EventDetailView(viewModel: viewModel)
        case let .organizationDetail(id, showArticles):
            let organizationDetailViewModel = OrganizationDetailViewModel(organizationId: id)
            return OrganizationDetailView(viewModel: organizationDetailViewModel, showArticles: showArticles)
        case .locationSelection:
            let locationSelectionViewModel = LocationSelectionViewModel()
            return LocationSelectionView(viewModel: locationSelectionViewModel)
        case let .topicsSelection(tab):
            let topicSelectionViewModel = TopicSelectionViewModel()
            return TopicSelectionView(viewModel: topicSelectionViewModel, initialSelection: tab)
        case .sourcesSelection:
            let sourcesViewModel = SourceSelectionViewModel()
            return SourceSelectionView(viewModel: sourcesViewModel)
        case .feedbackInAppEmail:
            if MFMailComposeViewController.canSendMail() {
                let inAppEmailViewModel = InAppEmailViewModel()
                return InAppEmailView(viewModel: inAppEmailViewModel)
            }
        case let .webContent(urlString):
            let webContentViewModel = WebContentViewModel(urlString: urlString)
            return WebContentView(viewModel: webContentViewModel)
        case let .editUserProfile(callback):
            let userProfileViewModel = UserProfileViewModel(callback: callback)
            return UserProfileView(viewModel: userProfileViewModel)
        case .login:
            let loginViewModel = LoginViewModel()
            return LoginView(viewModel: loginViewModel)
        case .register:
            let registerViewModel = RegistrationViewModel()
            return RegistrationView(viewModel: registerViewModel)
        case .confirmRegsitration:
            let confirmViewModel = RegistrationConfirmationViewModel()
            return RegistrationConfirmationView(viewModel: confirmViewModel)
        case .passwordLost:
            let passwordLostViewModel = PasswordLostViewModel()
            return PasswordLostView(viewModel: passwordLostViewModel)
        case let .postArticle(id):
            let articlePostViewModel = ArticlePostingViewModel(articleId: id)
            return ArticlePostingView(viewModel: articlePostViewModel)
                .interactiveDismissDisabled(true)
        case let .postEvent(id):
            let eventPostViewModel = EventPostingViewModel(eventId: id)
            return EventPostingView(viewModel: eventPostViewModel)
                .interactiveDismissDisabled(true)
        case let .selectEventDateRange(start, end, result):
            let dateSelectionViewModel = DateSelectionViewModel(startDate: start, endDate: end, dateSelectionCallback: result)
            return DateSelectionView(viewModel: dateSelectionViewModel)
        case let .selectEventLocation(location, result):
            let locationSelectionViewModel = LocationSelectionViewModel(postingLocation: location, locationSelectionCallback: result)
            return LocationSelectionView(viewModel: locationSelectionViewModel)
        @unknown default:
            fatalError("[ERROR] unknown navigation route for presenting sheet")
        }

        return EmptyView()
    }

    class Coordinator {
        var hostingControllers: [UIViewController] = []
    }
}
