//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

public struct Tag: Equatable {
    public let name: String
    public let attributes: [String: String]

    public init(name: String, attributes: [String: String]) {
        self.name = name
        self.attributes = attributes
    }
}

public enum TagPart: Equatable {
    case opening(selfClosing: Bool)
    case closing
    case content(Substring)
}

public struct TagContext {
    public let tag: Tag
    public let outerTags: [Tag]
    public init(tag: Tag, outerTags: [Tag]) {
        self.tag = tag
        self.outerTags = outerTags
    }
}

public protocol TagTuning {
    func style(context: TagContext) -> AttributesProvider
    func transform(context: TagContext, part: TagPart) -> String?
}

public struct TagTuner: TagTuning {
    public func style(context: TagContext) -> AttributesProvider {
        return _style(context)
    }

    public func transform(context: TagContext, part: TagPart) -> String? {
        return _transform(context, part)
    }

    private let _style: (TagContext) -> AttributesProvider
    private let _transform: (TagContext, TagPart) -> String?

    public init(style: @escaping (TagContext) -> AttributesProvider, transform: @escaping (TagContext, TagPart) -> String?) {
        _style = style
        _transform = transform
    }

    public init(style: @escaping (TagContext) -> AttributesProvider) {
        _style = style
        _transform = { _, _ in nil }
    }

    public init(transform: @escaping (TagContext, TagPart) -> String?) {
        _style = { _ in [NSAttributedString.Key: Any]() }
        _transform = transform
    }

    public init(attributes: AttributesProvider = [NSAttributedString.Key: Any](),
                openingTagReplacement: String? = nil,
                closingTagReplacement: String? = nil,
                contentReplacement: String? = nil)
    {
        _style = { _ in attributes }
        _transform = { _, part in
            switch part {
            case .opening:
                return openingTagReplacement
            case .closing:
                return closingTagReplacement
            case .content:
                return contentReplacement
            }
        }
    }
}

extension Attrs: TagTuning {
    public func style(context _: TagContext) -> AttributesProvider {
        return self
    }

    public func transform(context _: TagContext, part _: TagPart) -> String? {
        return nil
    }
}

extension Dictionary: TagTuning where Key == NSAttributedString.Key, Value == Any {
    public func style(context _: TagContext) -> AttributesProvider {
        return self
    }

    public func transform(context _: TagContext, part _: TagPart) -> String? {
        return nil
    }
}
