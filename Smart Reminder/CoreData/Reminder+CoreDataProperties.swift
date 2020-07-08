//
//  Reminder+CoreDataProperties.swift
//  Smart Reminder
//
//  Created by Aman Jain on 09/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

}
