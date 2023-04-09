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
    case start // includes self-closing tags like <img />
    case end
}

public struct TagStyler {
    public let style: ([String: String]) -> [NSAttributedString.Key: Any]
    public let transform: ([String: String], TagPosition) -> String?

    public init(style: @escaping ([String: String]) -> [NSAttributedString.Key: Any], transform: @escaping ([String: String], TagPosition) -> String? = { _, _ in nil }) {
        self.style = style
        self.transform = transform
    }

    public init(attributes: [NSAttributedString.Key: Any], transform: @escaping ([String: String], TagPosition) -> String? = { _, _ in nil }) {
        style = { _ in attributes }
        self.transform = transform
    }
}

public final class AttributedStringBuilder {
    private struct Detection {
        let attributes: [NSAttributedString.Key: Any]
        let range: Range<String.Index>
        let level: Int
    }

    public let string: String
    private var detections: [Detection]
    public private(set) var baseAttributes: [NSAttributedString.Key: Any]

    private var currentMaxLevel: Int = 0

    private init(string: String, detections: [Detection], baseAttributes: [NSAttributedString.Key: Any]) {
        self.string = string
        self.detections = detections
        self.baseAttributes = baseAttributes
    }

    public convenience init(string: String, baseAttributes: [NSAttributedString.Key: Any] = [:]) {
        self.init(string: string, detections: [], baseAttributes: baseAttributes)
    }

    public convenience init(attributedString: NSAttributedString, baseAttributes: [NSAttributedString.Key: Any] = [:]) {
        let string = attributedString.string
        var detections: [Detection] = []

        attributedString.enumerateAttributes(in: NSMakeRange(0, attributedString.length), options: []) { attributes, range, _ in
            if let range = Range(range, in: string) {
                detections.append(Detection(attributes: attributes, range: range, level: -1))
            }
        }

        self.init(string: string, detections: detections, baseAttributes: baseAttributes)
    }

    public convenience init(
        htmlString: String,
        baseAttributes: [NSAttributedString.Key: Any] = [:],
        tagStylers: [String: TagStyler] = [:]
    ) {
        let (string, tagsInfo) = htmlString.detectTags(tagStylers: tagStylers)
        var ds: [Detection] = []

        var newLevel = 0
        tagsInfo.forEach { t in
            newLevel = max(t.level, newLevel)
            if let style = tagStylers[t.tag.name] {
                ds.append(Detection(attributes: style.style(t.tag.attributes), range: t.range, level: t.level))
            }
        }

        self.init(string: string, detections: ds, baseAttributes: baseAttributes)
        currentMaxLevel = newLevel
    }

    public var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: baseAttributes)

        let sortedDetections = detections.sorted {
            $0.level < $1.level
        }

        for d in sortedDetections {
            let attributes = d.attributes
            if attributes.count > 0 {
                attributedString.addAttributes(attributes, range: NSRange(d.range, in: string))
            }
        }

        return attributedString
    }

    public func styleHashtags(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(regex: "#[^[:punct:][:space:]]+", attributes: attributes)
    }

    public func styleMentions(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(regex: "@[^[:punct:][:space:]]+", attributes: attributes)
    }

    public func style(regex: String, options: NSRegularExpression.Options = [], attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(ranges: string.detect(regex: regex, options: options),
                     attributes: attributes)
    }

    public func style(textCheckingTypes: NSTextCheckingResult.CheckingType, attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(ranges: string.detect(textCheckingTypes: textCheckingTypes),
                     attributes: attributes)
    }

    public func stylePhoneNumbers(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(ranges: string.detect(textCheckingTypes: [.phoneNumber]),
                     attributes: attributes)
    }

    public func styleLinks(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(ranges: string.detect(textCheckingTypes: [.link]),
                     attributes: attributes)
    }

    public func style(range: Range<String.Index>, attributes: [NSAttributedString.Key: Any]) -> Self {
        return style(ranges: [range], attributes: attributes)
    }

    public func style(ranges: [Range<String.Index>], attributes: [NSAttributedString.Key: Any]) -> Self {
        currentMaxLevel += 1
        let ds = ranges.map { range in
            Detection(attributes: attributes,
                      range: range,
                      level: currentMaxLevel)
        }

        detections.append(contentsOf: ds)
        return self
    }
}
