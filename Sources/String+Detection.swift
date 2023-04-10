//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

extension String {
    public func detect(regex: String, options: NSRegularExpression.Options = []) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()

        let dataDetector = try? NSRegularExpression(pattern: regex, options: options)
        dataDetector?.enumerateMatches(
            in: self, options: [], range: NSMakeRange(0, (self as NSString).length),
            using: { result, _, _ in
                if let r = result, let range = Range(r.range, in: self) {
                    
                    print("regex: \(self[range])")
                    ranges.append(range)
                }
            }
        )

        return ranges
    }
    
    public func detectHashtags() -> [Range<String.Index>] {
        return detect(regex: "#[^\\p{Pd}\\p{Ps}\\p{Pe}\\p{Pi}\\p{Pf}\\p{Po}\\p{Z}]+")
    }

    public func detectMentions() -> [Range<String.Index>] {
        return detect(regex: "@[^\\p{Pd}\\p{Ps}\\p{Pe}\\p{Pi}\\p{Pf}\\p{Po}\\p{Z}]+")
    }

    public func detect(textCheckingTypes: NSTextCheckingResult.CheckingType) -> [Range<String.Index>] {
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
    
    public func detectPhoneNumbers() -> [Range<String.Index>] {
        return detect(textCheckingTypes: [.phoneNumber])
    }

    public func detectLinks() -> [Range<String.Index>] {
        return detect(textCheckingTypes: [.link])
    }
}
