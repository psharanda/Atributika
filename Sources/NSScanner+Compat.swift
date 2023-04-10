//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

extension Scanner {
    func _scanCharacters(from set: CharacterSet) -> String? {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return scanCharacters(from: set)
        } else {
            var value: NSString? = ""
            if scanCharacters(from: set, into: &value) {
                return value as String?
            }
            return nil
        }
    }

    func _scanUpToCharacters(from set: CharacterSet) -> String? {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return scanUpToCharacters(from: set)
        } else {
            var value: NSString? = ""
            if scanUpToCharacters(from: set, into: &value) {
                return value as String?
            }
            return nil
        }
    }

    func _scanString(_ str: String) -> String? {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return scanString(str)
        } else {
            var value: NSString? = ""
            if scanString(str, into: &value) {
                return value as String?
            }
            return nil
        }
    }

    func _scanUpToString(_ str: String) -> String? {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return scanUpToString(str)
        } else {
            var value: NSString? = ""
            if scanUpTo(str, into: &value) {
                return value as String?
            }
            return nil
        }
    }

    func currentCharacter() -> Character? {
        guard !isAtEnd, let nextCharRange = Range(NSRange(location: scanLocation, length: 0), in: string) else {
            return nil
        }
        return string[nextCharRange.lowerBound]
    }

    func _scanCharacterPreiOS13() -> Character? {
        guard !isAtEnd, let nextCharRange = Range(NSRange(location: scanLocation, length: 0), in: string) else {
            return nil
        }
        let char = string[nextCharRange.lowerBound]
        let charRange = nextCharRange.lowerBound ..< string.index(after: nextCharRange.lowerBound)
        let nsRange = NSRange(charRange, in: string)
        scanLocation += nsRange.length

        return char
    }

    func _scanCharacter() -> Character? {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return scanCharacter()
        } else {
            return _scanCharacterPreiOS13()
        }
    }
}
