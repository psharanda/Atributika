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

public enum TagPosition: Equatable {
    case start(selfClosing: Bool)
    case end
}

public struct TagTuningStyleInfo {
    public let tag: Tag
    public let outerTags: [Tag]
    public init(tag: Tag, outerTags: [Tag]) {
        self.tag = tag
        self.outerTags = outerTags
    }
}

public struct TagTuningTransformInfo {
    public let tag: Tag
    public let tagPosition: TagPosition
    public let outerTags: [Tag]
    public init(tag: Tag, tagPosition: TagPosition, outerTags: [Tag]) {
        self.tag = tag
        self.tagPosition = tagPosition
        self.outerTags = outerTags
    }
}

public protocol TagTuning {
    func style(info: TagTuningStyleInfo) -> AttributesProvider
    func transform(info: TagTuningTransformInfo) -> String?
}

public struct TagTuner: TagTuning {
    public func style(info: TagTuningStyleInfo) -> AttributesProvider {
        return _style(info)
    }

    public func transform(info: TagTuningTransformInfo) -> String? {
        return _transform(info)
    }

    private let _style: (TagTuningStyleInfo) -> AttributesProvider
    private let _transform: (TagTuningTransformInfo) -> String?

    public init(style: @escaping (TagTuningStyleInfo) -> AttributesProvider, transform: @escaping (TagTuningTransformInfo) -> String?) {
        _style = style
        _transform = transform
    }

    public init(style: @escaping (TagTuningStyleInfo) -> AttributesProvider) {
        _style = style
        _transform = { _ in nil }
    }

    public init(transform: @escaping (TagTuningTransformInfo) -> String?) {
        _style = { _ in [NSAttributedString.Key: Any]() }
        _transform = transform
    }

    public init(attributes: AttributesProvider = [NSAttributedString.Key: Any](), startReplacement: String? = nil, endReplacement: String? = nil) {
        _style = { _ in attributes }
        _transform = { info in
            switch info.tagPosition {
            case .start:
                return startReplacement
            case .end:
                return endReplacement
            }
        }
    }
}
