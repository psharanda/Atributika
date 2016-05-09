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

public struct TagInfo : Equatable {
    public let name: String
    public let attributes: [String: String]
    public var range: Range<Int>
}

public func ==(lhs: TagInfo, rhs: TagInfo) -> Bool {
    return lhs.name == rhs.name && lhs.attributes == rhs.attributes && lhs.range == rhs.range
}

public struct Atributika {
    public let text: String
    public let tags: [String: [Attribute]]
    public let baseAttributes: [Attribute]
    
    public init(text: String, tags: [String: [Attribute]] = [:], baseAttributes: [Attribute] = []) {
        self.text = text
        self.tags = tags
        self.baseAttributes = baseAttributes
    }

    private func attributesListToAttributes(attributesList: [Attribute]) -> [String : AnyObject] {
        var attrs = [String : AnyObject]()
        
        for  style in attributesList {
            attrs[style.name] = style.value
        }
        
        return attrs
    }
    
    private func buildAttributedStringInternal() -> (NSAttributedString, [TagInfo]) {
       
        let (parsedText, tagsInfo) = parseText(text)
        
        let attributedString = NSMutableAttributedString(string: parsedText, attributes: attributesListToAttributes(baseAttributes))
        
        for tagInfo in tagsInfo
        {
            if let a = tags[tagInfo.name] {
               attributedString.addAttributes(attributesListToAttributes(a), range: NSRange(tagInfo.range))
            }
        }
        
        return (attributedString, tagsInfo)
    }
    
    public func buildAttributedString() -> NSAttributedString {
        return buildAttributedStringInternal().0
    }
    
    public func buildAttributedStringAndTagsInfo() -> (NSAttributedString, [TagInfo]) {
        return buildAttributedStringInternal()
    }
    
    private let specials = ["quot":"\"",
                    "amp":"&",
                    "apos":"'",
                    "lt":"<",
                    "gt":">"]
    
    private func parseTag(tagString: String, parseAttributes: Bool) -> (String, [String:String])? {
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
        
        return (tagName, attrubutes)
    }
    
    private func parseText(text: String) -> (String, [TagInfo]) {
        
        let scanner = NSScanner(string: text)
        scanner.charactersToBeSkipped = nil
        var resultString = String()
        var tagsResult = [TagInfo]()
        var tagsStack = [(String, [String: String], Int)]()
        
        while !scanner.atEnd {
            
            if let textString = scanner.scanUpToCharactersFromSet(NSCharacterSet(charactersInString: "<&")) {
                resultString += textString
            } else {
                if scanner.scanString("<") != nil {
                    let open = scanner.scanString("/") == nil
                    if let tagString = scanner.scanUpToString(">") {
                        
                        if let (tagName, attributes) = parseTag(tagString, parseAttributes: open) {
                            
                            if tagName == "br" {
                                resultString += "\n"
                            } else {
                                let resultTextEndIndex = resultString.characters.count
                                
                                if open {
                                    tagsStack.append((tagName, attributes, resultTextEndIndex))
                                } else {
                                    for (index, (stackTagName, attributes, startIndex)) in tagsStack.enumerate().reverse() {
                                        if stackTagName == tagName {
                                            tagsResult.append(TagInfo(name: stackTagName, attributes: attributes, range: startIndex..<resultTextEndIndex))
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
}
