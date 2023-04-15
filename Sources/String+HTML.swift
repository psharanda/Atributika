//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

public struct TagInfo: Equatable {
    public let tag: Tag
    public let range: Range<String.Index>
    let level: Int
}

extension String {
    // MARK: - html specials

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
                    resultString.append(AtributikaConfig.htmlSpecialsProvider.stringForHTMLSpecial(potentialSpecial) ?? "&\(potentialSpecial);")
                } else {
                    resultString.append("&\(potentialSpecial)")
                }
            } else {
                resultString.append("&")
            }
        }
    }

    // MARK: - tags
    
    private enum StoredStringIndex {
        case index(String.Index)
        case offset(Int)
    }

    private struct TagStackItem {
        let tag: Tag
        
        let startIndex: StoredStringIndex
        let endIndex: String.Index
        let level: Int
        
        func startIndex(in string: String) -> String.Index {
            switch startIndex {
            case .index(let index):
                return index
            case .offset(let offset):
                return string.index(string.startIndex, offsetBy: offset)
            }
        }
    }

    private func parseClosingTag(_ scanner: Scanner, _ tagsStack: inout [String.TagStackItem], _ tags: [String: TagTuning], _ resultString: inout String, _ tagsInfo: inout [TagInfo]) {
        _ = scanner._scanString("/")
        guard let tagName = scanner._scanCharacters(from: Self.allowedTagCharacters) else {
            resultString.append("</")
            return
        }

        for (index, tagStackItem) in tagsStack.enumerated().reversed() {
            if tagStackItem.tag.name == tagName {
                if let tagStyler = tags[tagName],
                   let str = tagStyler.transform(tag: tagStackItem.tag, position: .end)
                {
                    resultString.append(str)
                }
                
                //print(resultString[resultString.index(before: resultString.index(before: tagStackItem.startIndex(in: resultString)))])

                tagsInfo.append(
                    TagInfo(
                        tag: tagStackItem.tag,
                        range: tagStackItem.startIndex(in: resultString) ..< resultString.endIndex,
                        level: tagStackItem.level
                    ))
                tagsStack.remove(at: index)
                break
            }
        }
        _ = scanner._scanUpToString(">")
        _ = scanner._scanString(">")
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
                        _ = scanner._scanString(quote)
                        paramValue = scannedParamValue
                    }
                } else {
                    paramValue = scanner._scanUpToCharacters(from: CharacterSet.whitespaces.union(CharacterSet(charactersIn: "/>")))
                }

                if let val = paramValue {
                    let valScanner = Scanner(string: val)
                    var newVal = ""

                    while !valScanner.isAtEnd {
                        if let str = valScanner._scanUpToString("&") {
                            newVal.append(str)
                        }

                        if valScanner._scanString("&") != nil {
                            parseSpecial(valScanner, &newVal)
                        }
                    }

                    paramValue = newVal
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

        let tag = Tag(name: tagName, attributes: attributes)

        if let tagStyler = tags[tagName],
           let str = tagStyler.transform(tag: tag, position: .start(selfClosing: selfClosing))
        {
            resultString.append(str)
        } else if tagName.lowercased() == "br" {
            resultString.append("\n")
        }

        let nextLevel = (tagsStack.last?.level ?? -1) + 1

        if selfClosing {
            tagsInfo.append(
                TagInfo(
                    tag: tag,
                    range: startIndex ..< resultString.endIndex,
                    level: nextLevel
                ))
        } else {
            
            let storedStartIndex: StoredStringIndex
            if #available(iOS 13.0, *) {
                storedStartIndex = .index(startIndex)
            } else {
                storedStartIndex = .offset(resultString.distance(from: resultString.startIndex, to: startIndex))
            }
            
            tagsStack.append(TagStackItem(
                tag: tag,
                startIndex: storedStartIndex,
                endIndex: resultString.endIndex, level: nextLevel
            ))
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

    public func detectTags(tags: [String: TagTuning] = [:]) -> (string: String, tagsInfo: [TagInfo]) {
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

        for tagStackItem in tagsStack {
            tagsInfo.append(
                TagInfo(
                    tag: tagStackItem.tag,
                    range: tagStackItem.startIndex(in: resultString) ..< tagStackItem.endIndex,
                    level: tagStackItem.level
                ))
        }

        return (resultString, tagsInfo)
    }
}
