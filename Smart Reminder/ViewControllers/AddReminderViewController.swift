//
//  AddReminderViewController.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController {
    
    var tasks: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("taskssss:", tasks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
}
