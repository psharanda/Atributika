//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class AttributedStringBuilder {
    public let string: String
    public private(set) var baseAttributes: AttributesProvider

    public struct AttributesRangeInfo {
        public let attributes: AttributesProvider
        public let range: Range<String.Index>
        public let level: Int

        public init(attributes: AttributesProvider, range: Range<String.Index>, level: Int) {
            self.attributes = attributes
            self.range = range
            self.level = level
        }
    }

    private var currentMaxLevel: Int = 0

    public private(set) var attributesRangeInfo: [AttributesRangeInfo]

    public init(string: String, attributesRangeInfo: [AttributesRangeInfo], baseAttributes: AttributesProvider) {
        self.string = string
        self.attributesRangeInfo = attributesRangeInfo
        self.baseAttributes = baseAttributes
    }

    public convenience init(string: String, baseAttributes: AttributesProvider = [NSAttributedString.Key: Any]()) {
        self.init(string: string, attributesRangeInfo: [], baseAttributes: baseAttributes)
    }

    public convenience init(attributedString: NSAttributedString, baseAttributes: AttributesProvider = [NSAttributedString.Key: Any]()) {
        let string = attributedString.string
        var info: [AttributesRangeInfo] = []

        attributedString.enumerateAttributes(in: NSMakeRange(0, attributedString.length), options: []) { attributes, range, _ in
            if let range = Range(range, in: string) {
                info.append(AttributesRangeInfo(attributes: attributes, range: range, level: -1))
            }
        }

        self.init(string: string, attributesRangeInfo: info, baseAttributes: baseAttributes)
    }

    public convenience init(
        htmlString: String,
        baseAttributes: AttributesProvider = [NSAttributedString.Key: Any](),
        tags: [String: TagTuning] = [:]
    ) {
        let (string, tagsInfo) = htmlString.detectTags(tags: tags)
        var info: [AttributesRangeInfo] = []

        var newLevel = 0
        tagsInfo.forEach { t in
            newLevel = max(t.level, newLevel)
            if let style = tags[t.tag.name.lowercased()] {
                info.append(AttributesRangeInfo(attributes: style.style(context: TagContext(tag: t.tag, outerTags: t.outerTags)), range: t.range, level: t.level))
            }
        }

        self.init(string: string, attributesRangeInfo: info, baseAttributes: baseAttributes)
        currentMaxLevel = newLevel
    }

    public var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: baseAttributes.attributes)

        let info = attributesRangeInfo.sorted {
            $0.level < $1.level
        }

        for i in info {
            let attributes = i.attributes
            if attributes.attributes.count > 0 {
                attributedString.addAttributes(attributes.attributes, range: NSRange(i.range, in: string))
            }
        }

        return attributedString
    }

    public func styleBase(_ attributes: AttributesProvider) -> Self {
        baseAttributes = attributes
        return self
    }

    public func styleHashtags(_ attributes: DetectionTuning) -> Self {
        return style(ranges: string.detectHashtags(),
                     attributes: attributes)
    }

    public func styleMentions(_ attributes: DetectionTuning) -> Self {
        return style(ranges: string.detectMentions(),
                     attributes: attributes)
    }

    public func style(regex: String, options: NSRegularExpression.Options = [], attributes: DetectionTuning) -> Self {
        return style(ranges: string.detect(regex: regex, options: options),
                     attributes: attributes)
    }

    public func style(textCheckingTypes: NSTextCheckingResult.CheckingType, attributes: DetectionTuning) -> Self {
        return style(ranges: string.detect(textCheckingTypes: textCheckingTypes),
                     attributes: attributes)
    }

    public func stylePhoneNumbers(_ attributes: DetectionTuning) -> Self {
        return style(ranges: string.detectPhoneNumbers(),
                     attributes: attributes)
    }

    public func styleLinks(_ attributes: DetectionTuning) -> Self {
        return style(ranges: string.detectLinks(),
                     attributes: attributes)
    }

    public func style(range: Range<String.Index>, attributes: DetectionTuning) -> Self {
        return style(ranges: [range], attributes: attributes)
    }

    public func style(ranges: [Range<String.Index>], attributes: DetectionTuning) -> Self {
        currentMaxLevel += 1
        let info = ranges.map { range in
            let detectionContext = DetectionContext(
                range: range,
                text: String(string[range]),
                existingAttributes: attributesRangeInfo.compactMap {
                    $0.range.clamped(to: range) == range ? $0.attributes : nil
                }
            )

            return AttributesRangeInfo(
                attributes: attributes.style(context: detectionContext),
                range: range,
                level: currentMaxLevel
            )
        }

        attributesRangeInfo.append(contentsOf: info)
        return self
    }
}

public protocol HTMLSpecialsProvider {
    func stringForHTMLSpecial(_ htmlSpecial: String) -> String?
}

public struct DefaultHTMLSpecialsProvider: HTMLSpecialsProvider {
    public func stringForHTMLSpecial(_ htmlSpecial: String) -> String? {
        return HTMLSpecials[htmlSpecial].map { String($0) }
    }

    private let HTMLSpecials: [String: Character] = [
        "quot": "\u{22}",
        "amp": "\u{26}",
        "apos": "\u{27}",
        "lt": "\u{3C}",
        "gt": "\u{3E}",
        "nbsp": "\u{A0}",
    ]
}

public extension AttributedStringBuilder {
    static var htmlSpecialsProvider: HTMLSpecialsProvider = DefaultHTMLSpecialsProvider()
}
