//
//  ReminderTableViewCell.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func configureCell(for reminder: Reminder?) {
        titleLabel.text = reminder?.title
        descriptionLabel.text = reminder?.dateTime?.formattedDate
    }

}
