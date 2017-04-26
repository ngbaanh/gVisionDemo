//
//  SafeSearchAnnotation.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// Set of features pertaining to the image, computed by computer vision methods over safe-search verticals (for example, adult, spoof, medical, violence).
class SafeSearchAnnotation {
    /// Represents the adult content likelihood for the image.
    var adult: Likelihood?
    
    /// Spoof likelihood. The likelihood that an modification was made to the image's canonical version to make it appear funny or offensive.
    var spoof: Likelihood?
    
    /// Likelihood that this is a medical image.
    var medical: Likelihood?
    
    /// Violence likelihood.
    var violence: Likelihood?
}
