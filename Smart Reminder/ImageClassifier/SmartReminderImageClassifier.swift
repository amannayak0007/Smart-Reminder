//
//  SmartReminderImageClassifier.swift
//  Smart Reminder
//
//  Created by Aman Jain on 08/07/20.
//  Copyright © 2020 Aman Jain. All rights reserved.
//

import Foundation
import UIKit
import Vision
import CoreML

enum ClassifierError: Error {
    case NotResultFound
    
    var localizedDescription: String {
        switch self {
        case .NotResultFound:
            return "We are not able to recognize this image. Please try again."
        }
    }
}

class SmartReminderImageClassifier {
        
    func processClassification(for image: UIImage, completion: @escaping ((Result<TaskCategory?, Error>) -> Void)) {
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        let classificationRequest: VNCoreMLRequest = {
            do {
                let model = try VNCoreMLModel(for: SmartReminderClassifier().model)
                let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
                    DispatchQueue.main.async {
                        guard let classifications = request.results as? [VNClassificationObservation] else {
                            completion(.failure(error!))
                            return
                        }
                        let firstResult = classifications.first
                        if let confidenceRate = firstResult?.confidence, confidenceRate > 0.90 {
                            let imageCategory = firstResult?.identifier ?? "Unknown"
                            print("Image is classified as:", imageCategory, "with confidence score:", confidenceRate)
                            let taskCategory = TaskCategory(rawValue: imageCategory)
                            completion(.success(taskCategory))
                        } else {
                            completion(.failure(ClassifierError.NotResultFound))
                        }
                    }
                })
                request.imageCropAndScaleOption = .centerCrop
                return request
            } catch {
                fatalError("Failed to load Vision ML model: \(error)")
            }
        }()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
