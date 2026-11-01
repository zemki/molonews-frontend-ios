//
//  Notification+Name.swift
//  Domain
//

import Foundation

public enum NotificationName: String {
    case useCaseError,
         articleReported,
         locationChanged,
         locationError,
         articleTagsChanged,
         eventTagsChanged,
         sourceSelectionChangedNotification,
         eventStorageNoAccessNotification,
         articlePosted,
         eventPosted
}

public extension Notification.Name {
    static let useCaseErrorNotification = Notification.Name(NotificationName.useCaseError.rawValue)

    static let articleReportedNotification = Notification.Name(NotificationName.articleReported.rawValue)

    static let locationChangedNotification = Notification.Name(NotificationName.locationChanged.rawValue)
    static let locationErrorNotification = Notification.Name(NotificationName.locationError.rawValue)
    
    static let articleTagsChangedNotification = Notification.Name(NotificationName.articleTagsChanged.rawValue)
    static let eventTagsChangedNotification = Notification.Name(NotificationName.eventTagsChanged.rawValue)
    
    static let sourceSelectionChangedNotification = Notification.Name(NotificationName.sourceSelectionChangedNotification.rawValue)
    
    static let articlePostedNotification = Notification.Name(NotificationName.articlePosted.rawValue)
    static let eventPostedNotification = Notification.Name(NotificationName.eventPosted.rawValue)

    static let eventStorageNoAccessNotification = Notification.Name(NotificationName.eventStorageNoAccessNotification.rawValue)
}
