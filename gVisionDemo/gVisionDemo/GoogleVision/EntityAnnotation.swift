//
//  EntityAnnotation.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

class EntityAnnotation {
    /// Opaque entity ID
    var mid: String?
    
    /// The language code for the locale in which the entity textual `description` is expressed.
    var locale: String?
    
    /// Entity textual description, expressed in its `locale` language.
    var description: String?
    
    /// Overall score of the result. Range [0, 1].
    var score: Double?
    
    /// The accuracy of the entity detection in an image. For example, for an image in which the "Eiffel Tower" entity is detected, this field represents the confidence that there is a tower in the query image. Range [0, 1].
    var confidence: Double?
    
    /// The relevancy of the ICA (Image Content Annotation) label to the image. For example, the relevancy of "tower" is likely higher to an image containing the detected "Eiffel Tower" than to an image containing a detected distant towering building, even though the confidence that there is a tower in each image may be the same. Range [0, 1].
    var topicality: Double?
    
    /// Image region to which this entity belongs. Currently not produced for `LABEL_DETECTION` features. For `TEXT_DETECTION` (OCR), `boundingPoly`s are produced for the entire text detected in an image region, followed by `boundingPoly`s for each word within the detected text.
    var boundingPoly: BoundingPoly?
    
    /// The location information for the detected entity. Multiple `LocationInfo` elements can be present because one location may indicate the location of the scene in the image, and another location may indicate the location of the place where the image was taken. Location information is usually present for landmarks.
    var locations: [LocationInfo]?
    
    /// Some entities may have optional user-supplied `Property` (name/value) fields, such a score or string that qualifies the entity.
    var properties: [Property]?
}

/// Detected entity location information.
public class LocationInfo {
    var latLng: LatLng?
}

/// A Property consists of a user-supplied name/value pair.
public class Property {
    var name: String?
    var value: String?
    var uint64Value: String?
}
