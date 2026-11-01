//
//  PushNotification.swift
//  moloApp
//

import Foundation
import UserNotifications
import Strings

@MainActor
class PushNotification: ObservableObject {
    @Published private(set) var hasPermission = false

    init() {
        Task {
            await getAuthStatus()
        }
    }

    func request() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await getAuthStatus()
        } catch {
            print(error)
            ToastNotification.shared.show(L10n.News.Molo.Notification.Push.error)
        }
    }

    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
             .ephemeral,
             .provisional:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}
