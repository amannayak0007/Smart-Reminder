//
//  AddReminderTableViewCell.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

protocol AdddReminderCellDelegate: class {
    func selectedTask(_ task: String?)
    func selectedDate(_ date: Date?)
}

class AddReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var taskPicker: UIPickerView?
    
    weak var delegate: AdddReminderCellDelegate?
    private var tasks: [String]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(for cellType: AddReminderCellType, taskList: [String]?, delegate: AdddReminderCellDelegate) {
        DispatchQueue.main.async {
            self.delegate = delegate
            switch cellType {
            case .TaskTitle:
                self.setupTaskPicker(for: taskList)
            case .TaskDateTime:
                self.setupDatePicker()
            }
        }
    }
    
    private func setupTaskPicker(for taskList: [String]?) {
        tasks = taskList
        let selectedTask = tasks?.first
        textField.text = selectedTask
        delegate?.selectedTask(selectedTask)
        textField.placeholder = "Select Task"
        taskPicker = UIPickerView()
        taskPicker?.delegate = self
        taskPicker?.dataSource = self
        textField.inputView = taskPicker
        textField.inputAccessoryView = UIToolbar().ToolbarPicker(target: self, action: #selector(dismiss))
    }
    
    private func setupDatePicker() {
        let selectedDate = Date()
        textField.text = selectedDate.formattedDate
        delegate?.selectedDate(selectedDate)
        textField.placeholder = "Select Date & Time"
        datePicker = UIDatePicker()
        datePicker?.minimumDate = Date()
        datePicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        textField.inputView = datePicker
        textField.inputAccessoryView = UIToolbar().ToolbarPicker(target: self, action: #selector(dismiss))
    }
    
    @objc func dateChanged() {
        let selectedDate = datePicker?.date
        textField.text = selectedDate?.formattedDate
        delegate?.selectedDate(selectedDate)
    }
    
    @objc func dismiss() {
        textField.endEditing(true)
    }

}

extension AddReminderTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tasks?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTask = tasks?[row]
        textField.text = selectedTask
        delegate?.selectedTask(selectedTask)
    }
    
}
