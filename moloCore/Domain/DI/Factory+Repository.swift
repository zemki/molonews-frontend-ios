//
//  Factory+Repository.swift
//  moloApp
//

import FactoryKit
import Foundation

public extension Container {
    // MARK: - Repositories

    var accountRepository: Factory<AccountRepositoryType?> { promised() }

    var articlesRepository: Factory<ArticleRepositoryType?> { promised() }

    var eventsRepository: Factory<EventRepositoryType?> { promised() }

    var tagRepository: Factory<TagRepositoryType?> { promised() }

    var organizationRepository: Factory<OrganizationRepositoryType?> { promised() }
    
    var locationRepository: Factory<LocationRepositoryType?> { promised() }
    
    var searchRepository: Factory<SearchRepositoryType?> { promised() }

    var userProfile: Factory<UserProfile?> {
        self {
            nil
        }
        .singleton
    }
}
