//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif


public struct Style {
    
    public let attributes: [NSAttributedString.Key: Any]
    
    public init() {
        self.attributes = [:]
    }
    
    public init(_ style: Style) {
        self.attributes = style.attributes
    }
    
    public init(_ attributes: [NSAttributedString.Key: Any]) {
        self.attributes = attributes
    }
    
    public func merged(with style: Style) -> Style {
        var attrs = attributes
    
        style.attributes.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return Style(attrs)
    }
    
    public func attribute(_ key: NSAttributedString.Key, _ value: Any) -> Style {
        var attrs = attributes
        attrs.updateValue(value, forKey: key)
        return Style(attrs)
    }
    
    public func paragraphStyle(_ value: NSParagraphStyle) -> Style {
        return attribute(.paragraphStyle, value)
    }
    
#if os(macOS)
    public func font(_ value: NSFont) -> Style {
        return attribute(.font, value)
    }
    
    public func foregroundColor(_ value: NSColor) -> Style {
        return attribute(.foregroundColor, value)
    }
    
    public func backgroundColor(_ value: NSColor) -> Style {
        return attribute(.backgroundColor, value)
    }
    
    public func strikethroughColor(_ value: NSColor) -> Style {
        return attribute(.strikethroughColor, value)
    }
    
    public func underlineColor(_ value: NSColor) -> Style {
        return attribute(.underlineColor, value)
    }
    
    public func strokeColor(_ value: NSColor) -> Style {
        return attribute(.strokeColor, value)
    }
#else
    public func font(_ value: UIFont) -> Style {
        return attribute(.font, value)
    }
    
    public func foregroundColor(_ value: UIColor) -> Style {
        return attribute(.foregroundColor, value)
    }
    
    public func backgroundColor(_ value: UIColor) -> Style {
        return attribute(.backgroundColor, value)
    }
    
    public func strikethroughColor(_ value: UIColor) -> Style {
        return attribute(.strikethroughColor, value)
    }
    
    public func underlineColor(_ value: UIColor) -> Style {
        return attribute(.underlineColor, value)
    }
    
    public func strokeColor(_ value: UIColor) -> Style {
        return attribute(.strokeColor, value)
    }
#endif
    
    public func ligature(_ value: Int) -> Style {
        return attribute(.ligature, value)
    }
    
    public func kern(_ value: Float) -> Style {
        return attribute(.kern, value)
    }
    
    public func strikethroughStyle(_ value: NSUnderlineStyle) -> Style {
        return attribute(.strikethroughStyle, value.rawValue)
    }
    
    public func underlineStyle(_ value: NSUnderlineStyle) -> Style {
        return attribute(.underlineStyle, value.rawValue)
    }
    
    public func strokeWidth(_ value: Float) -> Style {
        return attribute(.strokeWidth, value)
    }
    
    #if !os(watchOS)
    public func shadow(_ value: NSShadow) -> Style {
        return attribute(.shadow, value)
    }
    #endif
    
    public func textEffect(_ value: String) -> Style {
        return attribute(.textEffect, value)
    }
    
    #if !os(watchOS)
    public func attachment(_ value: NSTextAttachment) -> Style {
        return attribute(.attachment, value)
    }
    #endif
    
    public func link(_ value: URL) -> Style {
        return attribute(.link, value)
    }
    
    public func link(_ value: String) -> Style {
        return attribute(.link, value)
    }
    
    public func baselineOffset(_ value: Float) -> Style {
        return attribute(.baselineOffset, value)
    }
    
    public func obliqueness(_ value: Float) -> Style {
        return attribute(.obliqueness, value)
    }
    
    public func expansion(_ value: Float) -> Style {
        return attribute(.expansion, value)
    }
    
    public func writingDirection(_ value: NSWritingDirection) -> Style {
        return attribute(.writingDirection, value.rawValue)
    }
}
