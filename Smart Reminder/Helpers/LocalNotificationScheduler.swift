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
        
        let dateAfterFiveMins = Date().addingTimeInterval(300) //5*60 = 300 sec; showing notification before 5 mins
        if let dueDate = reminder.dateTime, dueDate > dateAfterFiveMins {
            let timeInterval = dueDate.timeIntervalSince1970 - dateAfterFiveMins.timeIntervalSince1970
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "\(reminder.objectID)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    static func invalidateNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(reminder.objectID)"])
    }
    
}
