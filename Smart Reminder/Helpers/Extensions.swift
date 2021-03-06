//
//  Extensions.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation
import UIKit

typealias AlertActionModel = (title: String, type: UIAlertAction.Style, action: (() -> Void)?)

extension UIViewController {
    
    func setupErrorTypeAlertView(title: String?,message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertWithOptions(title: String?,message: String?,style: UIAlertController.Style, actionModels: [AlertActionModel], animated: Bool = true, completion: (() -> Void)? = nil  ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for actionMdodel in actionModels {
            alert.addAction(UIAlertAction(title: actionMdodel.title, style: actionMdodel.type, handler: { _ in
                actionMdodel.action?()
            }))
        }
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: animated , completion: completion)
    }
    
}

extension Date {
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
    
    var isOverdue: Bool {
        return Date().compare(self) == .orderedDescending
    }
    
}

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.link]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.link]
        
        navigationBar.tintColor = UIColor.link
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
    }
}

extension CGImagePropertyOrientation {
    /**
     Converts a `UIImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     */
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}

extension UIToolbar {

    func ToolbarPicker(target: Any?, action: Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.tintColor = UIColor.label
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: action)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        return toolBar
    }
    
}
