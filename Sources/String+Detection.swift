//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

extension String {
    func detect(regex: String, options: NSRegularExpression.Options = []) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()

        let dataDetector = try? NSRegularExpression(pattern: regex, options: options)
        dataDetector?.enumerateMatches(
            in: self, options: [], range: NSMakeRange(0, (self as NSString).length),
            using: { result, _, _ in
                if let r = result, let range = Range(r.range, in: self) {
                    ranges.append(range)
                }
            }
        )

        return ranges
    }

    func detect(textCheckingTypes: NSTextCheckingResult.CheckingType) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()

        let dataDetector = try? NSDataDetector(types: textCheckingTypes.rawValue)
        dataDetector?.enumerateMatches(
            in: self, options: [], range: NSMakeRange(0, (self as NSString).length),
            using: { result, _, _ in
                if let r = result, let range = Range(r.range, in: self) {
                    ranges.append(range)
                }
            }
        )
        return ranges
    }
}
