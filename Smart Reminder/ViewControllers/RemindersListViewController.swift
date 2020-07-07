//
//  RemindersListViewController.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

class RemindersListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let remindersListViewModel = RemindersListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Reminders"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        tableView.tableFooterView = UIView()
        
//        remindersListViewModel.saveReminder()
        remindersListViewModel.fetchReminders {
            tableView.reloadData()
        }
    }

}

extension RemindersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindersListViewModel.reminders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderTableViewCell.self)", for: indexPath) as! ReminderTableViewCell
        let reminder = remindersListViewModel.reminders?[indexPath.row]
        cell.configureCell(for: reminder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
