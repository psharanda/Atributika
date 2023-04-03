//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif


public class TextAttributesBuilder {
    
    public private(set) var attributes: [NSAttributedString.Key: Any]
    
    public init(_ attributes: [NSAttributedString.Key: Any] = [:]) {
        self.attributes = attributes
    }
    
    public func withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> TextAttributesBuilder {
        attributes.updateValue(value, forKey: key)
        return self
    }
    
    public func withParagraphStyle(_ value: NSParagraphStyle) -> TextAttributesBuilder {
        return withAttribute(.paragraphStyle, value)
    }
    
#if os(macOS)
    public func withFont(_ value: NSFont) -> TextAttributesBuilder {
        return withAttribute(.font, value)
    }
    
    public func withForegroundColor(_ value: NSColor) -> TextAttributesBuilder {
        return withAttribute(.foregroundColor, value)
    }
    
    public func withBackgroundColor(_ value: NSColor) -> TextAttributesBuilder {
        return withAttribute(.backgroundColor, value)
    }
    
    public func withStrikethroughColor(_ value: NSColor) -> TextAttributesBuilder {
        return withAttribute(.strikethroughColor, value)
    }
    
    public func withUnderlineColor(_ value: NSColor) -> TextAttributesBuilder {
        return withAttribute(.underlineColor, value)
    }
    
    public func withStrokeColor(_ value: NSColor) -> TextAttributesBuilder {
        return withAttribute(.strokeColor, value)
    }
#else
    public func withFont(_ value: UIFont) -> TextAttributesBuilder {
        return withAttribute(.font, value)
    }
    
    public func withForegroundColor(_ value: UIColor) -> TextAttributesBuilder {
        return withAttribute(.foregroundColor, value)
    }
    
    public func withBackgroundColor(_ value: UIColor) -> TextAttributesBuilder {
        return withAttribute(.backgroundColor, value)
    }
    
    public func withStrikethroughColor(_ value: UIColor) -> TextAttributesBuilder {
        return withAttribute(.strikethroughColor, value)
    }
    
    public func withUnderlineColor(_ value: UIColor) -> TextAttributesBuilder {
        return withAttribute(.underlineColor, value)
    }
    
    public func withStrokeColor(_ value: UIColor) -> TextAttributesBuilder {
        return withAttribute(.strokeColor, value)
    }
#endif
    
    public func withLigature(_ value: Int) -> TextAttributesBuilder {
        return withAttribute(.ligature, value)
    }
    
    public func withKern(_ value: Float) -> TextAttributesBuilder {
        return withAttribute(.kern, value)
    }
    
    public func withStrikethroughStyle(_ value: NSUnderlineStyle) -> TextAttributesBuilder {
        return withAttribute(.strikethroughStyle, value.rawValue)
    }
    
    public func withUnderlineStyle(_ value: NSUnderlineStyle) -> TextAttributesBuilder {
        return withAttribute(.underlineStyle, value.rawValue)
    }
    
    public func withStrokeWidth(_ value: Float) -> TextAttributesBuilder {
        return withAttribute(.strokeWidth, value)
    }
    
    #if !os(watchOS)
    public func withShadow(_ value: NSShadow) -> TextAttributesBuilder {
        return withAttribute(.shadow, value)
    }
    #endif
    
    public func withTextEffect(_ value: String) -> TextAttributesBuilder {
        return withAttribute(.textEffect, value)
    }
    
    #if !os(watchOS)
    public func withAttachment(_ value: NSTextAttachment) -> TextAttributesBuilder {
        return withAttribute(.attachment, value)
    }
    #endif
    
    public func withLink(_ value: URL) -> TextAttributesBuilder {
        return withAttribute(.link, value)
    }
    
    public func withLink(_ value: String) -> TextAttributesBuilder {
        return withAttribute(.link, value)
    }
    
    public func withBaselineOffset(_ value: Float) -> TextAttributesBuilder {
        return withAttribute(.baselineOffset, value)
    }
    
    public func withObliqueness(_ value: Float) -> TextAttributesBuilder {
        return withAttribute(.obliqueness, value)
    }
    
    public func withExpansion(_ value: Float) -> TextAttributesBuilder {
        return withAttribute(.expansion, value)
    }
    
    public func withWritingDirection(_ value: NSWritingDirection) -> TextAttributesBuilder {
        return withAttribute(.writingDirection, value.rawValue)
    }
}
