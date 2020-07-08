//
//  TasksListModel.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation

enum TaskCategory: String {
    case Vehicle = "Vehicle"
    case Apparels = "Apparels"
    case Groceries = "Groceries"
    case Books = "Books"
    
    var taskList: [String] {
        switch self {
        case .Vehicle:
            return ["Give it for Service", "Wash", "Change oil", "Refuel"]
        case .Apparels:
            return ["Give it to laundry", "Wash", "Iron", "Exchange/ Alter", "Return"]
        case .Groceries:
            return ["Order Groceries"]
        case .Books:
            return ["Return to library", "Order online", "Return to friend", "Enquire in library"]
        }
    }
}
