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

public struct GroupedStyle {
    public let styles: [Style]
    
    public var attributes: [AttributedStringKey: Any] {
        return typedAttributes[.normal] ?? [:]
    }
    
    public var highlightedAttributes: [AttributedStringKey: Any] {
        var attrs = attributes
        
        typedAttributes[.highlighted]?.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return attrs
    }
    
    public var disabledAttributes: [AttributedStringKey: Any] {
        var attrs = attributes
        
        typedAttributes[.disabled]?.forEach { key, value in
            attrs.updateValue(value, forKey: key)
        }
        
        return attrs
    }
    
    public let typedAttributes: [StyleType: [AttributedStringKey: Any]]
    
    public init(styles: [Style]) {
        self.styles = styles
        self.typedAttributes = .init()
    }
    
    public init(styles: [Style], _ attributes: [AttributedStringKey: Any], _ type: StyleType = .normal) {
        self.styles = styles
        self.typedAttributes = [type: attributes]
    }
    
    public init(styles: [Style], _ typedAttributes: [StyleType: [AttributedStringKey: Any]]) {
        self.styles = styles
        self.typedAttributes = typedAttributes
    }
    
    public func merged(with style: Style) -> GroupedStyle {
        var attrs = typedAttributes
        var styles = self.styles
        
        styles.append(style)
        style.typedAttributes.forEach { type, attributes in
            attributes.forEach { key, value in
                attrs[type, default: [:]].updateValue(value, forKey: key)
            }
        }
        
        return .init(styles: styles, typedAttributes)
    }
}

extension GroupedStyle {
    func marches(styleNames: [String]) -> Bool {
        return styleNames.map { $0.lowercased() }.sorted() == styles.map { $0.name.lowercased() }.sorted()
    }
    
    func fetchStyleWithAttribures() -> Style {
        return .init(styles.map { $0.name }.joined(separator: "-"), typedAttributes)
    }
}

extension GroupedStyle {
    static public func < (left: GroupedStyle, right: GroupedStyle) -> Bool {
        return left.styles.count < right.styles.count
    }
    
    static public func > (left: GroupedStyle, right: GroupedStyle) -> Bool {
        return left.styles.count > right.styles.count
    }
}
