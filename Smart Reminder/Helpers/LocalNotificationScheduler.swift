//
//  LocalNotificationScheduler.swift
//  Smart Reminder
//
//  Created by Aman Jain on 09/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation
import UserNotifications

struct LocalNotificationScheduler {
    
    static func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "You have scheduled a task in 5 mins."
        content.body = reminder.title ?? ""
        content.badge = 1
        content.sound = .default
        
        let timeInterval = reminder.dateTime!.timeIntervalSince1970 - Date().timeIntervalSince1970 - 300 //5*60 = 300 sec; showing notification before 5 mins
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: "\(reminder.objectID)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    static func invalidateNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(reminder.objectID)"])
    }
    
}
