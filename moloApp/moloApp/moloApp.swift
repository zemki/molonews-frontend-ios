//
//  moloApp.swift
//  moloApp
//

import Assets
import Combine
import DataLayer
import Domain
import Events
import Explore
import Feed
import FirebaseCore
import FirebaseMessaging
import Participate
import Routing
import Strings
import SwiftUI
import Watchlist

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    private var cancellables = Set<AnyCancellable>()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            PushRouter.shared.handle(userInfo: userInfo)
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            StorePushTokenUseCase(token: fcm)
                .execute()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] useCaseState in
                    switch useCaseState {
                    case .isLoading:
                        break
                    case .success:
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

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        PushRouter.shared.handle(userInfo: userInfo)
    }
}

@main
struct moloApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        setDatePickerAppearance()
        setTabbarAppearance()
        setNavBarAppearance()
        setSearchbarAppearance()
    }

    // MARK: - View

    var body: some Scene {
        WindowGroup {
            TabbarView()
        }
    }

    private func setDatePickerAppearance() {
        UIDatePicker.appearance().minuteInterval = 5
    }

    private func setTabbarAppearance() {
        if #unavailable(iOS 26.0) {
            let appearance = UITabBarAppearance()

            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Colors.Background.tabbar.color
            appearance.stackedLayoutAppearance.normal.iconColor = Colors.Text.ios18TabbarUnselected.color
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: Colors.Text.ios18TabbarUnselected.color]
            appearance.stackedLayoutAppearance.selected.iconColor = Colors.Text.ios18TabbarSelected.color
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: Colors.Text.ios18TabbarSelected.color]

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    private func setNavBarAppearance() {
        if #unavailable(iOS 26.0) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    private func setSearchbarAppearance() {
        if #unavailable(iOS 26.0) {
            UISearchBar.appearance().tintColor = Colors.Text.searchbar.color
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = Colors.Background.searchbar.color
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        }
    }
}
