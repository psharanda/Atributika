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

public enum StyleType {
    case normal
    case disabled
    case highlighted
}

public struct Style {
    
    public let name: String
    
    public var attributes: [String: Any] {
        return typedAttributes[.normal] ?? [:]
    }
    
    public var highlightedAttributes: [String: Any] {
        var attrs = attributes
        
        typedAttributes[.highlighted]?.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return attrs
    }
    
    public var disabledAttributes: [String: Any] {
        var attrs = attributes
        
        typedAttributes[.disabled]?.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return attrs
    }
    
    public let typedAttributes: [StyleType: [String: Any]]
    
    public init(_ name: String = "", _ attributes: [String: Any] = [:], _ type: StyleType = .normal) {
        self.name = name
        typedAttributes = [type: attributes]
    }
    
    public init(_ name: String = "", _ typedAttributes: [StyleType: [String: Any]] = [:]) {
        self.name = name
        self.typedAttributes = typedAttributes
    }
    
    public func merged(with style: Style) -> Style {
        var attrs = typedAttributes
    
        style.typedAttributes.forEach { type, attributes in
            attributes.forEach { key, value in
                attrs[type, default: [:]].updateValue(value, forKey: key)
            }
        }
        
        return Style(name, attrs)
    }
    
    public func font(_ value: Font, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.font(value, type))
    }
    
    public func paragraphStyle(_ value: NSParagraphStyle, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.paragraphStyle(value, type))
    }
    
    public func foregroundColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.foregroundColor(value, type))
    }
    
    public func backgroundColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.backgroundColor(value, type))
    }
    
    public func ligature(_ value: Int, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.ligature(value, type))
    }
    
    public func kern(_ value: Float, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.kern(value, type))
    }
    
    public func strikethroughStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.strikethroughStyle(value, type))
    }
    
    public func strikethroughColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.strikethroughColor(value, type))
    }
    
    public func underlineStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.underlineStyle(value, type))
    }
    
    func underlineColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.underlineColor(value, type))
    }
    
    public func strokeColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.strokeColor(value, type))
    }
    
    public func strokeWidth(_ value: Float, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.strokeWidth(value, type))
    }
    
    #if !os(watchOS)
    public func shadow(_ value: NSShadow, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.shadow(value, type))
    }
    #endif
    
    public func textEffect(_ value: String, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.textEffect(value, type))
    }
    
    #if !os(watchOS)
    public func attachment(_ value: NSTextAttachment, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.attachment(value, type))
    }
    #endif
    
    public func link(_ value: URL, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.link(value, type))
    }
    
    public func link(_ value: String, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.link(value, type))
    }
    
    public func baselineOffset(_ value: Float, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.baselineOffset(value, type))
    }
    
    public func obliqueness(_ value: Float, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.obliqueness(value, type))
    }
    
    public func expansion(_ value: Float, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.expansion(value, type))
    }
    
    public func writingDirection(_ value: NSWritingDirection, _ type: StyleType = .normal) -> Style {
        return merged(with: Style.writingDirection(value, type))
    }
    

    
    public static func font(_ value: Font, _ type: StyleType = .normal) -> Style {
        return Style("", [NSFontAttributeName: value], type)
    }
    
    public static func paragraphStyle(_ value: NSParagraphStyle, _ type: StyleType = .normal) -> Style {
        return Style("", [NSParagraphStyleAttributeName: value], type)
    }
    
    public static func foregroundColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return Style("", [NSForegroundColorAttributeName: value], type)
    }
    
    public static func backgroundColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return Style("", [NSBackgroundColorAttributeName: value], type)
    }
    
    public static func ligature(_ value: Int, _ type: StyleType = .normal) -> Style {
        return Style("", [NSLigatureAttributeName: value], type)
    }
    
    public static func kern(_ value: Float, _ type: StyleType = .normal) -> Style {
        return Style("", [NSKernAttributeName: value], type)
    }
    
    public static func strikethroughStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> Style {
        return Style("", [NSStrikethroughStyleAttributeName : value.rawValue], type)
    }
    
    public static func strikethroughColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return Style("", [NSStrikethroughColorAttributeName: value], type)
    }
    
    public static func underlineStyle(_ value: NSUnderlineStyle, _ type: StyleType = .normal) -> Style {
        return Style("", [NSUnderlineStyleAttributeName : value.rawValue], type)
    }
    
    public static func underlineColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return Style("", [NSUnderlineColorAttributeName: value], type)
    }
    
    public static func strokeColor(_ value: Color, _ type: StyleType = .normal) -> Style {
        return Style("", [NSStrokeColorAttributeName: value], type)
    }
    
    public static func strokeWidth(_ value: Float, _ type: StyleType = .normal) -> Style {
        return Style("", [NSStrokeWidthAttributeName: value], type)
    }
    
    #if !os(watchOS)
    public static func shadow(_ value: NSShadow, _ type: StyleType = .normal) -> Style {
        return Style("", [NSShadowAttributeName: value], type)
    }
    #endif
    
    public static func textEffect(_ value: String, _ type: StyleType = .normal) -> Style {
        return Style("", [NSTextEffectAttributeName: value], type)
    }
    
    #if !os(watchOS)
    public static func attachment(_ value: NSTextAttachment, _ type: StyleType = .normal) -> Style {
        return Style("", [NSAttachmentAttributeName: value], type)
    }
    #endif
    
    public static func link(_ value: URL, _ type: StyleType = .normal) -> Style {
        return Style("", [NSLinkAttributeName: value], type)
    }
    
    public static func link(_ value: String, _ type: StyleType = .normal) -> Style {
        return Style("", [NSLinkAttributeName: value], type)
    }
    
    public static func baselineOffset(_ value: Float, _ type: StyleType = .normal) -> Style {
        return Style("", [NSBaselineOffsetAttributeName: value], type)
    }
    
    public static func obliqueness(_ value: Float, _ type: StyleType = .normal) -> Style {
        return Style("", [NSObliquenessAttributeName: value], type)
    }
    
    public static func expansion(_ value: Float, _ type: StyleType = .normal) -> Style {
        return Style("", [NSExpansionAttributeName: value], type)
    }
    
    public static func writingDirection(_ value: NSWritingDirection, _ type: StyleType = .normal) -> Style {
        return Style("", [NSWritingDirectionAttributeName: value.rawValue], type)
    }
}
