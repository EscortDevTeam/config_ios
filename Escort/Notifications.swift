//
//  Notofocations.swift
//  Escort
//
//  Created by Володя Зверев on 17.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let messagingDelegate = Messaging.messaging()
    
    func requestnotifications() {
        notificationCenter.delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        notificationCenter.requestAuthorization(options: authOptions) { (granted, error) in
            print("Permission granted: \(granted)")
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.getNotificationSettings()
        }
    }
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings : \(settings)")
            
            guard settings.authorizationStatus == .authorized else {return}
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func scheduleNotification(notificationType: String, time : Int) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notificationType
        content.body = "Очень большое при большое большое большое еще большое тестовое сообщение"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        guard let path = Bundle.main.path(forResource: "logo", ofType: "png") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo",
                                                      url: url,
                                                      options: nil)
            content.attachments = [attachment]
        } catch {
            print("The attachment cold not be loaded")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        
        let identifire = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            print("request: \(request)")
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Отложить на час", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Удалить", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("123")
        }
        print("response: \(response.notification.request)")
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default Action")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationType: "Reminder", time: 100)
        case "Delete":
            print("Delete")
        default:
            return
        }
        
        completionHandler()

    }
}

extension Notifications: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase reg: \(fcmToken)\n")
        
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(messaging)
    }
    
}
