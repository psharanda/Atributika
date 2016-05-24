// The MIT License (MIT) - Copyright (c) 2016 Pavel Sharanda
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import UIKit

public enum Attribute {
    case Font(UIFont)
    case ParagraphStyle(NSParagraphStyle)
    case ForegroundColor(UIColor)
    case BackgroundColor(UIColor)
    case Ligature(Int)
    case Kern(Float)
    case StriketroughStyle(NSUnderlineStyle)
    case UnderlineStyle(NSUnderlineStyle)
    case StrokeColor(UIColor)
    case StrokeWidth(Float)
    case Shadow(NSShadow)
    case TextEffect(String)
    case Attachment(NSTextAttachment)
    case LinkURL(NSURL)
    case Link(String)
    case BaselineOffset(Float)
    case UnderlineColor(UIColor)
    case StrikethroughColor(UIColor)
    case Obliqueness(Float)
    case Expansion(Float)
    case WritingDirection(NSWritingDirection)
    case VerticalGlyphForm(Int)
    
    public var name: String {
        switch self {
        case .Font:
            return NSFontAttributeName
        case .ParagraphStyle:
            return NSParagraphStyleAttributeName
        case .ForegroundColor:
            return NSForegroundColorAttributeName
        case .BackgroundColor:
            return NSBackgroundColorAttributeName
        case .Ligature:
            return NSLigatureAttributeName
        case .Kern:
            return NSKernAttributeName
        case .StriketroughStyle:
            return NSStrikethroughStyleAttributeName
        case .UnderlineStyle:
            return NSUnderlineStyleAttributeName
        case .StrokeColor:
            return NSStrokeColorAttributeName
        case .StrokeWidth:
            return NSStrokeWidthAttributeName
        case .Shadow:
            return NSShadowAttributeName
        case .TextEffect:
            return NSTextEffectAttributeName
        case .Attachment:
            return NSAttachmentAttributeName
        case .LinkURL:
            return NSLinkAttributeName
        case .Link:
            return NSLinkAttributeName
        case .BaselineOffset:
            return NSBaselineOffsetAttributeName
        case .UnderlineColor:
            return NSUnderlineColorAttributeName
        case .StrikethroughColor:
            return NSStrikethroughColorAttributeName
        case .Obliqueness:
            return NSObliquenessAttributeName
        case .Expansion:
            return NSExpansionAttributeName
        case .WritingDirection:
            return NSWritingDirectionAttributeName
        case .VerticalGlyphForm:
            return NSVerticalGlyphFormAttributeName
        }
    }
    
    public var value: AnyObject {
        switch self {
        case Font(let font):
            return font
        case ParagraphStyle(let style):
            return style
        case ForegroundColor(let color):
            return color
        case BackgroundColor(let color):
            return color
        case Ligature(let ligature):
            return ligature
        case Kern(let kerning):
            return kerning
        case StriketroughStyle(let style):
            return style.rawValue
        case UnderlineStyle(let style):
            return style.rawValue
        case StrokeColor(let color):
            return color
        case StrokeWidth(let width):
            return width
        case Shadow(let shadow):
            return shadow
        case TextEffect(let effect):
            return effect
        case Attachment(let attachment):
            return attachment
        case LinkURL(let url):
            return url
        case Link(let url):
            return url
        case BaselineOffset(let offset):
            return offset
        case UnderlineColor(let color):
            return color
        case StrikethroughColor(let color):
            return color
        case Obliqueness(let obliqueness):
            return obliqueness
        case Expansion(let expansion):
            return expansion
        case WritingDirection(let direction):
            return direction.rawValue
        case VerticalGlyphForm(let form):
            return form
        }
    }
}

public struct Tag : Equatable {
    public let name: String
    public let attributes: [String: String]
}

public struct TagInfo: Equatable {
    public let tag: Tag
    public let range: Range<Int>
}

public func ==(lhs: Tag, rhs: Tag) -> Bool {
    return lhs.name == rhs.name && lhs.attributes == rhs.attributes
}

public func ==(lhs: TagInfo, rhs: TagInfo) -> Bool {
    return lhs.tag == rhs.tag && lhs.range == rhs.range
}

public typealias Style = [Attribute]


public struct Atributika {
    
    public var text: String
    public var styles: [String: Style]
    public var baseStyle: Style
    public var hashtags: String?
    public var dataDetectorTypes: NSTextCheckingTypes?
    public var dataDetectorTagName: String?
    
    public init(text: String = "", styles: [String: Style] = [:], baseStyle: Style = []) {
        self.text = text
        self.styles = styles
        self.baseStyle = baseStyle
    }
    
    public func buildAttributedString() -> NSAttributedString {
        return buildAttributedStringAndTagsInfo().string
    }
    
    public func buildAttributedStringAndTagsInfo() -> (string: NSAttributedString, tagsInfo: [TagInfo]) {
        var (string, tags) = Atributika.parseTags(text)
        
        if let hs = hashtags {
            tags += Atributika.detectHashTags(string, hashtags: hs)
        }
        
        if let ddtypes = dataDetectorTypes, let ddTagName = dataDetectorTagName {
            tags += Atributika.detectData(string, types: ddtypes, tagName: ddTagName)
        }
        
        return (Atributika.createAttributedString(string, tags: tags, styles: styles, baseStyle: baseStyle), tags)
    }
}

