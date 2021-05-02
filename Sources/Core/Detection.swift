//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

public struct Detection {
    public let range: Range<String.Index>
    public let text: String
}

public protocol DetectionTuning {
    func style(detection: Detection) -> AttributesProvider
}

public struct DetectionTuner: DetectionTuning {
    public func style(detection: Detection) -> AttributesProvider {
        return _style(detection)
    }

    private let _style: (Detection) -> AttributesProvider

    public init(style: @escaping (Detection) -> AttributesProvider) {
        _style = style
    }
}

extension Attrs: DetectionTuning {
    public func style(detection _: Detection) -> AttributesProvider {
        return self
    }
}

extension Dictionary: DetectionTuning where Key == NSAttributedString.Key, Value == Any {
    public func style(detection _: Detection) -> AttributesProvider {
        return self
    }
}
