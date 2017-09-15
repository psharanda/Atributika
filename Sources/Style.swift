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
    
    public let attributes: [NSAttributedStringKey: Any]
    
    public init(_ name: String = "", _ attributes: [NSAttributedStringKey: Any] = [:]) {
        self.name = name
        self.attributes = attributes
    }
    
    public func font(_ value: Font) -> Style {
        return merged(with: Style.font(value))
    }
    
    public func paragraphStyle(_ value: NSParagraphStyle) -> Style {
        return merged(with: Style.paragraphStyle(value))
    }
    
    public func foregroundColor(_ value: Color) -> Style {
        return merged(with: Style.foregroundColor(value))
    }
    
    public func backgroundColor(_ value: Color) -> Style {
        return merged(with: Style.backgroundColor(value))
    }
    
    public func ligature(_ value: Int) -> Style {
        return merged(with: Style.ligature(value))
    }
    
    public func kern(_ value: Float) -> Style {
        return merged(with: Style.kern(value))
    }
    
    public func strikethroughStyle(_ value: NSUnderlineStyle) -> Style {
        return merged(with: Style.strikethroughStyle(value))
    }
    
    public func strikethroughColor(_ value: Color) -> Style {
        return merged(with: Style.strikethroughColor(value))
    }
    
    public func underlineStyle(_ value: NSUnderlineStyle) -> Style {
        return merged(with: Style.underlineStyle(value))
    }
    
    func underlineColor(_ value: Color) -> Style {
        return merged(with: Style.underlineColor(value))
    }
    
    public func strokeColor(_ value: Color) -> Style {
        return merged(with: Style.strokeColor(value))
    }
    
    public func strokeWidth(_ value: Float) -> Style {
        return merged(with: Style.strokeWidth(value))
    }
    
    #if !os(watchOS)
    public func shadow(_ value: NSShadow) -> Style {
        return merged(with: Style.shadow(value))
    }
    #endif
    
    public func textEffect(_ value: String) -> Style {
        return merged(with: Style.textEffect(value))
    }
    
    #if !os(watchOS)
    public func attachment(_ value: NSTextAttachment) -> Style {
        return merged(with: Style.attachment(value))
    }
    #endif
    
    public func link(_ value: URL) -> Style {
        return merged(with: Style.link(value))
    }
    
    public func link(_ value: String) -> Style {
        return merged(with: Style.link(value))
    }
    
    public func baselineOffset(_ value: Float) -> Style {
        return merged(with: Style.baselineOffset(value))
    }
    
    public func obliqueness(_ value: Float) -> Style {
        return merged(with: Style.obliqueness(value))
    }
    
    public func expansion(_ value: Float) -> Style {
        return merged(with: Style.expansion(value))
    }
    
    public func writingDirection(_ value: NSWritingDirection) -> Style {
        return merged(with: Style.writingDirection(value))
    }
    
    public func merged(with style: Style) -> Style {
        var attrs = attributes
        style.attributes.forEach { attrs.updateValue($1, forKey: $0) }
        return Style(name, attrs)
    }
    
    public static func font(_ value: Font) -> Style {
        return Style("", [NSAttributedStringKey.font: value])
    }
    
    public static func paragraphStyle(_ value: NSParagraphStyle) -> Style {
        return Style("", [NSAttributedStringKey.paragraphStyle: value])
    }
    
    public static func foregroundColor(_ value: Color) -> Style {
        return Style("", [NSAttributedStringKey.foregroundColor: value])
    }
    
    public static func backgroundColor(_ value: Color) -> Style {
        return Style("", [NSAttributedStringKey.backgroundColor: value])
    }
    
    public static func ligature(_ value: Int) -> Style {
        return Style("", [NSAttributedStringKey.ligature: value])
    }
    
    public static func kern(_ value: Float) -> Style {
        return Style("", [NSAttributedStringKey.kern: value])
    }
    
    public static func strikethroughStyle(_ value: NSUnderlineStyle) -> Style {
        return Style("", [NSAttributedStringKey.strikethroughStyle : value.rawValue])
    }
    
    public static func strikethroughColor(_ value: Color) -> Style {
        return Style("", [NSAttributedStringKey.strikethroughColor: value])
    }
    
    public static func underlineStyle(_ value: NSUnderlineStyle) -> Style {
        return Style("", [NSAttributedStringKey.underlineStyle : value.rawValue])
    }
    
    public static func underlineColor(_ value: Color) -> Style {
        return Style("", [NSAttributedStringKey.underlineColor: value])
    }
    
    public static func strokeColor(_ value: Color) -> Style {
        return Style("", [NSAttributedStringKey.strokeColor: value])
    }
    
    public static func strokeWidth(_ value: Float) -> Style {
        return Style("", [NSAttributedStringKey.strokeWidth: value])
    }
    
    #if !os(watchOS)
    public static func shadow(_ value: NSShadow) -> Style {
        return Style("", [NSAttributedStringKey.shadow: value])
    }
    #endif
    
    public static func textEffect(_ value: String) -> Style {
        return Style("", [NSAttributedStringKey.textEffect: value])
    }
    
    #if !os(watchOS)
    public static func attachment(_ value: NSTextAttachment) -> Style {
        return Style("", [NSAttributedStringKey.attachment: value])
    }
    #endif
    
    public static func link(_ value: URL) -> Style {
        return Style("", [NSAttributedStringKey.link: value])
    }
    
    public static func link(_ value: String) -> Style {
        return Style("", [NSAttributedStringKey.link: value])
    }
    
    public static func baselineOffset(_ value: Float) -> Style {
        return Style("", [NSAttributedStringKey.baselineOffset: value])
    }
    
    public static func obliqueness(_ value: Float) -> Style {
        return Style("", [NSAttributedStringKey.obliqueness: value])
    }
    
    public static func expansion(_ value: Float) -> Style {
        return Style("", [NSAttributedStringKey.expansion: value])
    }
    
    public static func writingDirection(_ value: NSWritingDirection) -> Style {
        return Style("", [NSAttributedStringKey.writingDirection: value.rawValue])
    }
}
