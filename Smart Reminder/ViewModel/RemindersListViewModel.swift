//
//  RemindersListViewModel.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation

class RemindersListViewModel {
    
    public var upcomingReminders: [Reminder]?
    public var dueReminders: [Reminder]?
    
    func saveReminder(title: String?, dateTime: Date?) {
        let reminder = Reminder(context: PersistentStorage.shared.context)
        reminder.title = title
        reminder.dateTime = dateTime
        PersistentStorage.shared.saveContext()
        LocalNotificationScheduler.scheduleNotification(for: reminder)
    }
    
    func fetchReminders(completion: (() -> Void)) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Reminder.fetchRequest()) as? [Reminder] else {return}
            upcomingReminders = result.filter({!$0.isCompleted && !$0.dateTime!.isOverdue})
            dueReminders = result.filter({!$0.isCompleted && $0.dateTime!.isOverdue})
            completion()
        } catch let error {
            print(error.localizedDescription)
            completion()
        }
    }
    
    func delete(reminder: Reminder) {
        PersistentStorage.shared.context.delete(reminder)
        PersistentStorage.shared.saveContext()
        LocalNotificationScheduler.invalidateNotification(for: reminder)
    }
    
    func markAsComplete(reminder: Reminder) {
        reminder.isCompleted = true
        PersistentStorage.shared.saveContext()
        LocalNotificationScheduler.invalidateNotification(for: reminder)
    }
    
}
