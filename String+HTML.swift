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
    // MARK: - html specials

    private static let HTMLSpecials: [String: Character] = [
        "quot": "\u{22}",
        "amp": "\u{26}",
        "apos": "\u{27}",
        "lt": "\u{3C}",
        "gt": "\u{3E}",
    ]

    private static let allowedTagCharacters = CharacterSet(charactersIn: ".-_").union(CharacterSet.alphanumerics)

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

    private func parseSpecial(_ scanner: Scanner, _ resultString: inout String) {
        if scanner._scanString("#") != nil {
            if let potentialSpecial = scanner._scanCharacters(from: CharacterSet.alphanumerics) {
                if scanner._scanString(";") != nil {
                    resultString.append(potentialSpecial.unescapeAsNumber() ?? "&#\(potentialSpecial);")
                } else {
                    resultString.append("&#\(potentialSpecial)")
                }
            } else {
                resultString.append("&#")
            }
        } else {
            if let potentialSpecial = scanner._scanCharacters(from: CharacterSet.letters) {
                if scanner._scanString(";") != nil {
                    resultString.append(Self.HTMLSpecials[potentialSpecial].map { String($0) } ?? "&\(potentialSpecial);")
                } else {
                    resultString.append("&\(potentialSpecial)")
                }
            } else {
                resultString.append("&")
            }
        }
    }

    // MARK: - tags

    private struct TagStackItem {
        let tag: Tag
        let startIndex: String.Index
        let level: Int
    }

    private func parseClosingTag(_ scanner: Scanner, _ tagsStack: inout [String.TagStackItem], _ tags: [String: TagTuning], _ resultString: inout String, _ tagsInfo: inout [TagInfo]) {
        _ = scanner._scanString("/")
        guard let tagName = scanner._scanCharacters(from: Self.allowedTagCharacters) else {
            resultString.append("</")
            return
        }

        for (index, tagInfo) in tagsStack.enumerated().reversed() {
            if tagInfo.tag.name == tagName {
                if let tagStyler = tags[tagName],
                   let str = tagStyler.transform(tagAttributes: tagInfo.tag.attributes, tagPosition: .end)
                {
                    resultString.append(str)
                }

                tagsInfo.append(
                    TagInfo(
                        tag: tagInfo.tag,
                        range: tagInfo.startIndex ..< resultString.endIndex,
                        level: tagInfo.level
                    ))
                tagsStack.remove(at: index)
                break
            }
        }
        if scanner._scanUpToString(">") == nil {
            _ = scanner._scanString(">")
        }
    }

    private func parseOpeningTag(_ scanner: Scanner, _ resultString: inout String, _ tags: [String: TagTuning], _ tagsStack: inout [String.TagStackItem], _ tagsInfo: inout [TagInfo]) {
        let tagName = scanner._scanCharacters(from: Self.allowedTagCharacters)!

        var selfClosing = false
        var attributes: [String: String] = [:]

        var paramName: String?
        var paramValue: String?

        while !scanner.isAtEnd {
            _ = scanner._scanCharacters(from: CharacterSet.whitespaces)

            guard let currentCharacter = scanner.currentCharacter() else {
                break
            }

            if scanner._scanString(">") != nil {
                break
            } else if scanner._scanString("/") != nil {
                selfClosing = true
            } else if scanner._scanString("=") != nil {
                _ = scanner._scanCharacters(from: CharacterSet.whitespaces)

                if let quote = scanner._scanString("\"") ?? scanner._scanString("'") {
                    if let scannedParamValue = scanner._scanUpToCharacters(from: CharacterSet(charactersIn: quote)) {
                        _ = scanner._scanCharacter()
                        paramValue = scannedParamValue
                    }
                } else {
                    paramValue = scanner._scanUpToCharacters(from: CharacterSet.whitespaces.union(CharacterSet(charactersIn: "/>")))
                }

                if paramValue != nil, paramValue!.contains("&") {
                    for (key, value) in Self.HTMLSpecials {
                        paramValue = paramValue!.replacingOccurrences(of: "&\(key);", with: String(value))
                    }
                }

                if let name = paramName, let value = paramValue {
                    attributes[name] = value
                    paramName = nil
                    paramValue = nil
                }
            } else if let firstUnicodeScalar = currentCharacter.unicodeScalars.first, Self.allowedTagCharacters.contains(firstUnicodeScalar) {
                if let prevParamName = paramName {
                    attributes[prevParamName] = ""
                    paramName = nil
                }
                paramName = scanner._scanCharacters(from: Self.allowedTagCharacters)!
            } else {
                _ = scanner._scanCharacter()
            }
        }

        if let name = paramName {
            attributes[name] = paramValue ?? ""
            paramName = nil
            paramValue = nil
        }

        let startIndex = resultString.endIndex

        if let tagStyler = tags[tagName],
           let str = tagStyler.transform(tagAttributes: attributes, tagPosition: .start(selfClosing: selfClosing))
        {
            resultString.append(str)
        } else if tagName.lowercased() == "br" {
            resultString.append("\n")
        }

        let nextLevel = (tagsStack.last?.level ?? -1) + 1

        let tag = Tag(name: tagName, attributes: attributes)
        if selfClosing {
            tagsInfo.append(
                TagInfo(
                    tag: tag,
                    range: startIndex ..< resultString.endIndex,
                    level: nextLevel
                ))
        } else {
            tagsStack.append(TagStackItem(tag: tag, startIndex: startIndex, level: nextLevel))
        }
    }

    private func parseTag(_ tags: [String: TagTuning], _ scanner: Scanner, _ resultString: inout String, _ tagsInfo: inout [TagInfo], _ tagsStack: inout [TagStackItem]) {
        guard let nextChar = scanner.currentCharacter(), let nextUnicodeScalar = nextChar.unicodeScalars.first else {
            resultString.append("<")
            return
        }
        if nextChar == "/" {
            parseClosingTag(scanner, &tagsStack, tags, &resultString, &tagsInfo)
        } else if CharacterSet.letters.contains(nextUnicodeScalar) {
            parseOpeningTag(scanner, &resultString, tags, &tagsStack, &tagsInfo)
        } else if scanner._scanString("!--") != nil {
            _ = scanner._scanUpToString("-->")
            _ = scanner._scanString("-->")
        } else {
            resultString.append("<")
        }
    }

    // MARK: - main

    private static let htmlControlChars = CharacterSet(charactersIn: "<&")

    func detectTags(tags: [String: TagTuning] = [:]) -> (string: String, tagsInfo: [TagInfo]) {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = nil

        var resultString = String()
        var tagsInfo = [TagInfo]()
        var tagsStack = [TagStackItem]()

        while !scanner.isAtEnd {
            if let textString = scanner._scanUpToCharacters(from: String.htmlControlChars) {
                resultString.append(textString)
            } else if scanner._scanString("<") != nil {
                parseTag(tags, scanner, &resultString, &tagsInfo, &tagsStack)
            } else if scanner._scanString("&") != nil {
                parseSpecial(scanner, &resultString)
            }
        }

        return (resultString, tagsInfo)
    }
}
