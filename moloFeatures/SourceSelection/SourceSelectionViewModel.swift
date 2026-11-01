//
//  SourceSelectionViewModel.swift
//  SourceSelection
//

import Combine
import Domain
import FactoryKit
import Foundation
import Routing
import Strings
import SwiftUI

@MainActor
public final class SourceSelectionViewModel: ObservableObject {
    @Published private(set) var state: SourceSelectionState = .idle

    @Injected(\.coordinator) private var coordinator: Coordinator?

    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var newsOrganizations: [Organization] = []
    @Published private(set) var officialOrganizations: [Organization] = []
    @Published private(set) var collectiveOrganizations: [Organization] = []

    public init() {}

    func executeIntent(_ intent: SourceSelectionIntent) {
        switch intent {
        case let .toggleNews(id):
            toggleNews(id: id)
        case let .toggleOfficial(id: id):
            toggleOfficial(id: id)
        case let .toggleCollective(id: id):
            toggleCollective(id: id)
        case let .onClickOrganization(id):
            coordinator?.showSheet(.organizationDetail(id: id, fromArticles: true), stacked: true)
        case .onClickBack:
            coordinator?.back(on: nil)
        }
    }

    func loadOrganizations() {
        FetchOrganizationsForTypeUseCase(type: .all)
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] useCaseState in
                switch useCaseState {
                case .isLoading:
                    self?.state = .loading
                case let .success(organizations):
                    self?.newsOrganizations = organizations.filter { organization in
                        organization.type == .news
                    }
                    self?.officialOrganizations = organizations.filter { organization in
                        organization.type == .official
                    }
                    self?.collectiveOrganizations = organizations.filter { organization in
                        organization.type == .collective
                    }

                    self?.state = .success
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func toggleNews(id: Int) {
        guard case .success = state,
              let index = newsOrganizations.firstIndex(
                  where: { organization in
                      organization.id == id
                  }
              ) else {
            return
        }

        newsOrganizations[index].isSelected.toggle()

        if newsOrganizations[index].isSelected {
            addToSources(id)
        } else {
            removeFromSources(id)
        }

        state = .success
    }

    private func toggleOfficial(id: Int) {
        guard case .success = state,
              let index = officialOrganizations.firstIndex(
                  where: { organization in
                      organization.id == id
                  }
              ) else {
            return
        }

        officialOrganizations[index].isSelected.toggle()

        if officialOrganizations[index].isSelected {
            addToSources(id)
        } else {
            removeFromSources(id)
        }
        state = .success
    }

    private func toggleCollective(id: Int) {
        guard case .success = state,
              let index = collectiveOrganizations.firstIndex(
                  where: { organization in
                      organization.id == id
                  }
              ) else {
            return
        }

        collectiveOrganizations[index].isSelected.toggle()

        if collectiveOrganizations[index].isSelected {
            addToSources(id)
        } else {
            removeFromSources(id)
        }

        state = .success
    }

    private func addToSources(_ organizationId: Int) {
        AddOrganizationToSourcesUsesCase(organizationId: organizationId)
            .execute()
            .receive(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { useCaseState in
                switch useCaseState {
                case .isLoading,
                     .success:
                    break
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }

    private func removeFromSources(_ organizationId: Int) {
        RemoveOrganizationFromSourcesUseCase(organizationId: organizationId)
            .execute()
            .receive(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { useCaseState in
                switch useCaseState {
                case .isLoading,
                     .success:
                    break
                case let .error(useCaseError):
                    NotificationCenter.default.post(name: .useCaseErrorNotification, object: useCaseError)
                @unknown default:
                    fatalError("[Error] unhandled use case state in \(String(describing: self))")
                }
            }
            .store(in: &cancellables)
    }
}
