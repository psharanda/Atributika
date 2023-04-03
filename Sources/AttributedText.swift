//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

import Foundation

public enum DetectionType {
    case tag(Tag)
    case hashtag(String)
    case mention(String)
    case regex(String)
    case phoneNumber(String)
    case link(URL)
    case textCheckingType(String, NSTextCheckingResult.CheckingType)
    case range
}

public struct Detection {
    public let type: DetectionType
    public let style: [NSAttributedString.Key: Any]
    public let range: Range<String.Index>
    let level: Int
}

public protocol AttributedTextProtocol {
    var string: String {get}
    var detections: [Detection] {get}
    var baseStyle:  [NSAttributedString.Key: Any] {get}
}

extension AttributedTextProtocol {
    
    fileprivate func makeAttributedString(getAttributes: ( [NSAttributedString.Key: Any])-> [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: getAttributes(baseStyle))
        
        let sortedDetections = detections.sorted {
            $0.level < $1.level
        }
        
        for d in sortedDetections {
            let attrs = getAttributes(d.style)
            if attrs.count > 0 {
                attributedString.addAttributes(attrs, range: NSRange(d.range, in: string))
            }
        }
        
        return attributedString
    }
}

public final class AttributedText: AttributedTextProtocol {

    public let string: String
    public let detections: [Detection]
    public let baseStyle:  [NSAttributedString.Key: Any]
    
    init(string: String, detections: [Detection], baseStyle:  [NSAttributedString.Key: Any]) {
        self.string = string
        self.detections = detections
        self.baseStyle = baseStyle
    }

    public lazy private(set) var attributedString: NSAttributedString  = {
        makeAttributedString { $0 }
    }()
}

extension AttributedTextProtocol {
    
    /// style the whole string
    public func styleAll(_ style:  [NSAttributedString.Key: Any]) -> AttributedText {
        return AttributedText(string: string, detections: detections, baseStyle: baseStyle.merging(style, uniquingKeysWith: { lhs, rhs in
            return lhs
        }))
    }
    
    /// style things like #xcode #mentions
    public func styleHashtags(_ style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let ranges = string.detectHashTags()
        let ds = ranges.map { Detection(type: .hashtag(String(string[(string.index($0.lowerBound, offsetBy: 1))..<$0.upperBound])), style: style, range: $0, level: Int.max) }
        return AttributedText(string: string, detections: detections + ds, baseStyle: baseStyle)
    }
    
    /// style things like @John @all
    public func styleMentions(_ style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let ranges = string.detectMentions()
        let ds = ranges.map { Detection(type: .mention(String(string[(string.index($0.lowerBound, offsetBy: 1))..<$0.upperBound])), style: style, range: $0, level: Int.max) }
        return AttributedText(string: string, detections: detections + ds, baseStyle: baseStyle)
    }
    
    public func style(regex: String, options: NSRegularExpression.Options = [], style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let ranges = string.detect(regex: regex, options: options)
        let ds = ranges.map { Detection(type: .regex(regex), style: style, range: $0, level: Int.max) }
        return AttributedText(string: string, detections: detections + ds, baseStyle: baseStyle)
    }
    
    public func style(textCheckingTypes: NSTextCheckingResult.CheckingType, style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let ranges = string.detect(textCheckingTypes: textCheckingTypes)
        let ds = ranges.map { Detection(type: .textCheckingType(String(string[$0]), textCheckingTypes), style: style, range: $0, level: Int.max) }
        return AttributedText(string: string, detections: detections + ds, baseStyle: baseStyle)
    }
    
    public func stylePhoneNumbers(_ style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let ranges = string.detect(textCheckingTypes: [.phoneNumber])
        let ds = ranges.map { Detection(type: .phoneNumber(String(string[$0])), style: style, range: $0, level: Int.max) }
        return AttributedText(string: string, detections: detections + ds, baseStyle: baseStyle)
    }
    
    public func styleLinks(_ style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let ranges = string.detect(textCheckingTypes: [.link])
        
        #if swift(>=4.1)
        let ds = ranges.compactMap { range in
            URL(string: String(string[range])).map { Detection(type: .link($0), style: style, range: range, level: Int.max) }
        }
        #else
        let ds = ranges.flatMap { range in
            URL(string: String(string[range])).map { Detection(type: .link($0), style: style, range: range) }
        }
        #endif
        
        return AttributedText(string: string, detections: detections + ds, baseStyle: baseStyle)
    }
    
    public func style(range: Range<String.Index>, style:  [NSAttributedString.Key: Any]) -> AttributedText {
        let d = Detection(type: .range, style: style, range: range, level: Int.max)
        return AttributedText(string: string, detections: detections + [d], baseStyle: baseStyle)
    }
}

extension String: AttributedTextProtocol {
    
    public var string: String {
        return self
    }
    
    public var detections: [Detection] {
        return []
    }
    
    public var baseStyle:  [NSAttributedString.Key: Any] {
        return [:]
    }
    
    public func style(tags: [String:  [NSAttributedString.Key: Any]], transformers: [TagTransformer] = [TagTransformer.brTransformer], tuner: ( [NSAttributedString.Key: Any], Tag) ->  [NSAttributedString.Key: Any] = { s, _ in return  s}) -> AttributedText {
        let (string, tagsInfo) = detectTags(transformers: transformers)
        
        var ds: [Detection] = []
        
        tagsInfo.forEach { t in
            
            if let style = tags[t.tag.name.lowercased()] ?? tags[t.tag.name.uppercased()]  {
                ds.append(Detection(type: .tag(t.tag), style: tuner(style, t.tag), range: t.range, level: t.level))
            } else {
                ds.append(Detection(type: .tag(t.tag), style: tuner([:], t.tag), range: t.range, level: t.level))
            }
        }
        
        return AttributedText(string: string, detections: ds, baseStyle: baseStyle)
    }

    public var attributedString: NSAttributedString {
        return makeAttributedString { $0 }
    }
}

extension NSAttributedString: AttributedTextProtocol {
    
    public var detections: [Detection] {
        
        var ds: [Detection] = []
        
        enumerateAttributes(in: NSMakeRange(0, length), options: []) { (attributes, range, _) in
            if let range = Range(range, in: self.string) {
                ds.append(Detection(type: .range, style: attributes, range: range, level: Int.max))
            }
        }
        
        return ds
    }
    
    public var baseStyle:  [NSAttributedString.Key: Any] {
        return [:]
    }

    public var attributedString: NSAttributedString {
        return makeAttributedString { $0 }
    }
}
