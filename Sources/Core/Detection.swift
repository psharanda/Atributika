//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

public struct DetectionContext {
    public let range: Range<String.Index>
    public let text: String
    public let existingAttributes: [AttributesProvider]

    public func firstExistingAttributeValue(for key: NSAttributedString.Key) -> Any? {
        for a in existingAttributes {
            if let value = a.attributes[key] {
                return value
            }
        }
        return nil
    }
}

public protocol DetectionTuning {
    func style(context: DetectionContext) -> AttributesProvider
}

public struct DetectionTuner: DetectionTuning {
    public func style(context: DetectionContext) -> AttributesProvider {
        return _style(context)
    }

    private let _style: (DetectionContext) -> AttributesProvider

    public init(style: @escaping (DetectionContext) -> AttributesProvider) {
        _style = style
    }
}

extension Attrs: DetectionTuning {
    public func style(context _: DetectionContext) -> AttributesProvider {
        return self
    }
}

extension Dictionary: DetectionTuning where Key == NSAttributedString.Key, Value == Any {
    public func style(context _: DetectionContext) -> AttributesProvider {
        return self
    }
}
