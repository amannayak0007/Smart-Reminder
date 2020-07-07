//
//  RemindersListViewModel.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation

class RemindersListViewModel {
    
    public var reminders: [Reminder]?
    
    func saveReminder() {
        let reminder = Reminder(context: PersistentStorage.shared.context)
        reminder.dateTime = Date()
        reminder.title = "Hello Steve"
        
        let reminder1 = Reminder(context: PersistentStorage.shared.context)
        reminder1.dateTime = Date()
        reminder1.title = "Hello Aman"
        
        let reminder2 = Reminder(context: PersistentStorage.shared.context)
        reminder2.dateTime = Date()
        reminder2.title = "Hello Bob"
        
        let reminder3 = Reminder(context: PersistentStorage.shared.context)
        reminder3.dateTime = Date()
        reminder3.title = "Hello Jhon"
        
        PersistentStorage.shared.saveContext()
    }
    
    func fetchReminders(completion: (() -> Void)) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Reminder.fetchRequest()) as? [Reminder] else {return}
            reminders = result
            completion()
        } catch let error {
            print(error.localizedDescription)
            completion()
        }
    }
    
}
