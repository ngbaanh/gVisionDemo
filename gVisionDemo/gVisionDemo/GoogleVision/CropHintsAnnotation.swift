//
//  CropHintsAnnotation.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// Set of crop hints that are used to generate new crops when serving images.
public class CropHintsAnnotation {
    var cropHints: [CropHint]?
}


/// Single crop hint that is used to generate a new crop when serving an image.
public class CropHint {
    /// The bounding polygon for the crop region. The coordinates of the bounding box are in the original image's scale, as returned in `ImageParams`.
    var boundingPoly: BoundingPoly?
    
    /// Confidence of this being a salient region. Range [0, 1].
    var confidence: Double?
    
    /// Fraction of importance of this salient region with respect to the original image.
    var importanceFraction: Double?
}
