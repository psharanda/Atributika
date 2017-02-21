//
//  Created by Pavel Sharanda on 21.02.17.
//  Copyright © 2017 psharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

#if os(macOS)
    public typealias Font = NSFont
    public typealias Color = NSColor
#else
    public typealias Font = UIFont
    public typealias Color = UIColor
#endif

public class Style {
    
    public let name: String
    
    public var attributes: [String: Any]
    
    public init(_ name: String = "", _ attributes: [String: Any] = [:]) {
        self.name = name
        self.attributes = attributes
    }
    
    public func font(_ value: Font) -> Style {
        attributes[NSFontAttributeName] = value
        return self
    }
    
    public func paragraphStyle(_ value: NSParagraphStyle) -> Style {
        attributes[NSParagraphStyleAttributeName] = value
        return self
    }
    
    public func foregroundColor(_ value: Color) -> Style {
        attributes[NSForegroundColorAttributeName] = value
        return self
    }
    
    public func backgroundColor(_ value: Color) -> Style {
        attributes[NSBackgroundColorAttributeName] = value
        return self
    }
    
    public func ligature(_ value: Int) -> Style {
        attributes[NSLigatureAttributeName] = value
        return self
    }
    
    public func kern(_ value: Float) -> Style {
        attributes[NSKernAttributeName] = value
        return self
    }
    
    public func striketroughStyle(_ value: NSUnderlineStyle) -> Style {
        attributes[NSStrikethroughColorAttributeName] = value.rawValue
        return self
    }
    
    public func strikethroughColor(_ value: Color) -> Style {
        attributes[NSFontAttributeName] = value
        return self
    }
    
    public func underlineStyle(_ value: NSUnderlineStyle) -> Style {
        attributes[NSUnderlineStyleAttributeName] = value.rawValue
        return self
    }
    
    func underlineColor(_ value: Color) -> Style {
        attributes[NSUnderlineColorAttributeName] = value
        return self
    }
    
    public func strokeColor(_ value: Color) -> Style {
        attributes[NSStrokeColorAttributeName] = value
        return self
    }
    
    public func strokeWidth(_ value: Float) -> Style {
        attributes[NSStrokeWidthAttributeName] = value
        return self
    }
    
    #if !os(watchOS)
    public func shadow(_ value: NSShadow) -> Style {
        attributes[NSShadowAttributeName] = value
        return self
    }
    #endif
    
    public func textEffect(_ value: String) -> Style {
        attributes[NSTextEffectAttributeName] = value
        return self
    }
    
    #if !os(watchOS)
    public func attachment(_ value: NSTextAttachment) -> Style {
        attributes[NSAttachmentAttributeName] = value
        return self
    }
    #endif
    
    public func link(_ value: URL) -> Style {
        attributes[NSLinkAttributeName] = value
        return self
    }
    
    public func link(_ value: String) -> Style {
        attributes[NSLinkAttributeName] = value
        return self
    }
    
    public func baselineOffset(_ value: Float) -> Style {
        attributes[NSBaselineOffsetAttributeName] = value
        return self
    }
    
    public func obliqueness(_ value: Float) -> Style {
        attributes[NSObliquenessAttributeName] = value
        return self
    }
    
    public func expansion(_ value: Float) -> Style {
        attributes[NSExpansionAttributeName] = value
        return self
    }
    
    public func writingDirection(_ value: NSWritingDirection) -> Style {
        attributes[NSWritingDirectionAttributeName] = value.rawValue
        return self
    }
    
    public func merged(with style: Style) -> Style {
        var attrs = attributes
        style.attributes.forEach { attrs.updateValue($1, forKey: $0) }
        return Style(name, attrs)
    }
    public static func font(_ value: Font) -> Style {
        return Style("", [NSFontAttributeName: value])
    }
    
    public static func paragraphStyle(_ value: NSParagraphStyle) -> Style {
        return Style("", [NSParagraphStyleAttributeName: value])
    }
    
    public static func foregroundColor(_ value: Color) -> Style {
        return Style("", [NSForegroundColorAttributeName: value])
    }
    
    public static func backgroundColor(_ value: Color) -> Style {
        return Style("", [NSBackgroundColorAttributeName: value])
    }
    
    public static func ligature(_ value: Int) -> Style {
        return Style("", [NSLigatureAttributeName: value])
    }
    
    public static func kern(_ value: Float) -> Style {
        return Style("", [NSKernAttributeName: value])
    }
    
    public static func striketroughStyle(_ value: NSUnderlineStyle) -> Style {
        return Style("", [NSStrikethroughColorAttributeName : value.rawValue])
    }
    
    public static func strikethroughColor(_ value: Color) -> Style {
        return Style("", [NSFontAttributeName: value])
    }
    
    public static func underlineStyle(_ value: NSUnderlineStyle) -> Style {
        return Style("", [NSUnderlineStyleAttributeName : value.rawValue])
    }
    
    public static func underlineColor(_ value: Color) -> Style {
        return Style("", [NSUnderlineColorAttributeName: value])
    }
    
    public static func strokeColor(_ value: Color) -> Style {
        return Style("", [NSStrokeColorAttributeName: value])
    }
    
    public static func strokeWidth(_ value: Float) -> Style {
        return Style("", [NSStrokeWidthAttributeName: value])
    }
    
    #if !os(watchOS)
    public static func shadow(_ value: NSShadow) -> Style {
        return Style("", [NSShadowAttributeName: value])
    }
    #endif
    
    public static func textEffect(_ value: String) -> Style {
        return Style("", [NSTextEffectAttributeName: value])
    }
    
    #if !os(watchOS)
    public static func attachment(_ value: NSTextAttachment) -> Style {
        return Style("", [NSAttachmentAttributeName: value])
    }
    #endif
    
    public static func link(_ value: URL) -> Style {
        return Style("", [NSLinkAttributeName: value])
    }
    
    public static func link(_ value: String) -> Style {
        return Style("", [NSLinkAttributeName: value])
    }
    
    public static func baselineOffset(_ value: Float) -> Style {
        return Style("", [NSBaselineOffsetAttributeName: value])
    }
    
    public static func obliqueness(_ value: Float) -> Style {
        return Style("", [NSObliquenessAttributeName: value])
    }
    
    public static func expansion(_ value: Float) -> Style {
        return Style("", [NSExpansionAttributeName: value])
    }
    
    public static func writingDirection(_ value: NSWritingDirection) -> Style {
        return Style("", [NSWritingDirectionAttributeName: value.rawValue])
    }
}
