//
//  AppDelegate.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 30.06.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UserNotifications
import MetricKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("next")
    }
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if #available(iOS 13.0, *) {
        MXMetricManager.shared.add(self)
    } else {
        // Fallback on earlier versions
    }
    let navgiationController = UINavigationController()
    navgiationController.navigationBar.isHidden = true
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    //        navgiationController.interactivePopGestureRecognizer?.isEnabled = true
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    if launchedBefore  {
        print("Not first launch.")
        code = UserDefaults.standard.string(forKey: "code") ?? code
        isNight = UserDefaults.standard.bool(forKey: "isNight")
        if isNight {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        } else {
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
            } else {
                // Fallback on earlier versions
            }
        }
    } else {
        print("First launch, setting UserDefault.")
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        UserDefaults.standard.set(code, forKey: "code")
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
        } else {
            // Fallback on earlier versions
        }
        //            if UIApplication.shared.statusBarStyle == UIStatusBarStyle.darkContent {
        //                isNight = true
        //            } else {
        //                isNight = false
        //            }
    }
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let newViewController = storyBoard.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
    newViewController.modalPresentationStyle = .fullScreen
    navgiationController.pushViewController(StartScreenController(), animated: true)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = navgiationController
    window?.makeKeyAndVisible()
    FirebaseApp.configure()

    // [START set_messaging_delegate]
    Messaging.messaging().delegate = self
    // [END set_messaging_delegate]
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()

    // [END register_for_notifications]
    return true
  }
    //MARK: - ZIPFile
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let rootViewController = self.window!.rootViewController as! UINavigationController
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dfuViewController = mainStoryboard.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
        print(url)
        let alert = UIAlertController(title: "\(url.lastPathComponent)", message: "Архив загружен в приложение", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            rootViewController.pushViewController(dfuViewController, animated: true)
        }))
        if urlFile != nil {
            rootViewController.pushViewController(dfuViewController, animated: true)
            print("url: \(url)")
            dfuViewController.onFileImported(withURL: url)
        }
        urlFile = url
        return true
    }
    
  // [START receive_message]
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
  }
    func applicationWillTerminate(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
            MXMetricManager.shared.remove(self)
        } else {
            // Fallback on earlier versions
        }
    }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler(UIBackgroundFetchResult.newData)
  }
  // [END receive_message]
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
  // the FCM registration token.
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")
    // With swizzling disabled you must set the APNs token here.
    // Messaging.messaging().apnsToken = deviceToken
  }
}

extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo["aps"] {
      print("Message ID: \(messageID)")
//        print("Message ID3: \(userInfo["9"])")

    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID2: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(fcmToken)")
//    Messaging.messaging().shouldEstablishDirectChannel = true

    let dataDict:[String: String] = ["token": fcmToken!]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
  // [START ios_10_data_message]
  // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
  // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    
//  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//    print("Received data message: \(remoteMessage.appData)")
//  }
  // [END ios_10_data_message]
}

extension AppDelegate: MXMetricManagerSubscriber {
    @available(iOS 13.0, *)
    func didReceive(_ payloads: [MXMetricPayload]) {
        print("metric")
    }
}
