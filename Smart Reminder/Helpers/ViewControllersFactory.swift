//
//  ViewControllersFactory.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation
import UIKit

struct ViewControllersFactory {
    
    // Instantiate ViewControllers
    fileprivate static func vcWithId(_ id: String) -> UIViewController {
        return mainStoryBoad().instantiateViewController(identifier: id)
    }
    
    // Define Storyboard
    fileprivate static func mainStoryBoad() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
}

extension ViewControllersFactory {
    
    static func remindersListNavigationController() -> UINavigationController {
        return vcWithId("RemindersListNavigationController") as! UINavigationController
    }
    
    static func remindersListViewController() -> RemindersListViewController {
        return vcWithId("\(RemindersListViewController.self)") as! RemindersListViewController
    }
    
    static func addReminderViewController() -> AddReminderViewController {
        return vcWithId("\(AddReminderViewController.self)") as! AddReminderViewController
    }
    
}
