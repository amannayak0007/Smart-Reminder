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
    @IBOutlet private weak var addReminderButton: UIButton!
    @IBOutlet private weak var emptyReminderView: UIView!
    
    private let sectionTitle = ["Overdue", "Upcoming"]
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
            if remindersListViewModel.dueReminders?.count == 0, remindersListViewModel.upcomingReminders?.count == 0 {
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
        if remindersListViewModel.dueReminders?.count == 0, remindersListViewModel.upcomingReminders?.count == 0 {
            return 0
        }
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return remindersListViewModel.dueReminders?.count ?? 0
        } else {
            return remindersListViewModel.upcomingReminders?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReminderTableViewCell.self)", for: indexPath) as! ReminderTableViewCell
        if indexPath.section == 0 {
            let reminder = remindersListViewModel.dueReminders?[indexPath.row]
            cell.configureCell(for: reminder)
        } else {
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
        if section == 0 {
            return remindersListViewModel.dueReminders?.count == 0 ? nil : sectionTitle[section]
        } else {
            return remindersListViewModel.upcomingReminders?.count == 0 ? nil : sectionTitle[section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return remindersListViewModel.dueReminders?.count == 0 ? .leastNonzeroMagnitude : 40
        } else {
            return remindersListViewModel.upcomingReminders?.count == 0 ? .leastNonzeroMagnitude : 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return remindersListViewModel.dueReminders?.count == 0 ? .leastNonzeroMagnitude : 18
        } else {
            return remindersListViewModel.upcomingReminders?.count == 0 ? .leastNonzeroMagnitude : 18
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            guard let self = self else {return}
            print("deleted")
            if indexPath.section == 0 {
                if let reminder = self.remindersListViewModel.dueReminders?[indexPath.row] {
                    self.remindersListViewModel.delete(reminder: reminder)
                }
            } else {
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
            if indexPath.section == 0 {
                if let reminder = self.remindersListViewModel.dueReminders?[indexPath.row] {
                    self.remindersListViewModel.markAsComplete(reminder: reminder)
                }
            } else {
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
                if let taskCategory = taskCategory {
                    self.showAddReminderVC(taskCategory)
                } else {
                    self.setupErrorTypeAlertView(title: "Oops!", message: "We are not able to recognize this image. Please try again.")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.setupErrorTypeAlertView(title: "Oops!", message: "We are not able to recognize this image. Please try again.")
            }
        }
    }
    
    private func showAddReminderVC(_ taskCategory: TaskCategory) {
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
