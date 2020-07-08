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
        
//        remindersListViewModel.saveReminder()
        remindersListViewModel.fetchReminders {
            tableView.reloadData()
        }
    }
    
    @objc private func addReminderTapped() {
        showImagePickerSheet()
    }
    
}

extension RemindersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            print("deleted")
            success(true)
        }
        
        let completedAction = UIContextualAction(style: .normal, title: "Completed") { (action, view, success) in
            print("complete")
            success(true)
        }
        completedAction.backgroundColor = .link
        
        return UISwipeActionsConfiguration(actions: [deleteAction, completedAction])
    }
}

extension RemindersListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePickerSheet() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    private func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    // MARK: - Handling Image Picker Selection

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as! UIImage
        let imageClassifier = SmartReminderImageClassifier()
        imageClassifier.processClassification(for: image) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let taskCategory):
                if let taskCategory = taskCategory {
                    let vc =  ViewControllersFactory.addReminderViewController()
                    vc.taskCategory = taskCategory
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.setupErrorTypeAlertView(title: "Oops!", message: "We are not able to recognize this image. Please try again.")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.setupErrorTypeAlertView(title: "Oops!", message: "We are not able to recognize this image. Please try again.")
            }
        }
    }

}