public extension Atributika {
    
    private static func parseTag(tagString: String, parseAttributes: Bool) -> Tag? {
        
        let tagScanner = NSScanner(string: tagString)
        
        guard let tagName = tagScanner.scanCharactersFromSet(NSCharacterSet.letterCharacterSet()) else {
            return nil
        }
        
        var attrubutes = [String: String]()
        
        while parseAttributes && !tagScanner.atEnd {
            
            guard let name = tagScanner.scanUpToString("=") else {
                break
            }
            
            guard tagScanner.scanString("=") != nil else {
                break
            }
            
            guard tagScanner.scanString("\"") != nil else {
                break
            }
            
            guard let value = tagScanner.scanUpToString("\"") else {
                break
            }
            
            guard tagScanner.scanString("\"") != nil else {
                break
            }
            
            attrubutes[name] = value.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        }
        
        return Tag(name: tagName, attributes: attrubutes)
    }
    
    private static let specials = ["quot":"\"",
                                   "amp":"&",
                                   "apos":"'",
                                   "lt":"<",
                                   "gt":">"]
    
    public static func parseTags(string: String) -> (string: String, tagsInfo: [TagInfo]) {
        
        let scanner = NSScanner(string: string)
        scanner.charactersToBeSkipped = nil
        var resultString = String()
        var tagsResult = [TagInfo]()
        var tagsStack = [(Tag, Int)]()
        
        while !scanner.atEnd {
            
            if let textString = scanner.scanUpToCharactersFromSet(NSCharacterSet(charactersInString: "<&")) {
                resultString += textString
            } else {
                if scanner.scanString("<") != nil {
                    let open = scanner.scanString("/") == nil
                    if let tagString = scanner.scanUpToString(">") {
                        
                        if let tag = parseTag(tagString, parseAttributes: open) {
                            
                            if tag.name == "br" {
                                resultString += "\n"
                            } else {
                                let resultTextEndIndex = resultString.characters.count
                                
                                if open {
                                    tagsStack.append((tag, resultTextEndIndex))
                                } else {
                                    for (index, (tagInStack, startIndex)) in tagsStack.enumerate().reverse() {
                                        if tagInStack.name == tag.name {
                                            tagsResult.append(TagInfo(tag: tagInStack, range: startIndex..<resultTextEndIndex))
                                            tagsStack.removeAtIndex(index)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                        
                        scanner.scanString(">")
                    }
                } else if scanner.scanString("&") != nil {
                    if let specialString = scanner.scanUpToString(";") {
                        if let spec = specials[specialString] {
                            resultString += spec
                        }
                        scanner.scanString(";")
                    }
                }
            }
        }
        
        return (resultString, tagsResult)
    }
    
    public static func detectHashTags(string: String, hashtags: String = "#@") -> [TagInfo] {
        
        if hashtags.characters.count == 0 {
            return []
        }
        
        var tagsResult = [TagInfo]()
        
        let dataDetector = try? NSRegularExpression(pattern: "[\(hashtags)]\\w\\S*\\b", options: [])
        dataDetector?.enumerateMatchesInString(string, options: [], range: NSMakeRange(0, (string as NSString).length), usingBlock: { (result, flags, _) in
            if let r = result, let range = r.range.toRange() {
                let tagName = (string as NSString).substringWithRange(NSMakeRange(r.range.location, 1))
                tagsResult.append(TagInfo(tag: Tag(name: tagName, attributes: [:]), range: range))
            }
        })
        
        return tagsResult
    }
    
    public static func detectData(string: String, types: NSTextCheckingTypes, tagName: String) -> [TagInfo] {
        
        var tagsResult = [TagInfo]()
        
        let dataDetector = try? NSDataDetector(types: types)
        dataDetector?.enumerateMatchesInString(string, options: [], range: NSMakeRange(0, (string as NSString).length), usingBlock: { (result, flags, _) in
            if let r = result, let range = r.range.toRange() {
                tagsResult.append(TagInfo(tag: Tag(name: tagName, attributes: [:]), range: range))
            }
        })
        return tagsResult
    }
    
    private static func styleToAttributes(style: Style) -> [String : AnyObject] {
        
        var attrs = [String : AnyObject]()
        
        for  style in style {
            attrs[style.name] = style.value
        }
        
        return attrs
    }
    
    public static func createAttributedString(string: String,
                                              style: Style) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: styleToAttributes(style))
    }
    
    public static func createAttributedString(string: String,
                                              tags: [TagInfo],
                                              styles: [String: Style],
                                              baseStyle: Style) -> NSMutableAttributedString {
        
        let attributedString = createAttributedString(string, style: baseStyle)
        
        for tagInfo in tags {
            if let a = styles[tagInfo.tag.name] {
                attributedString.addAttributes(styleToAttributes(a), range: NSRange(tagInfo.range))
            }
        }
        
        return attributedString
    }
}


