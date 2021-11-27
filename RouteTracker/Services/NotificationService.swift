//
//  NotificationService.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 28.11.2021.
//

import Foundation
import UserNotifications

class NotificationService {
    private init () {}
    
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    
    func request() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение получено.")
            } else {
                print("Разрешение не получено.")
            }
        }
    }
    
    func checkAuth() -> Bool {
        var authorized = false
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                authorized = true
            }
        }
        return authorized
    }
    
    func sendNotificationRequest() {
        
        if checkAuth() != true {
            return
        }
        
        let content = makeNotificationContent()
        let trigger = makeIntervalNotificatioTrigger()
        
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: content,
            trigger: trigger
            )
        
        center.add(request)
    }
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Продолжите отслеживание"
        content.subtitle = "вашего местоположения"
        content.body = "Вернитесь в приложение для отслеживания маршрута"
        content.badge = 1
        return content
    }
    
    private func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(
            timeInterval: 60*30,
            repeats: false
            )
    }
    
}
