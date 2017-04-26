//
//  AnnotateImageResponse.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation
import SwiftyJSON

public class AnnotateImageResponse {
    var faceAnnotations             : [FaceAnnotation]?
    var landmarkAnnotations         : [EntityAnnotation]?
    var logoAnnotations             : [EntityAnnotation]?
    var labelAnnotations            : [EntityAnnotation]?
    var textAnnotations             : [EntityAnnotation]?
    var fullTextAnnotation          : [TextAnnotation]?
    var safeSearchAnnotation        : SafeSearchAnnotation?
    var imagePropertiesAnnotation   : ImageProperties?
    var cropHintsAnnotation         : CropHintsAnnotation?
    var webDetection                : WebDetection?
    var error                       : Status?
    
    init(fromResponseJSON json: JSON) {
        print("RESPONSE JSON: \(json)")
        faceAnnotations     = parseFaceAnnotations(from: json)
//        landmarkAnnotations = parseLandmarkAnnotations(from: json)
//        logoAnnotations     = parseLogoAnnotations(from: json)
//        labelAnnotations    = parseLabelAnnotations(from: json)
        textAnnotations     = parseTextAnnotations(from: json)
        fullTextAnnotation  = parseFullTextAnnotation(from: json)
//        safeSearchAnnotation        = parseSafeSearchAnnotation(from: json)
//        imagePropertiesAnnotation   = parseImagePropertiesAnnotation(from: json)
//        cropHintsAnnotation = parseCropHintsAnnotation(from: json)
//        webDetection        = parseWebDetection(from: json)
//        error               = parseError(from: json)
    }
}

protocol Parsers {
    func parseFaceAnnotations(from json: JSON)      -> [FaceAnnotation]
    func parseLandmarkAnnotations(from json: JSON)  -> [EntityAnnotation]
    func parseLogoAnnotations(from json: JSON)      -> [EntityAnnotation]
    func parseLabelAnnotations(from json: JSON)     -> [EntityAnnotation]
    func parseFullTextAnnotation(from json: JSON)   -> [TextAnnotation]
    func parseSafeSearchAnnotation(from json: JSON) -> SafeSearchAnnotation?
    func parseImagePropertiesAnnotation(from json: JSON) -> ImageProperties?
    func parseCropHintsAnnotation(from json: JSON)  -> CropHintsAnnotation?
    func parseWebDetection(from json: JSON)         -> WebDetection?
    func parseError(from json: JSON)                -> Status?
}

extension AnnotateImageResponse: Parsers {
    internal func parseError(from json: JSON) -> Status? {
        fatalError(":-)")
    }

    internal func parseWebDetection(from json: JSON) -> WebDetection? {
        fatalError(":-)")
    }

    internal func parseCropHintsAnnotation(from json: JSON) -> CropHintsAnnotation? {
        fatalError(":-)")
    }

    internal func parseImagePropertiesAnnotation(from json: JSON) -> ImageProperties? {
        fatalError(":-)")
    }

    internal func parseSafeSearchAnnotation(from json: JSON) -> SafeSearchAnnotation? {
        fatalError(":-)")
    }

    internal func parseLabelAnnotations(from json: JSON) -> [EntityAnnotation] {
        let responses = json["responses"].arrayValue
        var entityAnnotations = [EntityAnnotation]()
        for response in responses {
            if let entityAnnotation = self.parseEntityAnnotation(from: response["labelAnnotations"]) {
                entityAnnotations.append(entityAnnotation)
            }
        }
        return entityAnnotations
    }

    internal func parseLogoAnnotations(from json: JSON) -> [EntityAnnotation] {
        let responses = json["responses"].arrayValue
        var entityAnnotations = [EntityAnnotation]()
        for response in responses {
            if let entityAnnotation = self.parseEntityAnnotation(from: response["logoAnnotations"]) {
                entityAnnotations.append(entityAnnotation)
            }
        }
        return entityAnnotations
    }

    internal func parseLandmarkAnnotations(from json: JSON) -> [EntityAnnotation] {
        let responses = json["responses"].arrayValue
        var entityAnnotations = [EntityAnnotation]()
        for response in responses {
            if let entityAnnotation = self.parseEntityAnnotation(from: response["landmarkAnnotations"]) {
                entityAnnotations.append(entityAnnotation)
            }
        }
        return entityAnnotations
    }

