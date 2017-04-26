//
//  BoundingPoly.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// A bounding polygon for the detected image annotation.
public class BoundingPoly {
    var vertices: [Vertex]?
}

/// A vertex represents a 2D point in the image. NOTE: the vertex coordinates are in the same scale as the original image.
public class Vertex {
    
    /// X coordinate.
    var x: Int!
    
    /// Y coordinate.
    var y: Int!
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
