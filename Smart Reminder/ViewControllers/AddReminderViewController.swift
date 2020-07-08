//
//  AddReminderViewController.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveBtn: UIButton!
    
    var taskCategory: TaskCategory?

    private var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
//        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = taskCategory?.rawValue
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
    }
    
    @objc func saveBtnPressed() {
        print("Save reminder")
    }
    
}

extension AddReminderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddReminderCellModel.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddReminderTableViewCell.self)", for: indexPath) as! AddReminderTableViewCell
        let cellType = AddReminderCellModel.cellTypes[indexPath.section].cellType
        cell.configureCell(for: cellType, taskList: taskCategory?.taskList, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AddReminderCellModel.cellTypes[section].cellHeaderTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return AddReminderCellModel.cellTypes[section].cellFooterTitle
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension AddReminderViewController: AdddReminderCellDelegate {
    
    func selectedTask(_ task: String?) {
        print(task)
    }
    
    func selectedDate(_ date: Date?) {
        print(date)
    }
    
}
