/**
 *  Atributika
 *
 *  Copyright (c) 2017 Pavel Sharanda. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import Foundation

public enum DetectionType {
    case tag(Tag)
    case hashtag
    case mention
    case regex(String)
    case textCheckingType(NSTextCheckingTypes)
    case none
}

public struct Detection {
    public let type: DetectionType
    public let style: AtributikaManipulationProtocol
    public let range: Range<Int>
}

public enum ManipulationType {
    case style
    case prepend
    case replace
    case append
}

public struct Manipulation {
    public let type: ManipulationType
    public let string: String
    public let range: Range<Int>
}

public protocol AtributikaProtocol {
    var string: String {get}
    var detections: [Detection] {get}
    var baseStyle: Style {get}
    var manipulations: [Manipulation] {get}
}

public protocol AtributikaManipulationProtocol {
    var name: String {get}
    var attributes: [String: Any] {get}
    var string: String {get}
    var type: ManipulationType {get}
}

extension AtributikaProtocol {
    
    public var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: baseStyle.attributes)
        
        for d in detections {
            if d.style.attributes.count > 0 {
                attributedString.addAttributes(d.style.attributes, range: NSRange(d.range))
            }
        }
        
        var offset = 0
        for m in manipulations.sorted(by: { $0.range.lowerBound < $1.range.lowerBound }) {
            let range = Range(uncheckedBounds: (lower: m.range.lowerBound + offset, upper: m.range.upperBound + offset))
            
            switch m.type {
                case .prepend:
                    let string = NSAttributedString(string: m.string, attributes: attributedString.attributes(at: range.lowerBound, longestEffectiveRange: nil, in: NSRange(range)))
                    attributedString.insert(string, at: range.lowerBound)
                    offset += string.length
                
                case .append:
                    let location = min(range.upperBound, attributedString.length - 1)
                    let string = NSAttributedString(string: m.string, attributes: attributedString.attributes(at: location, longestEffectiveRange: nil, in: NSRange(range)))
                    
                    if location == (attributedString.length - 1) {
                        attributedString.append(string)
                    } else {
                        attributedString.insert(string, at: location)
                    }
                    offset += string.length
                
                case .replace:
                    let string = NSAttributedString(string: m.string, attributes: attributedString.attributes(at: range.lowerBound, longestEffectiveRange: nil, in: NSRange(range)))
                    attributedString.replaceCharacters(in: NSRange(range), with: string)
                    let rangeLength = range.upperBound - range.lowerBound
                    offset += max(rangeLength, string.length) - min(rangeLength, string.length)
                
                default:
                    break
            }
        }
        
        return attributedString
    }
}

public struct Atributika: AtributikaProtocol {
    public let string: String
    public let detections: [Detection]
    public let baseStyle: Style
    public let manipulations: [Manipulation]
    
    public init(string: String, detections: [Detection], baseStyle: Style, manipulations: [Manipulation]) {
        self.string = string
        self.detections = detections
        self.baseStyle = baseStyle
        self.manipulations = manipulations
    }
}

extension AtributikaProtocol {
    
    /// style the whole string
    public func styleAll(_ style: Style) -> Atributika {
        return Atributika(string: string, detections: detections, baseStyle: baseStyle.merged(with: style), manipulations: manipulations)
    }
    
    /// style things like #xcode #mentions
    public func styleHashtags(_ style: Style) -> Atributika {
        let ranges = string.detectHashTags()
        let ds = ranges.map { Detection(type: .hashtag, style: style, range: $0) }
        return Atributika(string: string, detections: detections + ds, baseStyle: baseStyle, manipulations: manipulations)
    }
    
    /// style things like @John @all
    public func styleMentions(_ style: Style) -> Atributika {
        let ranges = string.detectMentions()
        let ds = ranges.map { Detection(type: .mention, style: style, range: $0) }
        return Atributika(string: string, detections: detections + ds, baseStyle: baseStyle, manipulations: manipulations)
    }
    
    public func style(regex: String, options: NSRegularExpression.Options = [], style: Style) -> Atributika {
        let ranges = string.detect(regex: regex, options: options)
        let ds = ranges.map { Detection(type: .regex(regex), style: style, range: $0) }
        return Atributika(string: string, detections: detections + ds, baseStyle: baseStyle, manipulations: manipulations)
    }
    
    public func style(textCheckingTypes: NSTextCheckingTypes, style: Style) -> Atributika {
        let ranges = string.detect(textCheckingTypes: textCheckingTypes)
        let ds = ranges.map { Detection(type: .textCheckingType(textCheckingTypes), style: style, range: $0) }
        return Atributika(string: string, detections: detections + ds, baseStyle: baseStyle, manipulations: manipulations)
    }
    
    public func style(range: Range<Int>, style: Style) -> Atributika {
        let d = Detection(type: .none, style: style, range: range)
        return Atributika(string: string, detections: detections + [d], baseStyle: baseStyle, manipulations: manipulations)
    }
}

extension String: AtributikaProtocol {
    
    public var string: String {
        return self
    }
    
    public var detections: [Detection] {
        return []
    }
    
    public var baseStyle: Style {
        return Style()
    }
    
    public var manipulations: [Manipulation] {
        return []
    }
    
    public func style(tags: [AtributikaManipulationProtocol]) -> AtributikaProtocol {
        let (string, tagsInfo) = detectTags()
        
        var ds: [Detection] = []
        var ms: [Manipulation] = []
        
        tagsInfo.forEach { t in
            
            tags.filter({ mutation in mutation.name == t.tag.name }).forEach { (mutation) in
                switch mutation.type {
                    case .style:
                        ds.append(Detection(type: .tag(t.tag), style: mutation, range: t.range))
                    default:
                        ms.append(Manipulation(type: mutation.type, string: mutation.string, range: t.range))
                }
            }
        }
        
        return Atributika(string: string, detections: ds, baseStyle: baseStyle, manipulations: ms)
    }
    
    public func style(tags: AtributikaManipulationProtocol...) -> AtributikaProtocol {
        return style(tags: tags)
    }
}

extension NSAttributedString: AtributikaProtocol {
    
    public var detections: [Detection] {
        
        var ds: [Detection] = []
        
        enumerateAttributes(in: NSMakeRange(0, length), options: []) { (attributes, range, _) in
            if let range = range.toRange() {
                ds.append(Detection(type: .none, style: Style("", attributes), range: range))
            }
        }
        
        return ds
    }
    
    public var baseStyle: Style {
        return Style()
    }
    
    public var manipulations: [Manipulation] {
        return []
    }
}
