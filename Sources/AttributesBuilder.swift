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

    public func attribute(_ key: NSAttributedString.Key, _ value: Any) -> Self {
        attributes.updateValue(value, forKey: key)
        return self
    }

    public func paragraphStyle(_ value: NSParagraphStyle) -> Self {
        return attribute(.paragraphStyle, value)
    }

    #if os(macOS)
        public func font(_ value: NSFont) -> Self {
            return attribute(.font, value)
        }

        public func foregroundColor(_ value: NSColor) -> Self {
            return attribute(.foregroundColor, value)
        }

        public func backgroundColor(_ value: NSColor) -> Self {
            return attribute(.backgroundColor, value)
        }

        public func strikethroughColor(_ value: NSColor) -> Self {
            return attribute(.strikethroughColor, value)
        }

        public func underlineColor(_ value: NSColor) -> Self {
            return attribute(.underlineColor, value)
        }

        public func strokeColor(_ value: NSColor) -> Self {
            return attribute(.strokeColor, value)
        }
    #else
        public func font(_ value: UIFont) -> Self {
            return attribute(.font, value)
        }

        public func foregroundColor(_ value: UIColor) -> Self {
            return attribute(.foregroundColor, value)
        }

        public func backgroundColor(_ value: UIColor) -> Self {
            return attribute(.backgroundColor, value)
        }

        public func strikethroughColor(_ value: UIColor) -> Self {
            return attribute(.strikethroughColor, value)
        }

        public func underlineColor(_ value: UIColor) -> Self {
            return attribute(.underlineColor, value)
        }

        public func strokeColor(_ value: UIColor) -> Self {
            return attribute(.strokeColor, value)
        }
    #endif

    public func ligature(_ value: Int) -> Self {
        return attribute(.ligature, value)
    }

    public func kern(_ value: Float) -> Self {
        return attribute(.kern, value)
    }

    public func strikethroughStyle(_ value: NSUnderlineStyle) -> Self {
        return attribute(.strikethroughStyle, value.rawValue)
    }

    public func underlineStyle(_ value: NSUnderlineStyle) -> Self {
        return attribute(.underlineStyle, value.rawValue)
    }

    public func strokeWidth(_ value: Float) -> Self {
        return attribute(.strokeWidth, value)
    }

    #if !os(watchOS)
        public func shadow(_ value: NSShadow) -> Self {
            return attribute(.shadow, value)
        }
    #endif

    public func textEffect(_ value: String) -> Self {
        return attribute(.textEffect, value)
    }

    #if !os(watchOS)
        public func attachment(_ value: NSTextAttachment) -> Self {
            return attribute(.attachment, value)
        }
    #endif

    public func link(_ value: URL) -> Self {
        return attribute(.link, value)
    }

    public func link(_ value: String) -> Self {
        return attribute(.link, value)
    }

    public func baselineOffset(_ value: Float) -> Self {
        return attribute(.baselineOffset, value)
    }

    public func obliqueness(_ value: Float) -> Self {
        return attribute(.obliqueness, value)
    }

    public func expansion(_ value: Float) -> Self {
        return attribute(.expansion, value)
    }

    public func writingDirection(_ value: NSWritingDirection) -> Self {
        return attribute(.writingDirection, value.rawValue)
    }
}
