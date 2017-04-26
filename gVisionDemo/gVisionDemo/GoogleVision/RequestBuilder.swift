//
//  RequestBuilder.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias Completion = (_ requestJSON: JSON, _ response: AnnotateImageResponse?) -> ()

public class RequestBuilder {
    fileprivate var isRequestMade: Bool!
    var requests: [AnnotateImageRequest]!
    
    fileprivate let session = URLSession.shared
    fileprivate var visionURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(GOOGLE_API_KEY)")!
    }
    
    /// The number of units in the current request, see pricing: https://cloud.google.com/vision/docs/pricing
    var unitCount: Int!
    
    init() {
        isRequestMade   = false
        requests        = []
        unitCount       = 0
    }
    
    public func makeRequest(anImageRequest: AnnotateImageRequest) {
        requests.append(anImageRequest)
        isRequestMade   = true
        unitCount       = unitCount + (anImageRequest.features?.count)!
    }
    
    public func addRequest(anImageRequest: AnnotateImageRequest) {
        if !isRequestMade {
            fatalError("You have to make a request first")
        } else {
            requests.append(anImageRequest)
            unitCount = unitCount + (anImageRequest.features?.count)!
        }
    }
    
    public func request(completion: @escaping Completion) {
        if !isRequestMade || requests.isEmpty {
            fatalError("Request Builder requires at least one AnnotateImageRequest")
        } else {
            startRequest(completion: { (requestJSON, response) in
                completion(requestJSON, response)
            })
            
        }
    }
}

extension RequestBuilder {
    fileprivate func buildRequestJSON() -> JSON {
        var jsonRequests = [Any]()
        
        for request in requests {
            var images = [String: Any]()
            if let image = request.image {
                if let content = image.content {
                    images["content"] = content
                }
                if let source = image.source {
                    if let imageUri = source.imageUri {
                        images["source"] = ["imageUri": imageUri]
                    } else if let gcsImageUri = source.gcsImageUri {
                        images["source"] = ["gcsImageUri": gcsImageUri]
                    }
                }
            }
            
            // --------------
            
            var features = [Any]()
            for feature in request.features! {
                features.append([
                    "type"      : feature.type?.rawValue ?? FeatureType.TYPE_UNSPECIFIED.rawValue,
                    "maxResults": feature.maxResults ?? 5,
                ])
            }
            
            // --------------
            var imageContext = [String: Any]()
            if let context = request.imageContext {
                
                // --- param "languageHints"
                if let hints = context.languageHints {
                    imageContext["languageHints"] = hints
                }
                
                // --- param "latLongRect"
                if let latLngRect = context.latLongRect {
                    imageContext["latLongRect"] = [
                        "minLatLng": [
                            "latitude"  : latLngRect.minLatLng?.latitude,
                            "longitude" : latLngRect.minLatLng?.longitude,
                        ],
                        "maxLatLng": [
                            "latitude"  : latLngRect.minLatLng?.latitude,
                            "longitude" : latLngRect.minLatLng?.longitude,
                        ],
                    ]
                }
                
                // --- param "cropHintsParams"
                if let cropHints = context.cropHintsParams {
                    imageContext["cropHintsParams"] = [
                        "aspectRatios": cropHints.aspectRatios,
                    ]
                }
            }
            
            jsonRequests.append([
                "image"         : images,
                "features"      : features,
                "imageContext"  : imageContext,
            ])
        } // .for
        
        let requestJSON = JSON(["requests": jsonRequests])
        return requestJSON
    }
    
    fileprivate func startRequest(completion: @escaping Completion) {
        var request = URLRequest(url: visionURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        let jsonObject = self.buildRequestJSON()
        guard let data = try? jsonObject.rawData() else {
            completion(jsonObject, nil)
            return
        }
        request.httpBody = data
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(jsonObject, nil)
                    return
                }
                DispatchQueue.main.async(execute: {
                    let jsonResponse = JSON(data: data)
                    let response = AnnotateImageResponse(fromResponseJSON: jsonResponse)
                    
                    if let error = response.error {
                        print("Error code \(error.code): \(error.message)")
                        completion(jsonObject, nil)
                    } else {
                        completion(jsonObject, response)
                    }
                    
                }) // .mainAsync
            }
            task.resume()
        } // .globalAsync
    }
    
    
    public func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    private func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
