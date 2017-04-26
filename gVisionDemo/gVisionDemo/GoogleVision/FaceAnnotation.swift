//
//  FaceAnnotation.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// A face annotation object contains the results of face detection.
class FaceAnnotation {
    /// The bounding polygon around the face. The coordinates of the bounding box are in the original image's scale, as returned in `ImageParams`. The bounding box is computed to "frame" the face in accordance with human expectations. It is based on the landmarker results. Note that one or more x and/or y coordinates may not be generated in the BoundingPoly (the polygon will be unbounded) if only a partial face appears in the image to be annotated.
    var boundingPoly: BoundingPoly?
    
    /// The fdBoundingPoly bounding polygon is tighter than the boundingPoly, and encloses only the skin part of the face. Typically, it is used to eliminate the face from any image analysis that detects the "amount of skin" visible in an image. It is not based on the landmarker results, only on the initial face detection, hence the `fd` = `face detetcion`
    var fdBoundingPoly: BoundingPoly?
    
    /// Detected face landmarks.
    var landmarks: [Landmark]?
    
    /// Roll angle, which indicates the amount of clockwise/anti-clockwise rotation of the face relative to the image vertical about the axis perpendicular to the face. Range [-180,180].
    var rollAngle: Double? {
        willSet {
            if let value = newValue, value < -180.0 || value > 180.0 {
                fatalError("Out of Range: [-180,180]")
            }
        }
    }
    
    /// Yaw angle, which indicates the leftward/rightward angle that the face is pointing relative to the vertical plane perpendicular to the image. Range [-180,180].
    var panAngle: Double? {
        willSet {
            if let value = newValue, value < -180.0 || value > 180.0 {
                fatalError("Out of Range: [-180,180]")
            }
        }
    }
    
    /// Pitch angle, which indicates the upwards/downwards angle that the face is pointing relative to the image's horizontal plane. Range [-180,180].
    var tiltAngle: Double? {
        willSet {
            if let value = newValue, value < -180.0 || value > 180.0 {
                fatalError("Out of Range: [-180,180]")
            }
        }
    }
    
    /// Detection confidence. Range [0, 1].
    var detectionConfidence: Double? {
        willSet {
            if let value = newValue, value < 0.0 || value > 1.0 {
                fatalError("Out of Range: [0,1]")
            }
        }
    }
    
    /// Face landmarking confidence. Range [0, 1].
    var landmarkingConfidence: Double? {
        willSet {
            if let value = newValue, value < 0.0 || value > 1.0 {
                fatalError("Out of Range: [0,1]")
            }
        }
    }
    
    var joyLikelihood           : Likelihood?
    var sorrowLikelihood        : Likelihood?
    var angerLikelihood         : Likelihood?
    var surpriseLikelihood      : Likelihood?
    var underExposedLikelihood  : Likelihood?
    var blurredLikelihood       : Likelihood?
    var headwearLikelihood      : Likelihood?
}


enum Likelihood: String {
    /// Unknown likelihood.
    case UNKNOWN        = "UNKNOWN"
    
    /// It is very unlikely that the image belongs to the specified vertical.
    case VERY_UNLIKELY  = "VERY_UNLIKELY"
    
    /// It is unlikely that the image belongs to the specified vertical.
    case UNLIKELY       = "UNLIKELY"
    
    /// It is possible that the image belongs to the specified vertical.
    case POSSIBLE       = "POSSIBLE"
    
    /// It is likely that the image belongs to the specified vertical.
    case LIKELY         = "LIKELY"
    
    /// It is very likely that the image belongs to the specified vertical.
    case VERY_LIKELY    = "VERY_LIKELY"
}
