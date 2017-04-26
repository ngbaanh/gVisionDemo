//
//  TextAnnotation.swift
//  gVisionTextDetectionDemo
//
//  Created by Bá Anh Nguyễn on 4/24/17.
//  Copyright © 2017 Bá Anh Nguyễn. All rights reserved.
//

import Foundation

/// TextAnnotation contains a structured representation of OCR extracted text. The hierarchy of an OCR extracted text structure is like this: `TextAnnotation -> Page -> Block -> Paragraph -> Word -> Symbol` Each structural component, starting from Page, may further have their own properties. Properties describe detected languages, breaks etc.. Please refer to the https://cloud.google.com/vision/docs/reference/rest/v1/images/annotate#TextProperty message definition below for more detail.
public class TextAnnotation {
    /// List of pages detected by OCR.
    var pages: [Page]?
    
    /// UTF-8 text detected on the pages.
    var text: String?
}


/// Detected page from OCR.
public class Page {
    /// Additional information detected on the page.
    var property: TextProperty?
    
    /// Page width in pixels.
    var width: Int!
    
    /// Page height in pixels.
    var height: Int!
    
    /// List of blocks of text, images etc on this page.
    var blocks: [Block]?
}

/// Additional information detected on the structural component.
public class TextProperty {
    /// A list of detected languages together with confidence.
    var detectedLanguages: [DetectedLanguage]?
    
    /// Detected start or end of a text segment.
    var detectedBreak: DetectedBreak?
}

/// Detected language for a structural component.
public class DetectedLanguage {
    
    /// The BCP-47 language code, such as "en-US" or "sr-Latn". For more information, see http://www.unicode.org/reports/tr35/#Unicode_locale_identifier
    var languageCode: String!
    
    /// Confidence of detected language. Range [0, 1].
    var confidence: Double?
}


/// Detected start or end of a structural component.
public class DetectedBreak {
    var type: BreakType?
    
    /// True if break prepends the element.
    var isPrefix: Bool?
}

/// Enum to denote the type of break found. New line, space etc.
public enum BreakType: String {
    /// Unknown break label type.
    case UNKNOWN        = "UNKNOWN"
    
    /// Regular space.
    case SPACE          = "SPACE"
    
    /// Sure space (very wide).
    case SURE_SPACE     = "SURE_SPACE"
    
    /// Line-wrapping break.
    case EOL_SURE_SPACE = "EOL_SURE_SPACE"
    
    /// End-line hyphen that is not present in text; does
    case HYPHEN         = "HYPHEN"
    
    /// not co-occur with SPACE, LEADER_SPACE, or LINE_BREAK. Line break that ends a paragraph.
    case LINE_BREAK     = "LINE_BREAK"
}

/// Logical element on the page
public class Block {
    /// Additional information detected for the block.
    var property: TextProperty?
    
    /// The bounding box for the block. The vertices are in the order of top-left, top-right, bottom-right, bottom-left. When a rotation of the bounding box is detected the rotation is represented as around the top-left corner as defined when the text is read in the 'natural' orientation. For example: * when the text is horizontal it might look like: 0----1 | | 3----2 * when it's rotated 180 degrees around the top-left corner it becomes: 2----3 | | 1----0 and the vertice order will still be (0, 1, 2, 3).
    var boundingBox: BoundingPoly?
    
    /// List of paragraphs in this block (if this blocks is of type text).
    var paragraphs: [Paragraph]?
    
    /// Detected block type (text, image etc) for this block.
    var blockType: BlockType?
}


/// Structural unit of text representing a number of words in certain order.
public class Paragraph {
    /// Additional information detected for the paragraph.
    var property: TextProperty?
    
    /// The bounding box for the paragraph. The vertices are in the order of top-left, top-right, bottom-right, bottom-left. When a rotation of the bounding box is detected the rotation is represented as around the top-left corner as defined when the text is read in the 'natural' orientation. For example: * when the text is horizontal it might look like: 0----1 | | 3----2 * when it's rotated 180 degrees around the top-left corner it becomes: 2----3 | | 1----0 and the vertice order will still be (0, 1, 2, 3).
    var boundingBox: BoundingPoly?
    
    /// List of words in this paragraph.
    var words: [Word]?
}

/// A word representation.
public class Word {
    /// Additional information detected for the word.
    var property: TextProperty?
    
    /// The bounding box for the word. The vertices are in the order of top-left, top-right, bottom-right, bottom-left. When a rotation of the bounding box is detected the rotation is represented as around the top-left corner as defined when the text is read in the 'natural' orientation. For example: * when the text is horizontal it might look like: 0----1 | | 3----2 * when it's rotated 180 degrees around the top-left corner it becomes: 2----3 | | 1----0 and the vertice order will still be (0, 1, 2, 3).
    var boundingBox: BoundingPoly?
    
    /// List of symbols in the word. The order of the symbols follows the natural reading order.
    var symbols: [Symbol]?
}


/// A single symbol representation.
public class Symbol {
    /// Additional information detected for the symbol.
    var property: TextProperty?
    
    /// The bounding box for the symbol. The vertices are in the order of top-left, top-right, bottom-right, bottom-left. When a rotation of the bounding box is detected the rotation is represented as around the top-left corner as defined when the text is read in the 'natural' orientation. For example: * when the text is horizontal it might look like: 0----1 | | 3----2 * when it's rotated 180 degrees around the top-left corner it becomes: 2----3 | | 1----0 and the vertice order will still be (0, 1, 2, 3).
    var boundingBox: BoundingPoly?
    
    /// The actual UTF-8 representation of the symbol.
    var text: String!
}

/// Type of a block (text, image etc) as identified by OCR.
public enum BlockType: String {
    /// Unknown block type.
    case UNKNOWN = "UNKNOWN"
    
    /// Regular text block.
    case TEXT = "TEXT"
    
    /// Table block.
    case TABLE = "TABLE"
    
    /// Image block.
    case PICTURE = "PICTURE"
    
    /// Horizontal/vertical line box.
    case RULER = "RULER"
    
    /// Barcode block.
    case BARCODE = "BARCODE"
    
}
