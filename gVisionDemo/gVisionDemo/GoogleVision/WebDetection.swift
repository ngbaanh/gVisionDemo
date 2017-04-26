//
//  WebDetection.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation


/// Relevant information for the image from the Internet.
public class WebDetection {
    /// Deduced entities from similar images on the Internet.
    var webEntities: [WebEntity]?
    
    /// Fully matching images from the Internet. They're definite neardups and most often a copy of the query image with merely a size change.
    var fullMatchingImages: [WebImage]?
    
    /// Partial matching images from the Internet. Those images are similar enough to share some key-point features. For example an original image will likely have partial matching for its crops.
    var partialMatchingImages: [WebImage]?
    
    /// Web pages containing the matching images from the Internet.
    var pagesWithMatchingImages: [WebPage]?
}

/// Entity deduced from similar images on the Internet.
public class WebEntity {
    /// Opaque entity ID.
    var entityId: String?
    
    /// Overall relevancy score for the entity. Not normalized and not comparable across different image queries.
    var score: Double?
    
    /// Canonical description of the entity, in English.
    var description: String?
}

/// Metadata for online images.
public class WebImage {
    /// The result image URL.
    var url: String?
    
    /// Overall relevancy score for the image. Not normalized and not comparable across different image queries.
    var score: Double?
}

/// Metadata for web pages.
public class WebPage {
    /// The result web page URL.
    var url: String?
    
    /// Overall relevancy score for the web page. Not normalized and not comparable across different image queries.
    var score: Double?
}
