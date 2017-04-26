//
//  TestViewController.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBuildRequestPressed(_ sender: Any) {
        testFaceDetection()
//        testTextDetection()
    }
    
    // - Private
    
    private func testTextDetection() {
        let requestBuilder = RequestBuilder()
        let anImage = Image(withImageContent: helloworld)
        
        let aFeature = Feature()
        aFeature.maxResults = 3
        aFeature.type = FeatureType.TEXT_DETECTION
        
        let myRequest = AnnotateImageRequest(withImage: anImage)
        myRequest.features = [aFeature]
        let context = ImageContext()
        context.languageHints = ["vi", "en"]
        myRequest.imageContext = context
        
        requestBuilder.makeRequest(anImageRequest: myRequest)
        
        requestBuilder.request { (requestJSON, response) in
            print("Done\n")
            self.textView.text = response.debugDescription
        }
    }
    
    private func testFaceDetection() {
        let requestBuilder = RequestBuilder()
        let anImage = Image(withImageContent: donaldTrump)
        
        let aFeature = Feature()
        aFeature.type = FeatureType.FACE_DETECTION
        
        let myRequest = AnnotateImageRequest(withImage: anImage)
        myRequest.features = [aFeature]
        
        requestBuilder.makeRequest(anImageRequest: myRequest)
        
        requestBuilder.request { (requestJSON, response) in
            print("Done\n")
            self.textView.text = "\(response?.faceAnnotations?[0].detectionConfidence )"
        }
    }
    

}
