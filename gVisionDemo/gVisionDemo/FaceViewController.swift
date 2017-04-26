//
//  FaceViewController.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/26/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonLibraryPressed(_ sender: Any) {
        let imagePicker             = UIImagePickerController()
        imagePicker.delegate        = self
        imagePicker.allowsEditing   = false
        imagePicker.sourceType      = .photoLibrary
        present(imagePicker, animated: true, completion: {
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    @IBAction func buttonCameraPressed(_ sender: Any) {
        let imagePicker             = UIImagePickerController()
        imagePicker.delegate        = self
        imagePicker.allowsEditing   = false
        imagePicker.sourceType      = .camera
        present(imagePicker, animated: true, completion: {
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    @IBAction func buttonDonePressed(_ sender: Any) {
        if let image = self.imageView.image {
            activityIndicatorView.startAnimating()
            
            let requestBuilder = RequestBuilder()
            
            let gImage = Image(withImageContent: requestBuilder.base64EncodeImage(image))
            let detectingFaceFeature = Feature()
            detectingFaceFeature.type = FeatureType.FACE_DETECTION
            
            let annotateImageRequest = AnnotateImageRequest(withImage: gImage)
            annotateImageRequest.features = [detectingFaceFeature]
            
            requestBuilder.makeRequest(anImageRequest: annotateImageRequest)
            
            requestBuilder.request { requestJSON, response in
                print("requestJSON: \(requestJSON)")
                if response?.error != nil {
                    let alertController = UIAlertController(title: "Error", message: "The response is invalid", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { action in }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                    return
                } else {
                    self.textView.text = self.getInfo(from: response!)
                }
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    // MARK: -
    
    private func getInfo(from response: AnnotateImageResponse) -> String {
        var infoString = ""
        var idx = 1
        for r in response.faceAnnotations! {
            infoString.append("=============\nFace number #\(idx): \n")
            idx = idx + 1
            
            infoString.append("+ Roll angle: \(r.rollAngle ?? 0) \n")
            infoString.append("+ Yaw angle: \(r.panAngle ?? 0) \n")
            infoString.append("+ Pinch angle: \(r.tiltAngle ?? 0) \n")
            infoString.append("+ Detection confidence: \(100 * (r.detectionConfidence ?? 0))% \n")
            infoString.append("+ Face landmarking confidence: \(100 * (r.landmarkingConfidence ?? 0))% \n")
            infoString.append("+ joyful: \(r.joyLikelihood ?? Likelihood.UNKNOWN) \n")
            infoString.append("+ sorrowful: \(r.sorrowLikelihood ?? Likelihood.UNKNOWN) \n")
            infoString.append("+ angry: \(r.angerLikelihood ?? Likelihood.UNKNOWN) \n")
            infoString.append("+ surpising: \(r.surpriseLikelihood ?? Likelihood.UNKNOWN) \n")
            infoString.append("+ under exposed: \(r.underExposedLikelihood ?? Likelihood.UNKNOWN) \n")
            infoString.append("+ blurred: \(r.blurredLikelihood ?? Likelihood.UNKNOWN) \n")
            infoString.append("+ head wear: \(r.headwearLikelihood ?? Likelihood.UNKNOWN) \n")
        }
        return infoString
    }

}


extension FaceViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode   = .scaleAspectFit
            imageView.image         = pickedImage
            buttonDone.isEnabled    = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
