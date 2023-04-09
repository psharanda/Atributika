//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

struct TagInfo: Equatable {
    let tag: Tag
    let range: Range<String.Index>
    let level: Int
}

extension String {
    
    private static let htmlControlChars = CharacterSet(charactersIn: "<&")
    
    private static let HTMLSpecials: [String: Character] = [
        "quot": "\u{22}",
        "amp": "\u{26}",
        "apos": "\u{27}",
        "lt": "\u{3C}",
        "gt": "\u{3E}",
    ]
    
    private static let allowedTagCharacters = CharacterSet(charactersIn: ".-_").union(CharacterSet.alphanumerics)
    
    private func parseTag(_ tagString: String, parseAttributes: Bool) -> Tag? {
        let tagScanner = Scanner(string: tagString)

        guard let tagName = tagScanner._scanCharacters(from: Self.allowedTagCharacters) else {
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

    private func parseSpecial(scanner: Scanner) -> String {
        var result = ""
        if scanner._scanString("#") != nil {
            if let potentialSpecial = scanner._scanCharacters(from: CharacterSet.alphanumerics) {
                if scanner._scanString(";") != nil {
                    result = potentialSpecial.unescapeAsNumber() ?? "&#\(potentialSpecial);"
                } else {
                    result = "&#\(potentialSpecial)"
                }
            } else {
                result = "&#"
            }
        } else {
            if let potentialSpecial = scanner._scanCharacters(from: CharacterSet.letters) {
                if scanner._scanString(";") != nil {
                    result = Self.HTMLSpecials[potentialSpecial].map { String($0) } ?? "&\(potentialSpecial);"
                } else {
                    result = "&\(potentialSpecial)"
                }
            } else {
                result = "&"
            }
        }
        return result
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

    func detectTags(
        tagStylers: [String: TagStyler] = [:]
    ) -> (string: String, tagsInfo: [TagInfo]) {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil
        var resultString = String()
        var tagsResult = [TagInfo]()
        var tagsStack = [(tag: Tag, startIndex: String.Index, level: Int)]()

        while !scanner.isAtEnd {
            if let textString = scanner._scanUpToCharacters(from: String.htmlControlChars) {
                resultString.append(textString)
            } else {
                if scanner._scanString("<") != nil {
                    if let nextChar = scanner.currentCharacter(), let nextUnicodeScalar = nextChar.unicodeScalars.first {
                        if Self.allowedTagCharacters.contains(nextUnicodeScalar) || (nextChar == "/") {
                            let tagType = scanner._scanString("/") == nil ? TagPosition.start : TagPosition.end
                            if let tagString = scanner._scanUpToString(">") {
                                if scanner._scanString(">") != nil {
                                    if let tag = parseTag(tagString, parseAttributes: tagType == .start) {
                                        let resultTextEndIndex = resultString.endIndex

                                        if let tagStyler = tagStylers[tag.name], let str = tagStyler.transform(tag.attributes, tagType) {
                                            resultString.append(str)
                                        } else if tag.name.lowercased() == "br" {
                                            resultString.append("\n")
                                        }

                                        let nextLevel = (tagsStack.last?.level ?? -1) + 1

                                        if tagString.last == "/" {
                                            tagsResult.append(
                                                TagInfo(
                                                    tag: tag,
                                                    range: resultTextEndIndex ..< resultTextEndIndex,
                                                    level: nextLevel
                                                ))
                                        } else if tagType == .start {
                                            tagsStack.append((tag, resultTextEndIndex, nextLevel))
                                        } else {
                                            for (index, tagInfo) in tagsStack.enumerated().reversed() {
                                                if tagInfo.tag.name == tag.name {
                                                    tagsResult.append(
                                                        TagInfo(
                                                            tag: tagInfo.tag,
                                                            range: tagInfo.startIndex ..< resultTextEndIndex,
                                                            level: tagInfo.level
                                                        ))
                                                    tagsStack.remove(at: index)
                                                    break
                                                }
                                            }
                                        }
                                    } else {
                                        resultString.append("<")
                                        if (tagType == .end) {
                                            resultString.append("/")
                                        }
                                        resultString.append(tagString)
                                        resultString.append(">")
                                    }
                                } else {
                                    resultString.append("<")
                                    if (tagType == .end) {
                                        resultString.append("/")
                                    }
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

        return (resultString, tagsResult)
    }
}
