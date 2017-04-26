//
//  TextViewController.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/13/17.
//
// Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import UIKit
import AVFoundation
import SwiftyJSON

class TextViewController: UIViewController {

    @IBOutlet weak var buttonLayers : UIButton!
    @IBOutlet weak var buttonShowText: UIButton!
    @IBOutlet weak var buttonLibrary: UIButton!
    @IBOutlet weak var buttonDone   : UIButton!
    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var buttonCamera : UIButton!
    @IBOutlet weak var overlay      : UIView!
    
    
    var aResponse: AnnotateImageResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLayers.isEnabled  = false
        buttonDone.isEnabled    = false
        overlay.isHidden        = true
        buttonShowText.isEnabled = false
    }
    
    @IBAction func buttonLayersPressed(_ sender: Any) {
        overlay.isHidden = !overlay.isHidden
    }
    
    @IBAction func buttonLibraryPressed(_ sender: Any) {
        let imagePicker             = UIImagePickerController()
        imagePicker.delegate        = self
        imagePicker.allowsEditing   = false
        imagePicker.sourceType      = .photoLibrary
        present(imagePicker, animated: true, completion: {
            self.activityIndicatorView.isHidden = true
        })
    }
    
    @IBAction func buttonCameraPressed(_ sender: Any) {
        let imagePicker             = UIImagePickerController()
        imagePicker.delegate        = self
        imagePicker.allowsEditing   = false
        imagePicker.sourceType      = .camera
        present(imagePicker, animated: true, completion: {
            self.activityIndicatorView.isHidden = true
        })
    }
    
    
    @IBAction func buttonDonePressed(_ sender: Any) {
        if let image = self.imageView.image {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            
            let requestBuilder = RequestBuilder()
            
            let gImage = Image(withImageContent: requestBuilder.base64EncodeImage(image))
            let detectingTextFeature = Feature()
            detectingTextFeature.type = FeatureType.TEXT_DETECTION
            
            let annotateImageRequest = AnnotateImageRequest(withImage: gImage)
            annotateImageRequest.features = [detectingTextFeature]
            
            requestBuilder.makeRequest(anImageRequest: annotateImageRequest)
            
            requestBuilder.request { requestJSON, response in
                if response?.error != nil {
                    let alertController = UIAlertController(title: "Error", message: "The response is invalid", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { action in }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                    return
                } else {
                    self.aResponse = response!
                    self.produceOverlay(from: response!)
                    self.buttonLayers.isEnabled = true
                    self.buttonShowText.isEnabled = true
                }
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction func buttonShowTextPressed(_ sender: Any) {
        self.overlay.isHidden = true
        let alertController = UIAlertController(title: "Extracted Text",
                                                message: self.aResponse?.fullTextAnnotation?[0].text,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel) { action in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}


extension TextViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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


protocol TextDetectionHelpers {
    /// response: AnnotateImageResponse
    func produceOverlay(from response: AnnotateImageResponse)
    
    /// values: relative values from 0.0 to 1.0
    func drawLabelRelatively(title: String, xValue: Double, yValue: Double, widthValue: Double, heightValue: Double)
    
    /// values: absolute values > 0
    func drawLabel(title: String, x: Double, y: Double, width: Double, height: Double)
}

extension TextViewController: TextDetectionHelpers {
    
    func produceOverlay(from response: AnnotateImageResponse) {
        for v in self.overlay.subviews { v.removeFromSuperview() }
        
        let imageWidth  = response.fullTextAnnotation?[0].pages?[0].width
        let imageHeight = response.fullTextAnnotation?[0].pages?[0].height
        let description = response.textAnnotations?[0].description
        print(description!)
        
        let annotationCount = response.textAnnotations?.count ?? 0
        for i in 1..<annotationCount { // avoid first element.
            let description = response.textAnnotations?[i].description
            let vertices    = response.textAnnotations?[i].boundingPoly?.vertices
            let vertex0X    = Double((vertices?[0].x)!)
            let vertex0Y    = Double((vertices?[0].y)!)
            let vertex1X    = Double((vertices?[1].x)!)
            let vertex1Y    = Double((vertices?[1].y)!)
            let vertex2Y    = Double((vertices?[2].y)!)
            drawLabelRelatively(
                title       : description!,
                xValue      : vertex0X / Double(imageWidth!),
                yValue      : vertex0Y / Double(imageHeight!),
                widthValue  : (vertex1X - vertex0X) / Double(imageWidth!),
                heightValue : (vertex2Y - vertex1Y) / Double(imageHeight!)
            ) // .drawLabelRelatively
        } // .for
    }
    
    func drawLabelRelatively(title: String, xValue: Double, yValue: Double, widthValue: Double, heightValue: Double) {
        let relativeFrame = AVMakeRect(aspectRatio: (imageView.image?.size)!, insideRect: imageView.frame)
        overlay.frame     = relativeFrame
        
        let x       = xValue * Double(relativeFrame.width)
        let y       = yValue * Double(relativeFrame.height)
        let width   = widthValue * Double(relativeFrame.width)
        let height  = heightValue * Double(relativeFrame.height)
        
        // Draw overlay label absolutely
        drawLabel(title: title, x: x, y: y, width: width, height: height)
    }

    func drawLabel(title: String, x: Double, y: Double, width: Double, height: Double) {
        let labelFrame = CGRect(x: x, y: y, width: width, height: height)
        let label      = UILabel(frame: labelFrame)
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.green.cgColor
        label.text = title
        label.font = UIFont(name: "Heveltica", size: CGFloat(height))
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment        = .alignCenters
        label.textAlignment             = .center
        label.textColor                 = .white
        overlay.addSubview(label)
    }
    
}
