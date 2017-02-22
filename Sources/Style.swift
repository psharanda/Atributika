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

public struct Style {
    
    public let name: String
    
    public let attributes: [String: Any]
    
    public init(_ name: String = "", _ attributes: [String: Any] = [:]) {
        self.name = name
        self.attributes = attributes
    }
    
    private func updated(withName: String, value: Any) -> Style {
        return merged(with: Style("", [withName: value]))
    }
    
    public func font(_ value: Font) -> Style {
        return updated(withName: NSFontAttributeName, value: value)
    }
    
    public func paragraphStyle(_ value: NSParagraphStyle) -> Style {
        return updated(withName: NSParagraphStyleAttributeName, value: value)
    }
    
    public func foregroundColor(_ value: Color) -> Style {
        return updated(withName: NSForegroundColorAttributeName, value: value)
    }
    
    public func backgroundColor(_ value: Color) -> Style {
        return updated(withName: NSBackgroundColorAttributeName, value: value)
    }
    
    public func ligature(_ value: Int) -> Style {
        return updated(withName: NSLigatureAttributeName, value: value)
    }
    
    public func kern(_ value: Float) -> Style {
        return updated(withName: NSKernAttributeName, value: value)
    }
    
    public func striketroughStyle(_ value: NSUnderlineStyle) -> Style {
        return updated(withName: NSStrikethroughColorAttributeName, value: value.rawValue)
    }
    
    public func strikethroughColor(_ value: Color) -> Style {
        return updated(withName: NSFontAttributeName, value: value)
    }
    
    public func underlineStyle(_ value: NSUnderlineStyle) -> Style {
        return updated(withName: NSUnderlineStyleAttributeName, value: value.rawValue)
    }
    
    func underlineColor(_ value: Color) -> Style {
        return updated(withName: NSUnderlineColorAttributeName, value: value)
    }
    
    public func strokeColor(_ value: Color) -> Style {
        return updated(withName: NSStrokeColorAttributeName, value: value)
    }
    
    public func strokeWidth(_ value: Float) -> Style {
        return updated(withName: NSStrokeWidthAttributeName, value: value)
    }
    
    #if !os(watchOS)
    public func shadow(_ value: NSShadow) -> Style {
        return updated(withName: NSShadowAttributeName, value: value)
    }
    #endif
    
    public func textEffect(_ value: String) -> Style {
        return updated(withName: NSTextEffectAttributeName, value: value)
    }
    
    #if !os(watchOS)
    public func attachment(_ value: NSTextAttachment) -> Style {
        return updated(withName: NSAttachmentAttributeName, value: value)
    }
    #endif
    
    public func link(_ value: URL) -> Style {
        return updated(withName: NSLinkAttributeName, value: value)
    }
    
    public func link(_ value: String) -> Style {
        return updated(withName: NSLinkAttributeName, value: value)
    }
    
    public func baselineOffset(_ value: Float) -> Style {
        return updated(withName: NSBaselineOffsetAttributeName, value: value)
    }
    
    public func obliqueness(_ value: Float) -> Style {
        return updated(withName: NSObliquenessAttributeName, value: value)
    }
    
    public func expansion(_ value: Float) -> Style {
        return updated(withName: NSExpansionAttributeName, value: value)
    }
    
    public func writingDirection(_ value: NSWritingDirection) -> Style {
        return updated(withName: NSWritingDirectionAttributeName, value: value.rawValue)
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
