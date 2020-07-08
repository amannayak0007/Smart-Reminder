//
//  AddReminderCellModel.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation

enum AddReminderCellType {
    case TaskTitle
    case TaskDateTime
}

struct AddReminderCellModel {
    let cellHeaderTitle: String
    let cellFooterTitle: String
    let cellType: AddReminderCellType
    
    static let cellTypes = [AddReminderCellModel(cellHeaderTitle: "Task",
                                                 cellFooterTitle: "Tap on the cell to select tasks from list",
                                                 cellType: .TaskTitle),
                            AddReminderCellModel(cellHeaderTitle: "Date & Time",
                                                 cellFooterTitle: "Tap on the cell to select date and time",
                                                 cellType: .TaskDateTime)
    ]
}
