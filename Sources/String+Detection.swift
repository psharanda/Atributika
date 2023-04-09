//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

import Foundation

public struct Tag: Equatable {
    public let name: String
    public let attributes: [String: String]
}

public struct TagInfo: Equatable {
    public let tag: Tag
    public let range: Range<String.Index>
    let level: Int
}

public enum TagType {
    case start // includes self-closing tags like <img />
    case end
}

public struct TagTransformer {
    public let tagName: String
    public let tagType: TagType
    public let transform: (Tag) -> String

    public init(tagName: String, tagType: TagType, replaceValue: String) {
        self.tagName = tagName
        self.tagType = tagType
        transform = { _ in replaceValue }
    }

    public init(tagName: String, tagType: TagType, transform: @escaping (Tag) -> String) {
        self.tagName = tagName
        self.tagType = tagType
        self.transform = transform
    }
}

extension String {
    private func parseTag(_ tagString: String, parseAttributes: Bool) -> Tag? {
        let tagScanner = Scanner(string: tagString)

        guard let tagName = tagScanner._scanCharacters(from: CharacterSet.alphanumerics) else {
            return nil
        }

        var attributes = [String: String]()

        while parseAttributes, !tagScanner.isAtEnd {
            guard let name = tagScanner._scanUpToString("=") else {
                break
            }

            guard tagScanner._scanString("=") != nil else {
                break
            }

            let startsFromSingleQuote = (tagScanner._scanString("'") != nil)
            if !startsFromSingleQuote {
                guard tagScanner._scanString("\"") != nil else {
                    break
                }
            }

            let quote = startsFromSingleQuote ? "'" : "\""

            let value = tagScanner._scanUpToString(quote) ?? ""

            guard tagScanner._scanString(quote) != nil else {
                break
            }

            if startsFromSingleQuote {
                attributes[name] = value.replacingOccurrences(of: "&apos;", with: "'")
            } else {
                attributes[name] = value.replacingOccurrences(of: "&quot;", with: "\"")
            }
        }

        return Tag(name: tagName, attributes: attributes)
    }

    private static let HTMLSpecials: [String: Character] = [
        "quot": "\u{22}",
        "amp": "\u{26}",
        "apos": "\u{27}",
        "lt": "\u{3C}",
        "gt": "\u{3E}",
    ]

    private func parseSpecial(scanner: Scanner) -> String {
        if scanner._scanString("#") != nil {
            if let potentialSpecial = scanner._scanCharacters(from: CharacterSet.alphanumerics) {
                if scanner._scanString(";") != nil {
                    return potentialSpecial.unescapeAsNumber() ?? "&#\(potentialSpecial);"
                } else {
                    return "&#\(potentialSpecial)"
                }
            } else {
                return "&#"
            }
        } else {
            if let potentialSpecial = scanner._scanCharacters(from: CharacterSet.letters) {
                if scanner._scanString(";") != nil {
                    return Self.HTMLSpecials[potentialSpecial].map { String($0) } ?? "&\(potentialSpecial);"
                } else {
                    return "&\(potentialSpecial)"
                }
            } else {
                return "&"
            }
        }
    }

    private func unescapeAsNumber() -> String? {
        let isHexadecimal = hasPrefix("X") || hasPrefix("x")
        let radix = isHexadecimal ? 16 : 10

        let numberStartIndex = index(startIndex, offsetBy: isHexadecimal ? 1 : 0)
        let numberString = String(self[numberStartIndex ..< endIndex])

        guard let codePoint = UInt32(numberString, radix: radix),
              let scalar = UnicodeScalar(codePoint)
        else {
            return nil
        }

        return String(scalar)
    }

    private static let htmlControlChars = CharacterSet(charactersIn: "<&")

    private struct TagInfoInternal {
        let tag: Tag
        let rangeStart: String.Index
        let rangeEnd: String.Index
        let level: Int
    }

    func detectTags(
        transformers: [TagTransformer] = []
    ) -> (string: String, tagsInfo: [TagInfo]) {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil
        var resultString = String()
        var tagsResult = [TagInfoInternal]()
        var tagsStack = [(tag: Tag, startIndex: String.Index, level: Int)]()

        while !scanner.isAtEnd {
            if let textString = scanner._scanUpToCharacters(from: String.htmlControlChars) {
                resultString.append(textString)
            } else {
                if scanner._scanString("<") != nil {
                    if let nextChar = scanner.currentCharacter() {
                        if CharacterSet.letters.contains(nextChar.unicodeScalars.first!) || (nextChar == "/") {
                            let tagType = scanner._scanString("/") == nil ? TagType.start : TagType.end
                            if let tagString = scanner._scanUpToString(">") {
                                if scanner._scanString(">") != nil {
                                    if let tag = parseTag(tagString, parseAttributes: tagType == .start) {
                                        let resultTextEndIndex = resultString.endIndex

                                        if let transformer = transformers.first(where: {
                                            $0.tagName == tag.name && $0.tagType == tagType
                                        }) {
                                            resultString.append(transformer.transform(tag))
                                        } else if tag.name.lowercased() == "br" {
                                            resultString.append("\n")
                                        }

                                        let nextLevel = (tagsStack.last?.level ?? -1) + 1

                                        if tagString.last == "/" {
                                            tagsResult.append(
                                                TagInfoInternal(
                                                    tag: tag,
                                                    rangeStart: resultTextEndIndex,
                                                    rangeEnd: resultTextEndIndex,
                                                    level: nextLevel
                                                ))
                                        } else if tagType == .start {
                                            tagsStack.append((tag, resultTextEndIndex, nextLevel))
                                        } else {
                                            for (index, tagInfo) in tagsStack.enumerated().reversed() {
                                                if tagInfo.tag.name == tag.name {
                                                    tagsResult.append(
                                                        TagInfoInternal(
                                                            tag: tagInfo.tag,
                                                            rangeStart: tagInfo.startIndex,
                                                            rangeEnd: resultTextEndIndex,
                                                            level: tagInfo.level
                                                        ))
                                                    tagsStack.remove(at: index)
                                                    break
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    resultString.append("<")
                                    resultString.append(tagString)
                                }
                            }
                        } else if scanner._scanString("!--") != nil {
                            _ = scanner._scanUpToString("-->")
                            _ = scanner._scanString("-->")
                        } else {
                            resultString.append("<")
                        }
                    } else {
                        resultString.append("<")
                    }
                } else if scanner._scanString("&") != nil {
                    resultString.append(parseSpecial(scanner: scanner))
                }
            }
        }

        return (
            resultString,
            tagsResult.map {
                TagInfo(
                    tag: $0.tag,
                    range: $0.rangeStart ..< $0.rangeEnd,
                    level: $0.level
                )
            }
        )
    }
}

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
