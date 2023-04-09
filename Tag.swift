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

public protocol TagStyling {
    func style(tagAttributes: [String: String]) -> AttributesProvider
}

public protocol TagTransforming {
    func transform(tagAttributes: [String: String], tagPosition: TagPosition) -> String?
}

public typealias TagTuning = TagStyling & TagTransforming


public struct TagTuner: TagTuning {
    public func style(tagAttributes: [String : String]) -> AttributesProvider {
        return _style(tagAttributes)
    }
    
    public func transform(tagAttributes: [String : String], tagPosition: TagPosition) -> String? {
        return _transform(tagAttributes, tagPosition)
    }
    
    private let _style: ([String: String]) -> AttributesProvider
    private let _transform: ([String: String], TagPosition) -> String?

    public init(style: @escaping ([String: String]) -> AttributesProvider, transform: @escaping ([String: String], TagPosition) -> String?) {
        _style = style
        _transform = transform
    }

    public init(style: @escaping ([String: String]) -> AttributesProvider) {
        _style = style
        _transform = { _, _ in nil }
    }

    public init(transform: @escaping ([String: String], TagPosition) -> String?) {
        _style = { _ in [NSAttributedString.Key: Any]() }
        _transform = transform
    }

    public init(attributes: AttributesProvider, transform: @escaping ([String: String], TagPosition) -> String? = { _, _ in nil }) {
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