    internal func parseFaceAnnotations(from json: JSON) -> [FaceAnnotation] {
        var faceAnnotations = [FaceAnnotation]()
        for response in json["responses"].arrayValue {
            for f in response["faceAnnotations"].arrayValue {
                let faceAnnotation              = FaceAnnotation()
                faceAnnotation.boundingPoly     = parseBoundingPoly(from: f["boundingPoly"])
                faceAnnotation.fdBoundingPoly   = parseBoundingPoly(from: f["fdBoundingPoly"])
                faceAnnotation.panAngle         = f["panAngle"].doubleValue
                faceAnnotation.rollAngle        = f["rollAngle"].doubleValue
                faceAnnotation.tiltAngle        = f["tiltAngle"].doubleValue
                faceAnnotation.detectionConfidence    = f["detectionConfidence"].doubleValue
                faceAnnotation.landmarkingConfidence  = f["landmarkingConfidence"].doubleValue
                var landmarks = [Landmark]()
                for lm in f["landmarks"].arrayValue {
                    let landmark      = Landmark()
                    landmark.type     = FaceLandmarkType(rawValue: lm["type"].stringValue)
                    landmark.position = Position(x: lm["position"]["x"].doubleValue,
                                                 y: lm["position"]["y"].doubleValue,
                                                 z: lm["position"]["z"].doubleValue)
                    landmarks.append(landmark)
                }
                faceAnnotation.landmarks = landmarks
                faceAnnotation.angerLikelihood          = Likelihood(rawValue: f["angerLikelihood"].stringValue)
                faceAnnotation.blurredLikelihood        = Likelihood(rawValue: f["blurredLikelihood"].stringValue)
                faceAnnotation.headwearLikelihood       = Likelihood(rawValue: f["headwearLikelihood"].stringValue)
                faceAnnotation.joyLikelihood            = Likelihood(rawValue: f["joyLikelihood"].stringValue)
                faceAnnotation.sorrowLikelihood         = Likelihood(rawValue: f["sorrowLikelihood"].stringValue)
                faceAnnotation.surpriseLikelihood       = Likelihood(rawValue: f["surpriseLikelihood"].stringValue)
                faceAnnotation.underExposedLikelihood   = Likelihood(rawValue: f["underExposedLikelihood"].stringValue)
                
                faceAnnotations.append(faceAnnotation)
            } // .for f
        } // .for response
        return faceAnnotations
    }
    
    internal func parseTextAnnotations(from json: JSON) -> [EntityAnnotation] {
        let responses = json["responses"].arrayValue
        var entityAnnotations = [EntityAnnotation]()
        for response in responses {
            for textAnnotation in response["textAnnotations"].arrayValue {
                if let entityAnnotation = self.parseEntityAnnotation(from: textAnnotation) {
                    entityAnnotations.append(entityAnnotation)
                }
            }
        }
        return entityAnnotations
    }
    
    internal func parseFullTextAnnotation(from json: JSON) -> [TextAnnotation] {
        let responses = json["responses"].arrayValue
        var textAnnotations = [TextAnnotation]()
        for response in responses {
            if let textAnnotation = self.parseTextAnnotation(from: response["fullTextAnnotation"]) {
                textAnnotations.append(textAnnotation)
            }
        }
        return textAnnotations
    }
}

extension AnnotateImageResponse {
    
