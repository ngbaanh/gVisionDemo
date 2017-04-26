//
//  AnnotateImageRequest.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// Request for performing Google Cloud Vision API tasks over a user-provided image, with user-requested features.
public class AnnotateImageRequest {
    fileprivate static let endpoint = ""
    /// The image to be processed.
    var image: Image!
    
    /// Requested features.
    var features: [Feature]?
    
    /// Additional context that may accompany the image.
    var imageContext: ImageContext?
    
    init(withImage image: Image) {
        self.image = image
    }
    
}


/// Client image to perform Google Cloud Vision API tasks over.
public class Image {
    /// Image content, represented as a stream of bytes. Note: as with all bytes fields, protobuffers use a pure binary representation, whereas JSON representations use base64. A base64-encoded string.
    var content: String?
    
    /// Google Cloud Storage image location. If both `content` and `source` are provided for an image, content takes precedence and is used to perform the image annotation request.
    var source: ImageSource?
    
    init(withImageContent based64String: String) {
        content = based64String
        source  = nil
    }
    
    init(withImageSource imageSource: ImageSource) {
        content = nil
        source  = imageSource
    }
}

public class ImageSource {
    /// NOTE: For new code imageUri below is preferred. Google Cloud Storage image URI, which must be in the following form: gs://bucket_name/object_name (for details, see Google Cloud Storage Request URIs). NOTE: Cloud Storage object versioning is not supported.
    var gcsImageUri: String?
    
    /** Image URI which supports:
     *
     *  1) Google Cloud Storage image URI, which must be in the following form: gs://bucket_name/object_name
     *  (for details, see Google Cloud Storage Request URIs).
     *  NOTE: Cloud Storage object versioning is not supported.
     *
     *  2) Publicly accessible image HTTP/HTTPS URL. This is preferred over the legacy gcsImageUri above.
     *  When both gcsImageUri and imageUri are specified, imageUri takes precedence.
     */
    var imageUri: String?
}

/// Image context and/or feature-specific parameters.
public class ImageContext {
    /// lat/long rectangle that specifies the location of the image.
    var latLongRect: LatLongRect?
    
    /// List of languages to use for TEXT_DETECTION. In most cases, an empty value yields the best results since it enables automatic language detection. For languages based on the Latin alphabet, setting languageHints is not needed. In rare cases, when the language of the text in the image is known, setting a hint will help get better results (although it will be a significant hindrance if the hint is wrong). Text detection returns an error if one or more of the specified languages is not one of the supported languages: https://cloud.google.com/vision/docs/languages
    var languageHints: [String]?
    
    /// Parameters for crop hints annotation request.
    var cropHintsParams: CropHintsParams?
}


/// Rectangle determined by min and max LatLng pairs.
public class LatLongRect {
    
    /// Min lat/long pair.
    var minLatLng: LatLng?
    
    /// Max lat/long pair.
    var maxLatLng: LatLng?
}


/// An object representing a latitude/longitude pair. This is expressed as a pair of doubles representing degrees latitude and degrees longitude. Unless specified otherwise, this must conform to the WGS84 standard ( http://www.unoosa.org/pdf/icg/2012/template/WGS_84.pdf ). Values must be within normalized ranges.
public class LatLng {
    /// The latitude in degrees. It must be in the range [-90.0, +90.0].
    var latitude: Double
    
    /// The longitude in degrees. It must be in the range [-180.0, +180.0]
    var longitude: Double
    
    init(lat: Double, lng: Double) {
        latitude    = lat
        longitude   = lng
    }
}


/// Parameters for crop hints annotation request.
public class CropHintsParams {
    /// Aspect ratios in floats, representing the ratio of the width to the height of the image. For example, if the desired aspect ratio is 4/3, the corresponding float value should be 1.33333. If not specified, the best possible crop is returned. The number of provided aspect ratios is limited to a maximum of 16; any aspect ratios provided after the 16th are ignored.
    var aspectRatios: [Float]?
}



/// Users describe the type of Google Cloud Vision API tasks to perform over images by using *Feature*s. Each Feature indicates a type of image detection task to perform. Features encode the Cloud Vision API vertical to operate on and the number of top-scoring results to return.
class Feature {
    
    /// The feature type.
    var type: FeatureType?
    
    /// Maximum number of results of this type.
    var maxResults: Int?
    
}


/// Type of image feature.
public enum FeatureType: String {
    case TYPE_UNSPECIFIED           = "TYPE_UNSPECIFIED"
    case FACE_DETECTION             = "FACE_DETECTION"
    case LANDMARK_DETECTION         = "LANDMARK_DETECTION"
    case LOGO_DETECTION             = "LOGO_DETECTION"
    case LABEL_DETECTION            = "LABEL_DETECTION"
    case TEXT_DETECTION             = "TEXT_DETECTION"
    case DOCUMENT_TEXT_DETECTION    = "DOCUMENT_TEXT_DETECTION"
    case SAFE_SEARCH_DETECTION      = "SAFE_SEARCH_DETECTION"
    case IMAGE_PROPERTIES           = "IMAGE_PROPERTIES"
    case CROP_HINTS                 = "CROP_HINTS"
    case WEB_DETECTION              = "WEB_DETECTION"
}
