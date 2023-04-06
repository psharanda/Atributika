//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif


public final class AttributesBuilder {
    
    public private(set) var attributes: [NSAttributedString.Key: Any]
    
    public init(_ attributes: [NSAttributedString.Key: Any] = [:]) {
        self.attributes = attributes
    }
    
    public func withAttribute(_ key: NSAttributedString.Key, _ value: Any) -> Self {
        attributes.updateValue(value, forKey: key)
        return self
    }
    
    public func withParagraphStyle(_ value: NSParagraphStyle) -> Self {
        return withAttribute(.paragraphStyle, value)
    }
    
#if os(macOS)
    public func withFont(_ value: NSFont) -> Self {
        return withAttribute(.font, value)
    }
    
    public func withForegroundColor(_ value: NSColor) -> Self {
        return withAttribute(.foregroundColor, value)
    }
    
    public func withBackgroundColor(_ value: NSColor) -> Self {
        return withAttribute(.backgroundColor, value)
    }
    
    public func withStrikethroughColor(_ value: NSColor) -> Self {
        return withAttribute(.strikethroughColor, value)
    }
    
    public func withUnderlineColor(_ value: NSColor) -> Self {
        return withAttribute(.underlineColor, value)
    }
    
    public func withStrokeColor(_ value: NSColor) -> Self {
        return withAttribute(.strokeColor, value)
    }
#else
    public func withFont(_ value: UIFont) -> Self {
        return withAttribute(.font, value)
    }
    
    public func withForegroundColor(_ value: UIColor) -> Self {
        return withAttribute(.foregroundColor, value)
    }
    
    public func withBackgroundColor(_ value: UIColor) -> Self {
        return withAttribute(.backgroundColor, value)
    }
    
    public func withStrikethroughColor(_ value: UIColor) -> Self {
        return withAttribute(.strikethroughColor, value)
    }
    
    public func withUnderlineColor(_ value: UIColor) -> Self {
        return withAttribute(.underlineColor, value)
    }
    
    public func withStrokeColor(_ value: UIColor) -> Self {
        return withAttribute(.strokeColor, value)
    }
#endif
    
    public func withLigature(_ value: Int) -> Self {
        return withAttribute(.ligature, value)
    }
    
    public func withKern(_ value: Float) -> Self {
        return withAttribute(.kern, value)
    }
    
    public func withStrikethroughStyle(_ value: NSUnderlineStyle) -> Self {
        return withAttribute(.strikethroughStyle, value.rawValue)
    }
    
    public func withUnderlineStyle(_ value: NSUnderlineStyle) -> Self {
        return withAttribute(.underlineStyle, value.rawValue)
    }
    
    public func withStrokeWidth(_ value: Float) -> Self {
        return withAttribute(.strokeWidth, value)
    }
    
    #if !os(watchOS)
    public func withShadow(_ value: NSShadow) -> Self {
        return withAttribute(.shadow, value)
    }
    #endif
    
    public func withTextEffect(_ value: String) -> Self {
        return withAttribute(.textEffect, value)
    }
    
    #if !os(watchOS)
    public func withAttachment(_ value: NSTextAttachment) -> Self {
        return withAttribute(.attachment, value)
    }
    #endif
    
    public func withLink(_ value: URL) -> Self {
        return withAttribute(.link, value)
    }
    
    public func withLink(_ value: String) -> Self {
        return withAttribute(.link, value)
    }
    
    public func withBaselineOffset(_ value: Float) -> Self {
        return withAttribute(.baselineOffset, value)
    }
    
    public func withObliqueness(_ value: Float) -> Self {
        return withAttribute(.obliqueness, value)
    }
    
    public func withExpansion(_ value: Float) -> Self {
        return withAttribute(.expansion, value)
    }
    
    public func withWritingDirection(_ value: NSWritingDirection) -> Self {
        return withAttribute(.writingDirection, value.rawValue)
    }
}
