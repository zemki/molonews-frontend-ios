//
//  Factory+Registration.swift
//  moloApp
//

import DataLayer
import Domain
import FactoryKit
import Foundation
import Routing

extension Container: @retroactive AutoRegistering {
    public func autoRegister() {
        // MARK: - API

        apiClient.register {
            MoloClient()
        }

        // MARK: - Routing

        coordinator.register {
            Coordinator()
        }

        // MARK: - Repositories

        accountRepository.register {
            AccountRepository()
        }

        articlesRepository.register {
            ArticleRepository()
        }

        eventsRepository.register {
            EventRepository()
        }

        tagRepository.register {
            TagRepository()
        }

        organizationRepository.register {
            OrganizationRepository()
        }

        locationRepository.register {
            LocationRepository()
        }

        searchRepository.register {
            SearchRepository()
        }
    }
}
