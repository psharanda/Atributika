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

public protocol TagTuning {
    func style(tag: Tag) -> AttributesProvider
    func transform(tag: Tag, position: TagPosition) -> String?
}

public struct TagTuner: TagTuning {
    public func style(tag: Tag) -> AttributesProvider {
        return _style(tag)
    }

    public func transform(tag: Tag, position: TagPosition) -> String? {
        return _transform(tag, position)
    }

    private let _style: (Tag) -> AttributesProvider
    private let _transform: (Tag, TagPosition) -> String?

    public init(style: @escaping (Tag) -> AttributesProvider, transform: @escaping (Tag, TagPosition) -> String?) {
        _style = style
        _transform = transform
    }

    public init(style: @escaping (Tag) -> AttributesProvider) {
        _style = style
        _transform = { _, _ in nil }
    }

    public init(transform: @escaping (Tag, TagPosition) -> String?) {
        _style = { _ in [NSAttributedString.Key: Any]() }
        _transform = transform
    }

    public init(attributes: AttributesProvider, transform: @escaping (Tag, TagPosition) -> String? = { _, _ in nil }) {
        _style = { _ in attributes }
        _transform = transform
    }

    public init(attributes: AttributesProvider = [NSAttributedString.Key: Any](), startReplacement: String? = nil, endReplacement: String? = nil) {
        _style = { _ in attributes }
        _transform = { _, position in
            switch position {
            case .start:
                return startReplacement
            case .end:
                return endReplacement
            }
        }
    }
}
