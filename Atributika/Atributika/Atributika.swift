// The MIT License (MIT) - Copyright (c) 2016 Pavel Sharanda
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import Foundation
import UIKit.UIColor

public enum Attribute {
    case font(UIFont)
    case paragraphStyle(NSParagraphStyle)
    case foregroundColor(UIColor)
    case backgroundColor(UIColor)
    case ligature(Int)
    case kern(Float)
    case striketroughStyle(NSUnderlineStyle)
    case underlineStyle(NSUnderlineStyle)
    case strokeColor(UIColor)
    case strokeWidth(Float)
    case shadow(NSShadow)
    case textEffect(String)
    case attachment(NSTextAttachment)
    case linkURL(URL)
    case link(String)
    case baselineOffset(Float)
    case underlineColor(UIColor)
    case strikethroughColor(UIColor)
    case obliqueness(Float)
    case expansion(Float)
    case writingDirection(NSWritingDirection)
    case verticalGlyphForm(Int)
    
    public var name: String {
        switch self {
        case .font:
            return NSFontAttributeName
        case .paragraphStyle:
            return NSParagraphStyleAttributeName
        case .foregroundColor:
            return NSForegroundColorAttributeName
        case .backgroundColor:
            return NSBackgroundColorAttributeName
        case .ligature:
            return NSLigatureAttributeName
        case .kern:
            return NSKernAttributeName
        case .striketroughStyle:
            return NSStrikethroughStyleAttributeName
        case .underlineStyle:
            return NSUnderlineStyleAttributeName
        case .strokeColor:
            return NSStrokeColorAttributeName
        case .strokeWidth:
            return NSStrokeWidthAttributeName
        case .shadow:
            return NSShadowAttributeName
        case .textEffect:
            return NSTextEffectAttributeName
        case .attachment:
            return NSAttachmentAttributeName
        case .linkURL:
            return NSLinkAttributeName
        case .link:
            return NSLinkAttributeName
        case .baselineOffset:
            return NSBaselineOffsetAttributeName
        case .underlineColor:
            return NSUnderlineColorAttributeName
        case .strikethroughColor:
            return NSStrikethroughColorAttributeName
        case .obliqueness:
            return NSObliquenessAttributeName
        case .expansion:
            return NSExpansionAttributeName
        case .writingDirection:
            return NSWritingDirectionAttributeName
        case .verticalGlyphForm:
            return NSVerticalGlyphFormAttributeName
        }
    }
    
    public var value: Any {
        switch self {
        case .font(let font):
            return font
        case .paragraphStyle(let style):
            return style
        case .foregroundColor(let color):
            return color
        case .backgroundColor(let color):
            return color
        case .ligature(let ligature):
            return ligature
        case .kern(let kerning):
            return kerning
        case .striketroughStyle(let style):
            return style.rawValue
        case .underlineStyle(let style):
            return style.rawValue
        case .strokeColor(let color):
            return color
        case .strokeWidth(let width):
            return width
        case .shadow(let shadow):
            return shadow
        case .textEffect(let effect):
            return effect
        case .attachment(let attachment):
            return attachment
        case .linkURL(let url):
            return url
        case .link(let url):
            return url
        case .baselineOffset(let offset):
            return offset
        case .underlineColor(let color):
            return color
        case .strikethroughColor(let color):
            return color
        case .obliqueness(let obliqueness):
            return obliqueness
        case .expansion(let expansion):
            return expansion
        case .writingDirection(let direction):
            return direction.rawValue
        case .verticalGlyphForm(let form):
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
    
    fileprivate static func parseTag(_ tagString: String, parseAttributes: Bool) -> Tag? {
        
        let tagScanner = Scanner(string: tagString)
        
        guard let tagName = tagScanner.scanCharacters(from: CharacterSet.letters) else {
            return nil
        }
        
        var attrubutes = [String: String]()
        
        while parseAttributes && !tagScanner.isAtEnd {
            
            guard let name = tagScanner.scanUpTo("=") else {
                break
            }
            
            guard tagScanner.scanString("=") != nil else {
                break
            }
            
            guard tagScanner.scanString("\"") != nil else {
                break
            }
            
            guard let value = tagScanner.scanUpTo("\"") else {
                break
            }
            
            guard tagScanner.scanString("\"") != nil else {
                break
            }
            
            attrubutes[name] = value.replacingOccurrences(of: "&quot;", with: "\"")
        }
        
        return Tag(name: tagName, attributes: attrubutes)
    }
    
    fileprivate static let specials = ["quot":"\"",
                                   "amp":"&",
                                   "apos":"'",
                                   "lt":"<",
                                   "gt":">"]
    
    public static func parseTags(_ string: String) -> (string: String, tagsInfo: [TagInfo]) {
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        var resultString = String()
        var tagsResult = [TagInfo]()
        var tagsStack = [(Tag, Int)]()
        
        while !scanner.isAtEnd {
            
            if let textString = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "<&")) {
                resultString += textString
            } else {
                if scanner.scanString("<") != nil {
                    let open = scanner.scanString("/") == nil
                    if let tagString = scanner.scanUpTo(">") {
                        
                        if let tag = parseTag(tagString, parseAttributes: open) {
                            
                            if tag.name == "br" {
                                resultString += "\n"
                            } else {
                                let resultTextEndIndex = resultString.characters.count
                                
                                if open {
                                    tagsStack.append((tag, resultTextEndIndex))
                                } else {
                                    for (index, (tagInStack, startIndex)) in tagsStack.enumerated().reversed() {
                                        if tagInStack.name == tag.name {
                                            tagsResult.append(TagInfo(tag: tagInStack, range: startIndex..<resultTextEndIndex))
                                            tagsStack.remove(at: index)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                        
                        scanner.scanString(">")
                    }
                } else if scanner.scanString("&") != nil {
                    if let specialString = scanner.scanUpTo(";") {
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
    
    public static func detectHashTags(_ string: String, hashtags: String = "#@") -> [TagInfo] {
        
        if hashtags.characters.count == 0 {
            return []
        }
        
        var tagsResult = [TagInfo]()
        
        let dataDetector = try? NSRegularExpression(pattern: "[\(hashtags)]\\w\\S*\\b", options: [])
        dataDetector?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, (string as NSString).length), using: { (result, flags, _) in
            if let r = result, let range = r.range.toRange() {
                let tagName = (string as NSString).substring(with: NSMakeRange(r.range.location, 1))
                tagsResult.append(TagInfo(tag: Tag(name: tagName, attributes: [:]), range: range))
            }
        })
        
        return tagsResult
    }
    
    public static func detectData(_ string: String, types: NSTextCheckingTypes, tagName: String) -> [TagInfo] {
        
        var tagsResult = [TagInfo]()
        
        let dataDetector = try? NSDataDetector(types: types)
        dataDetector?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, (string as NSString).length), using: { (result, flags, _) in
            if let r = result, let range = r.range.toRange() {
                tagsResult.append(TagInfo(tag: Tag(name: tagName, attributes: [:]), range: range))
            }
        })
        return tagsResult
    }
    
    fileprivate static func styleToAttributes(_ style: Style) -> [String : Any] {
        
        var attrs = [String : Any]()
        
        for  style in style {
            attrs[style.name] = style.value
        }
        
        return attrs
    }
    
    public static func createAttributedString(_ string: String,
                                              style: Style) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: styleToAttributes(style))
    }
    
    public static func createAttributedString(_ string: String,
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


