//
//  TabbarIntent.swift
//  moloApp
//

import Foundation

enum TabbarIntent {
    case onClickLocation
    case onClickTopics(tabSelection: TabIndex)
    case onClickProfile
    case onClickFab
    case onClickPostArticle
    case onClickPostEvent
    case onPasswordResetLinkOpened(token: String)
    case onRegistrationLogin(token: String)
}
