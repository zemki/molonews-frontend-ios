//
//  Coordinator.swift
//  Navigation
//

import Combine
import Domain
import SwiftUI

@MainActor
public class Coordinator: ObservableObject {
    // @Published public var exploreStack: [StackRouteExplore] = []
    @Published public var eventsStack: [StackRouteEvent] = []
    @Published public var feedStack: [StackRouteFeed] = []
    @Published public var watchlistStack: [StackRouteWatchlist] = []
    @Published public var participateStack: [StackRouteParticipate] = []
    @Published public var searchStack: [StackRouteSearch] = []

    @Published public var presentedSheets: [SheetRoute] = []
    @Published public var presentFabActionSheet: Bool = false

    public var dismissSheetCallback: (() -> Void)?

    public nonisolated init() {}

    public enum Tab {
        case explore,
             events,
             feed,
             watchlist,
             participate
    }

    // public enum StackRouteExplore: StackProtocol {}

    public enum StackRouteEvent: StackProtocol {}

    public enum StackRouteFeed: StackProtocol {}

    public enum StackRouteWatchlist: StackProtocol {}

    public enum StackRouteParticipate: StackProtocol {}

    public enum StackRouteSearch: StackProtocol {}

    public enum SheetRoute: Hashable, Identifiable, Equatable {
        case articleDetail(id: Int)
        case eventDetail(id: Int)
        case organizationDetail(id: Int, fromArticles: Bool)

        case locationSelection
        case topicsSelection(topicsTab: Int)
        case sourcesSelection

        case feedbackInAppEmail

        case webContent(urlString: String)

        case postArticle(id: Int?)
        case postEvent(id: Int?)
        case selectEventDateRange(start: Date?, end: Date?, result: (Date, Date) -> Void)
        case selectEventLocation(location: PostingLocation?, result: (PostingLocation) -> Void)

        case login
        case register
        case confirmRegsitration
        case passwordLost

        case editUserProfile(callback: () -> Void)

        public var id: Self { self }

        public static func == (lhs: SheetRoute, rhs: SheetRoute) -> Bool {
            switch (lhs, rhs) {
            case let (.articleDetail(a), .articleDetail(b)): return a == b
            case let (.eventDetail(a), .eventDetail(b)): return a == b
            case let (.organizationDetail(a1, a2), .organizationDetail(b1, b2)): return a1 == b1 && a2 == b2
            case (.locationSelection, .locationSelection): return true
            case let (.topicsSelection(a), .topicsSelection(b)): return a == b
            case (.sourcesSelection, .sourcesSelection): return true
            case (.feedbackInAppEmail, .feedbackInAppEmail): return true
            case let (.webContent(a), .webContent(b)): return a == b
            case let (.postArticle(a), .postArticle(b)): return a == b
            case let (.postEvent(a), .postEvent(b)): return a == b
            case let (.selectEventDateRange(startA, endA, _), .selectEventDateRange(startB, endB, _)): return startA == startB && endA == endB
            case let (.selectEventLocation(a, _), .selectEventLocation(b, _)): return a?.latitude == b?.latitude && a?.longitude == b?.longitude
            case (.login, .login): return true
            case (.register, .register): return true
            case (.confirmRegsitration, .confirmRegsitration): return true
            case (.passwordLost, .passwordLost): return true
            case (.editUserProfile, .editUserProfile): return true
            default: return false
            }
        }

        public func hash(into hasher: inout Hasher) {
            switch self {
            case let .articleDetail(id):
                hasher.combine(0)
                hasher.combine(id)
            case let .eventDetail(id):
                hasher.combine(1)
                hasher.combine(id)
            case let .organizationDetail(id, fromArticles):
                hasher.combine(2)
                hasher.combine(id)
                hasher.combine(fromArticles)
            case .locationSelection:
                hasher.combine(3)
            case let .topicsSelection(tab):
                hasher.combine(4)
                hasher.combine(tab)
            case .sourcesSelection:
                hasher.combine(5)
            case .feedbackInAppEmail:
                hasher.combine(6)
            case let .webContent(urlString):
                hasher.combine(7)
                hasher.combine(urlString)
            case let .postArticle(id):
                hasher.combine(8)
                hasher.combine(id)
            case let .postEvent(id):
                hasher.combine(9)
                hasher.combine(id)
            case let .selectEventDateRange(start, end, _):
                hasher.combine(10)
                hasher.combine(start)
                hasher.combine(end)
            case let .selectEventLocation(location, _):
                hasher.combine(11)
                hasher.combine(location?.latitude)
                hasher.combine(location?.longitude)
            case .login:
                hasher.combine(12)
            case .register:
                hasher.combine(13)
            case .confirmRegsitration:
                hasher.combine(14)
            case .passwordLost:
                hasher.combine(15)
            case .editUserProfile:
                hasher.combine(16)
            }
        }
    }

    public func push(_ route: any StackProtocol) {
        switch route {
        case is StackRouteSearch:
            searchStack.append(route as! StackRouteSearch)
        case is StackRouteEvent:
            eventsStack.append(route as! StackRouteEvent)
        case is StackRouteFeed:
            feedStack.append(route as! StackRouteFeed)
        case is StackRouteWatchlist:
            watchlistStack.append(route as! StackRouteWatchlist)
        case is StackRouteParticipate:
            participateStack.append(route as! StackRouteParticipate)
        default:
            fatalError("Unsupported route type")
        }
    }

    public func showSheet(_ route: SheetRoute, stacked: Bool = false) {
        if !stacked, !presentedSheets.isEmpty {
            dismissSheetCallback = { [weak self] in
                self?.presentedSheets.append(route)
            }
            presentedSheets.removeLast()
        } else {
            presentedSheets.append(route)
        }
    }

    public func back(on route: (any StackProtocol)?) {
        if !presentedSheets.isEmpty {
            presentedSheets.removeLast()
        } else {
            switch route {
            case is StackRouteSearch:
                searchStack.removeLast(1)
            case is StackRouteEvent:
                eventsStack.removeLast(1)
            case is StackRouteFeed:
                feedStack.removeLast(1)
            case is StackRouteWatchlist:
                watchlistStack.removeLast(1)
            case is StackRouteParticipate:
                participateStack.removeLast(1)
            default:
                fatalError("Unsupported route type")
            }
        }
    }
}
