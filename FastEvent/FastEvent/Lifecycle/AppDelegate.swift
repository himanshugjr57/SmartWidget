//
//  AppDelegate.swift
//  FastEvent
//
//  Created by Apps4World on 10/10/23.
//

import UIKit
import Foundation
//import GoogleMobileAds
import RevenueCat
import OneSignalFramework
import Firebase
import FirebaseMessaging

struct FileCenter {
    static let revenueCatId = "appl_GgCcaoIVeudGsRdDTXaSpVewARd"
    static let OneSignalId = "b0519094-fa20-4c22-9810-14811e646487"
    static let firebaseServerKey = "AAAAC2DPs7E:APA91bHYqkrNjuNcpE4h8YJJiNB_0k90XR2cf2xAbH6jfL6OmoEmnmQ-DutcIPatKjdNcrQvpCloJbXZXvEc9UCZ9W4yZPO6jh4kCofemoGeLe7DFnyfX6mEEe45nNRJK6qCV4wHvvxC"
}

/// App Delegate file in SwiftUI
class AppDelegate: NSObject, UIApplicationDelegate {
    
    static let sharedInstance = AppDelegate()
    let notificationCenter = UNUserNotificationCenter.current()
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)

        FirebaseApp.configure()
        
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: FileCenter.revenueCatId)
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        // OneSignal initialization
        OneSignal.initialize(FileCenter.OneSignalId, withLaunchOptions: launchOptions)

        
        // requestPermission will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission({ accepted in
          print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        RemoteConfigHelper.sharedInstance.setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RemoteConfigHelper.sharedInstance.fetchRemoteConfig()
        }
        if Defaults[.InstalationDate] == "" {
            Defaults[.InstalationDate] = Date().shortDate
        }

        Messaging.messaging().delegate = self
        self.setNotificationPermission()

        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func subscribe(topic: String) {
        Messaging.messaging().subscribe(toTopic: "\(topic)") { error in
            if let error = error {
                print("--- subscribe() error : ", error.localizedDescription)
            } else {
                print("Subscribed to \(topic) topic")
            }
        }
    }
    
    func unsubscribe(topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: "\(topic)") { error in
            if let error = error {
                print("--- unsubscribe() error : ", error.localizedDescription)
            } else {
                print("Unsubscribed to \(topic) topic")
            }
        }
    }
    
    func logoutSetup() {
        FirebaseMessaging.Messaging.messaging().isAutoInitEnabled = false
        FirebaseMessaging.Messaging.messaging().deleteToken { error in
            guard let error = error else {
                print("Delete FCMToken successful!")
                return
            }
            print("Delete FCMToken failed: \(String(describing: error.localizedDescription))!")
        }
        FirebaseMessaging.Messaging.messaging().deleteData { error in
            guard let error = error else {
                print("Delete FCMToken successful!")
                return
            }
            print("Delete FCMToken failed: \(String(describing: error.localizedDescription))!")
        }
    }
    
    func sentNotificationToSharedUser(email: String, userName: String) {
        let parameters: [String: Any] = [
            "to": "/topics/\(email)",
            "notification": [
                "title": "Discover your new shared widget!",
                "body": "You've received a special widget from \(userName)"
            ],
            "data": [
                "data": [
                    "title": "Discover your new shared widget!",
                    "body": "You've received a special widget from \(userName)",
                    "category": "SHARED_WIDGET"
                ]
            ]
        ]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "key=\(FileCenter.firebaseServerKey)"
        ]

        // Convert parameters to Data
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Error converting parameters to JSON data")
            return
        }

        // Create the URLRequest
        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        // Create URLSession and data task
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("PushNotification Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("PushNotification Response: \(responseString)")
                }
            } else {
                print("HTTP Error: \(httpResponse.statusCode)")
            }
        }

        // Resume the task
        task.resume()
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func setNotificationPermission() {
        self.notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        self.notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: options) { (granted, error) in
                    if granted {
                        print("User gave permissions for local notification..")
                    } else {
                        print("Permission denied..")
                    }
                }
            } else if settings.authorizationStatus == .denied {
                print("Denied")
            } else if settings.authorizationStatus == .authorized {
                print("Authorized")
            }
        })
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken, token.count != 0 {
            print("Firebase registration token: \(token)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        if application.applicationState == .background {
            print("didReceiveRemoteNotification BACKGROUND")
        } else if application.applicationState == .inactive {
            print("didReceiveRemoteNotification INACTIVE")
        }
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.content.sound != nil {
            completionHandler([.banner, .sound, .badge, .list])
        } else {
            completionHandler([.banner, .badge, .list])
        }
    }
}