    fileprivate func parseTextAnnotation(from json: JSON) -> TextAnnotation? {
        if let json = json.dictionary {
            var pages = [Page]()
            for pg in (json["pages"]?.arrayValue)! {
                var blocks = [Block]()
                for bl in (pg["blocks"].arrayValue) {
                    var paragraphs = [Paragraph]()
                    for p in bl["paragraphs"].arrayValue {
                        var words = [Word]()
                        for w in p["words"].arrayValue {
                            var symbols = [Symbol]()
                            for s in w["symbols"].arrayValue {
                                let symbol = Symbol()
                                symbol.boundingBox = parseBoundingPoly(from: s["boundingBox"])
                                symbol.property    = parseTextProperty(from: s["property"])
                                symbol.text        = s["text"].stringValue
                                symbols.append(symbol)
                            } // .for s
                            let word = Word()
                            word.boundingBox = parseBoundingPoly(from: w["boundingBox"])
                            word.property    = parseTextProperty(from: w["property"])
                            word.symbols     = symbols
                            words.append(word)
                        } // .for w
                        let paragraph         = Paragraph()
                        paragraph.boundingBox = parseBoundingPoly(from: p["boundingBox"])
                        paragraph.property    = parseTextProperty(from: p["property"])
                        paragraph.words       = words
                        paragraphs.append(paragraph)
                    } // .for p
                    let block           = Block()
                    block.paragraphs    = paragraphs
                    block.blockType     = bl["blockType"].string.map { BlockType(rawValue: $0) }!
                    block.boundingBox   = parseBoundingPoly(from: bl["boundingBox"])
                    block.property      = parseTextProperty(from: bl["property"])
                    blocks.append(block)
                } // .for bl
                let page      = Page()
                page.blocks   = blocks
                page.height   = pg["height"].intValue
                page.width    = pg["width"].intValue
                page.property = parseTextProperty(from: pg["property"])
                pages.append(page)
            } // .for pg
            let textAnnotation   = TextAnnotation()
            textAnnotation.pages = pages
            textAnnotation.text  = json["text"]?.stringValue
            return textAnnotation
        } else {
            return nil
        }
    }
    
    fileprivate func parseEntityAnnotation(from json: JSON) -> EntityAnnotation? {
        if let json = json.dictionary {
            let entityAnnotation         = EntityAnnotation()
            entityAnnotation.mid         = json["mid"]?.stringValue
            entityAnnotation.locale      = json["locale"]?.stringValue
            entityAnnotation.confidence  = json["confidence"]?.doubleValue
            entityAnnotation.description = json["description"]?.stringValue
            entityAnnotation.score       = json["score"]?.doubleValue
            entityAnnotation.topicality  = json["topicality"]?.doubleValue
            entityAnnotation.boundingPoly = parseBoundingPoly(from: json["boundingPoly"]!)
            
            if let jsonLocations = json["locations"] {
                var locations = [LocationInfo]()
                for location in jsonLocations.arrayValue {
                    let locationInfo    = LocationInfo()
                    locationInfo.latLng = LatLng(lat: location["latLng"]["latitude"].doubleValue,
                                                 lng: location["latLng"]["longitude"].doubleValue)
                    locations.append(locationInfo)
                } // .for location
                entityAnnotation.locations = locations
            }
            
            if let jsonProperties = json["properties"] {
                var properties = [Property]()
                for p in jsonProperties.arrayValue {
                    let property            = Property()
                    property.name           = p["name"].stringValue
                    property.value          = p["value"].stringValue
                    property.uint64Value    = p["uint64Value"].stringValue
                    properties.append(property)
                } // .for p
                entityAnnotation.properties = properties
            }
            
            return entityAnnotation
        } else {
            return nil
        }
    }
    
    fileprivate func parseTextProperty(from json: JSON) -> TextProperty? {
        if let json = json.dictionary {
            let textProperty            = TextProperty()
            let detectedBreak           = DetectedBreak()
            detectedBreak.type          = json["detectedBreak"]?["type"].string.map { BreakType(rawValue: $0) }!
            detectedBreak.isPrefix      = json["detectedBreak"]?["isPrefix"].boolValue
            textProperty.detectedBreak  = detectedBreak
            
            var detectedLanguages       = [DetectedLanguage]()
            for dl in (json["detectedLanguages"]?.array)! {
                let detectedLanguage    = DetectedLanguage()
                detectedLanguage.confidence     = dl["confidence"].doubleValue
                detectedLanguage.languageCode   = dl["languageCode"].stringValue
                detectedLanguages.append(detectedLanguage)
            } // .for dl
            textProperty.detectedLanguages = detectedLanguages
            return textProperty
        } else {
            return nil
        }
    }
    
    fileprivate func parseBoundingPoly(from json: JSON) -> BoundingPoly? {
        if let json = json.dictionary {
            let boundingPoly = BoundingPoly()
            var vertices = [Vertex]()
            for v in (json["vertices"]?.arrayValue)! {
                vertices.append(Vertex(x: v["x"].intValue, y: v["y"].intValue))
            } // .for v
            boundingPoly.vertices = vertices
            return boundingPoly
        } else {
            return nil
        }
    }
}
