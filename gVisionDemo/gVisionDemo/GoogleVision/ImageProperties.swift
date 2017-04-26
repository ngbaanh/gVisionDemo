//
//  ImageProperties.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// Stores image properties, such as dominant colors.
public class ImageProperties {
    
    /// If present, dominant colors completed successfully.
    var dominantColors: DominantColorsAnnotation?
}


/// Set of dominant colors and their corresponding scores.
public class DominantColorsAnnotation {
    
    /// RGB color values with their score and pixel fraction.
    var colors: [ColorInfo]?
}


/// Color information consists of RGB channels, score, and the fraction of the image that the color occupies in the image.
public class ColorInfo {
    /// RGB components of the color.
    var color: Color?
    
    /// Image-specific score for this color. Value in range [0, 1].
    var score: Double?
    
    /// The fraction of pixels the color occupies in the image. Value in range [0, 1].
    var pixelFraction: Double?
}


import UIKit

/// Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to/from color representations in various languages over compactness; for example, the fields of this representation can be trivially provided to the constructor of "java.awt.Color" in Java; it can also be trivially provided to UIColor's "+colorWithRed:green:blue:alpha" method in iOS; and, with just a little work, it can be easily formatted into a CSS "rgba()" string in JavaScript, as well. Here are some examples:
public class Color {
    var red: Double!
    var green: Double!
    var blue: Double!
    
    /** The fraction of this color that should be applied to the pixel. 
    *   That is, the final pixel color is defined by the equation:
    *   pixel color = alpha * (this color) + (1.0 - alpha) * (background color)
    *
    *   This means that a value of 1.0 corresponds to a solid color, whereas a value of 0.0 corresponds to a completely
    *   transparent color. This uses a wrapper message rather than a simple float scalar so that it is possible to
    *   distinguish between a default value and the value being unset. If omitted, this color object is to be rendered 
    *   as a solid color (as if the alpha value had been explicitly given with a value of 1.0).
    */
    var alpha: Double!
    
//    var uiColor: UIColor {
//        get {
//            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
//        }
//    }
}
