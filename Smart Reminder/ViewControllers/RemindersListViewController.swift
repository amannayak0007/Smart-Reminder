//
//  RemindersListViewController.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import UIKit

enum ReminderListSectionType: String {
    case Overdue = "Overdue"
    case Upcoming = "Upcoming"
}

class RemindersListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addReminderButton: UIButton!
    @IBOutlet private weak var emptyReminderView: UIView!
    
    private let sections: [ReminderListSectionType] = [.Overdue, .Upcoming]
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
        addReminderButton.addTarget(self, action: #selector(addReminderTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchReminders), name: UIApplication.willEnterForegroundNotification, object: nil)
        fetchReminders()
    }
    
    @objc private func fetchReminders() {
        remindersListViewModel.fetchReminders {
            if remindersListViewModel.dueRemindersCount() == 0, remindersListViewModel.upcomingRemindersCount() == 0 {
                tableView.backgroundView = emptyReminderView
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        }
    }
    
    @objc private func addReminderTapped() {
        showImagePickerSheet()
    }
    
    private func showImagePickerSheet() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let takePhotoAction = AlertActionModel(title: "Take Photo", type: .default) { [unowned self] in
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosePhotoAction = AlertActionModel(title: "Choose Photo", type: .default) { [unowned self] in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = AlertActionModel(title: "Cancel", type: .cancel, action: nil)
        
        showAlertWithOptions(title: "Create Reminder", message: "Smart reminder uses photo to create reminders. Please provide a photo to proceed.", style: .actionSheet, actionModels: [takePhotoAction, choosePhotoAction, cancelAction])
    }
    
    private func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
}

// MARK: - TableView DataSource and Delegate methods

extension RemindersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if remindersListViewModel.dueRemindersCount() == 0, remindersListViewModel.upcomingRemindersCount() == 0 {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .Overdue:
            return remindersListViewModel.dueRemindersCount()
        case .Upcoming:
            return remindersListViewModel.upcomingRemindersCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderTableViewCell.self)", for: indexPath) as! ReminderTableViewCell
        switch sections[indexPath.section] {
        case .Overdue:
            let reminder = remindersListViewModel.dueReminders?[indexPath.row]
            cell.configureCell(for: reminder)
        case .Upcoming:
            let reminder = remindersListViewModel.upcomingReminders?[indexPath.row]
            cell.configureCell(for: reminder)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .Overdue:
            return remindersListViewModel.dueRemindersCount() == 0 ? nil : sections[section].rawValue
        case .Upcoming:
            return remindersListViewModel.upcomingRemindersCount() == 0 ? nil : sections[section].rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .Overdue:
            return remindersListViewModel.dueRemindersCount() == 0 ? .leastNonzeroMagnitude : 40
        case .Upcoming:
            return remindersListViewModel.upcomingRemindersCount() == 0 ? .leastNonzeroMagnitude : 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .Overdue:
            return remindersListViewModel.dueRemindersCount() == 0 ? .leastNonzeroMagnitude : 18
        case .Upcoming:
            return remindersListViewModel.upcomingRemindersCount() == 0 ? .leastNonzeroMagnitude : 18
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            guard let self = self else {return}
            print("deleted")
            switch self.sections[indexPath.section] {
            case .Overdue:
                if let reminder = self.remindersListViewModel.dueReminders?[indexPath.row] {
                    self.remindersListViewModel.delete(reminder: reminder)
                }
            case .Upcoming:
                if let reminder = self.remindersListViewModel.upcomingReminders?[indexPath.row] {
                    self.remindersListViewModel.delete(reminder: reminder)
                }
            }
            self.fetchReminders()
            success(true)
        }
        
        let completedAction = UIContextualAction(style: .normal, title: "Completed") { [weak self] (action, view, success) in
            guard let self = self else {return}
            print("complete")
            switch self.sections[indexPath.section] {
            case .Overdue:
                if let reminder = self.remindersListViewModel.dueReminders?[indexPath.row] {
                    self.remindersListViewModel.markAsComplete(reminder: reminder)
                }
            case .Upcoming:
                if let reminder = self.remindersListViewModel.upcomingReminders?[indexPath.row] {
                    self.remindersListViewModel.markAsComplete(reminder: reminder)
                }
            }
            self.fetchReminders()
            success(true)
        }
        completedAction.backgroundColor = .link
        
        return UISwipeActionsConfiguration(actions: [deleteAction, completedAction])
    }
}

// MARK: - Handling Image Picker Selection

extension RemindersListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as! UIImage
        classify(image)
    }

}

// MARK: - Image Classifier

extension RemindersListViewController {
    
    private func classify(_ image: UIImage) {
        let imageClassifier = SmartReminderImageClassifier()
        imageClassifier.processClassification(for: image) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let taskCategory):
                self.showAddReminderVC(taskCategory)
            case .failure(let error as ClassifierError):
                print(error.localizedDescription)
                self.setupErrorTypeAlertView(title: "Oops!", message: error.localizedDescription)
            case .failure(let error):
                print(error.localizedDescription)
                self.setupErrorTypeAlertView(title: "Oops!", message: error.localizedDescription)
            }
        }
    }
    
    private func showAddReminderVC(_ taskCategory: TaskCategory?) {
        let vc =  ViewControllersFactory.addReminderViewController()
        vc.taskCategory = taskCategory
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Handling table reload on new reminder creation

extension RemindersListViewController: AddReminderDelegate {
    
    func reminderSaved() {
        fetchReminders()
    }
    
}
