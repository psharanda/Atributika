//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public protocol AttributesProvider {
    var attributes: [NSAttributedString.Key: Any] { get }
}

extension Dictionary: AttributesProvider where Key == NSAttributedString.Key, Value == Any {
    public var attributes: [NSAttributedString.Key: Any] {
        return self
    }
}

public final class Attrs: AttributesProvider {
    public private(set) var attributes: [NSAttributedString.Key: Any]

    public init(_ attributes: AttributesProvider = [NSAttributedString.Key: Any]()) {
        self.attributes = attributes.attributes
    }

    public func copy() -> Attrs {
        return Attrs(attributes)
    }

    @discardableResult
    public func attribute(_ key: NSAttributedString.Key, _ value: Any) -> Self {
        attributes.updateValue(value, forKey: key)
        return self
    }

    @discardableResult
    public func paragraphStyle(_ value: NSParagraphStyle) -> Self {
        return attribute(.paragraphStyle, value)
    }

    #if os(macOS)
        @discardableResult
        public func font(_ value: NSFont) -> Self {
            return attribute(.font, value)
        }

        @discardableResult
        public func foregroundColor(_ value: NSColor) -> Self {
            return attribute(.foregroundColor, value)
        }

        @discardableResult
        public func backgroundColor(_ value: NSColor) -> Self {
            return attribute(.backgroundColor, value)
        }

        @discardableResult
        public func strikethroughColor(_ value: NSColor) -> Self {
            return attribute(.strikethroughColor, value)
        }

        @discardableResult
        public func underlineColor(_ value: NSColor) -> Self {
            return attribute(.underlineColor, value)
        }

        @discardableResult
        public func strokeColor(_ value: NSColor) -> Self {
            return attribute(.strokeColor, value)
        }
    #else
        @discardableResult
        public func font(_ value: UIFont) -> Self {
            return attribute(.font, value)
        }

        @discardableResult
        public func foregroundColor(_ value: UIColor) -> Self {
            return attribute(.foregroundColor, value)
        }

        @discardableResult
        public func backgroundColor(_ value: UIColor) -> Self {
            return attribute(.backgroundColor, value)
        }

        @discardableResult
        public func strikethroughColor(_ value: UIColor) -> Self {
            return attribute(.strikethroughColor, value)
        }

        @discardableResult
        public func underlineColor(_ value: UIColor) -> Self {
            return attribute(.underlineColor, value)
        }

        @discardableResult
        public func strokeColor(_ value: UIColor) -> Self {
            return attribute(.strokeColor, value)
        }
    #endif

    @discardableResult
    public func ligature(_ value: Int) -> Self {
        return attribute(.ligature, value)
    }

    @discardableResult
    public func kern(_ value: Float) -> Self {
        return attribute(.kern, value)
    }

    @discardableResult
    public func strikethroughStyle(_ value: NSUnderlineStyle) -> Self {
        return attribute(.strikethroughStyle, value.rawValue)
    }

    @discardableResult
    public func underlineStyle(_ value: NSUnderlineStyle) -> Self {
        return attribute(.underlineStyle, value.rawValue)
    }

    @discardableResult
    public func strokeWidth(_ value: Float) -> Self {
        return attribute(.strokeWidth, value)
    }

    #if !os(watchOS)
        @discardableResult
        public func shadow(_ value: NSShadow) -> Self {
            return attribute(.shadow, value)
        }
    #endif

    @discardableResult
    public func textEffect(_ value: String) -> Self {
        return attribute(.textEffect, value)
    }

    #if !os(watchOS)
        @discardableResult
        public func attachment(_ value: NSTextAttachment) -> Self {
            return attribute(.attachment, value)
        }
    #endif

    @discardableResult
    public func link(_ value: URL) -> Self {
        return attribute(.link, value)
    }

    @discardableResult
    public func link(_ value: String) -> Self {
        return attribute(.link, value)
    }

    @discardableResult
    public func akaLink(_ link: URL) -> Attrs {
        return attribute(NSAttributedString.Key("Atributika.Link"), link)
    }

    @discardableResult
    public func akaLink(_ link: String) -> Attrs {
        return attribute(NSAttributedString.Key("Atributika.Link"), link)
    }

    @discardableResult
    public func baselineOffset(_ value: Float) -> Self {
        return attribute(.baselineOffset, value)
    }

    @discardableResult
    public func obliqueness(_ value: Float) -> Self {
        return attribute(.obliqueness, value)
    }

    @discardableResult
    public func expansion(_ value: Float) -> Self {
        return attribute(.expansion, value)
    }

    @discardableResult
    public func writingDirection(_ value: NSWritingDirection) -> Self {
        return attribute(.writingDirection, value.rawValue)
    }
}
