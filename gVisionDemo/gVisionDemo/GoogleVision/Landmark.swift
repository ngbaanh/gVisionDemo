//
//  Landmark.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// A face-specific landmark (for example, a face feature). Landmark positions may fall outside the bounds of the image if the face is near one or more edges of the image. Therefore it is NOT guaranteed that 0 <= x < width or 0 <= y < height.
public class Landmark {
    var type        : FaceLandmarkType?
    var position    : Position?
}

/// Face landmark (feature) type. Left and right are defined from the vantage of the viewer of the image without considering mirror projections typical of photos. So, LEFT_EYE, typically, is the person's right eye.
enum FaceLandmarkType: String {
    case UNKNOWN_LANDMARK               = "UNKNOWN_LANDMARK"
    case LEFT_EYE                       = "LEFT_EYE"
    case LEFT_OF_LEFT_EYEBROW           = "LEFT_OF_LEFT_EYEBROW"
    case RIGHT_OF_LEFT_EYEBROW          = "RIGHT_OF_LEFT_EYEBROW"
    case RIGHT_EYE                      = "RIGHT_EYE"
    case LEFT_OF_RIGHT_EYEBROW          = "LEFT_OF_RIGHT_EYEBROW"
    case RIGHT_OF_RIGHT_EYEBROW         = "RIGHT_OF_RIGHT_EYEBROW"
    case MIDPOINT_BETWEEN_EYES          = "MIDPOINT_BETWEEN_EYES"
    case NOSE_TIP                       = "NOSE_TIP"
    case UPPER_LIP                      = "UPPER_LIP"
    case LOWER_LIP                      = "LOWER_LIP"
    case MOUTH_LEFT                     = "MOUTH_LEFT"
    case MOUTH_RIGHT                    = "MOUTH_RIGHT"
    case MOUTH_CENTER                   = "MOUTH_CENTER"
    case NOSE_BOTTOM_RIGHT              = "NOSE_BOTTOM_RIGHT"
    case NOSE_BOTTOM_LEFT               = "NOSE_BOTTOM_LEFT"
    case NOSE_BOTTOM_CENTER             = "NOSE_BOTTOM_CENTER"
    case LEFT_EYE_TOP_BOUNDARY          = "LEFT_EYE_TOP_BOUNDARY"
    case LEFT_EYE_RIGHT_CORNER          = "LEFT_EYE_RIGHT_CORNER"
    case LEFT_EYE_BOTTOM_BOUNDARY       = "LEFT_EYE_BOTTOM_BOUNDARY"
    case LEFT_EYE_LEFT_CORNER           = "LEFT_EYE_LEFT_CORNER"
    case RIGHT_EYE_TOP_BOUNDARY         = "RIGHT_EYE_TOP_BOUNDARY"
    case RIGHT_EYE_RIGHT_CORNER         = "RIGHT_EYE_RIGHT_CORNER"
    case RIGHT_EYE_BOTTOM_BOUNDARY      = "RIGHT_EYE_BOTTOM_BOUNDARY"
    case RIGHT_EYE_LEFT_CORNER          = "RIGHT_EYE_LEFT_CORNER"
    case LEFT_EYEBROW_UPPER_MIDPOINT    = "LEFT_EYEBROW_UPPER_MIDPOINT"
    case RIGHT_EYEBROW_UPPER_MIDPOINT   = "RIGHT_EYEBROW_UPPER_MIDPOINT"
    case LEFT_EAR_TRAGION               = "LEFT_EAR_TRAGION"
    case RIGHT_EAR_TRAGION              = "RIGHT_EAR_TRAGION"
    case LEFT_EYE_PUPIL                 = "LEFT_EYE_PUPIL"
    case RIGHT_EYE_PUPIL                = "RIGHT_EYE_PUPIL"
    case FOREHEAD_GLABELLA              = "FOREHEAD_GLABELLA"
    case CHIN_GNATHION                  = "CHIN_GNATHION"
    case CHIN_LEFT_GONION               = "CHIN_LEFT_GONION"
    case CHIN_RIGHT_GONION              = "CHIN_RIGHT_GONION"
}


/// A 3D position in the image, used primarily for Face detection landmarks. A valid Position must have both x and y coordinates. The position coordinates are in the same scale as the original image.
public class Position {
    var x: Double
    var y: Double
    var z: Double // depth
    
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}
