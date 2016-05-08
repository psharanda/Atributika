// NSScanner+Swift.swift
// A set of Swift-idiomatic methods for NSScanner
//
// (c) 2015 Nate Cook, licensed under the MIT license

import Foundation

extension NSScanner {
    
    // MARK: Strings
    
    /// Returns a string, scanned as long as characters from a given character set are encountered, or `nil` if none are found.
    func scanCharactersFromSet(set: NSCharacterSet) -> String? {
        var value: NSString? = ""
        if scanCharactersFromSet(set, intoString: &value),
            let value = value as? String {
                return value
        }
        return nil
    }
    
    /// Returns a string, scanned until a character from a given character set are encountered, or the remainder of the scanner's string. Returns `nil` if the scanner is already `atEnd`.
    func scanUpToCharactersFromSet(set: NSCharacterSet) -> String? {
        var value: NSString? = ""
        if scanUpToCharactersFromSet(set, intoString: &value),
            let value = value as? String {
                return value
        }
        return nil
    }
    
    /// Returns the given string if scanned, or `nil` if not found.
    func scanString(str: String) -> String? {
        var value: NSString? = ""
        if scanString(str, intoString: &value),
            let value = value as? String {
                return value
        }
        return nil
    }
    
    /// Returns a string, scanned until the given string is found, or the remainder of the scanner's string. Returns `nil` if the scanner is already `atEnd`.
    func scanUpToString(str: String) -> String? {
        var value: NSString? = ""
        if scanUpToString(str, intoString: &value),
            let value = value as? String {
                return value
        }
        return nil
    }
    
    // MARK: Numbers
    
    /// Returns a Double if scanned, or `nil` if not found.
    func scanDouble() -> Double? {
        var value = 0.0
        if scanDouble(&value) {
            return value
        }
        return nil
    }
    
    /// Returns a Float if scanned, or `nil` if not found.
    func scanFloat() -> Float? {
        var value: Float = 0.0
        if scanFloat(&value) {
            return value
        }
        return nil
    }
    
    /// Returns an Int if scanned, or `nil` if not found.
    func scanInteger() -> Int? {
        var value = 0
        if scanInteger(&value) {
            return value
        }
        return nil
    }
    
    /// Returns an Int32 if scanned, or `nil` if not found.
    func scanInt() -> Int32? {
        var value: Int32 = 0
        if scanInt(&value) {
            return value
        }
        return nil
    }
    
    /// Returns an Int64 if scanned, or `nil` if not found.
    func scanLongLong() -> Int64? {
        var value: Int64 = 0
        if scanLongLong(&value) {
            return value
        }
        return nil
    }
    
    /// Returns a UInt64 if scanned, or `nil` if not found.
    func scanUnsignedLongLong() -> UInt64? {
        var value: UInt64 = 0
        if scanUnsignedLongLong(&value) {
            return value
        }
        return nil
    }
    
    /// Returns an NSDecimal if scanned, or `nil` if not found.
    func scanDecimal() -> NSDecimal? {
        var value = NSDecimal()
        if scanDecimal(&value) {
            return value
        }
        return nil
    }
    
    // MARK: Hex Numbers
    
    /// Returns a Double if scanned in hexadecimal, or `nil` if not found.
    func scanHexDouble() -> Double? {
        var value = 0.0
        if scanHexDouble(&value) {
            return value
        }
        return nil
    }
    
    /// Returns a Float if scanned in hexadecimal, or `nil` if not found.
    func scanHexFloat() -> Float? {
        var value: Float = 0.0
        if scanHexFloat(&value) {
            return value
        }
        return nil
    }
    
    /// Returns a UInt32 if scanned in hexadecimal, or `nil` if not found.
    func scanHexInt() -> UInt32? {
        var value: UInt32 = 0
        if scanHexInt(&value) {
            return value
        }
        return nil
    }
    
    /// Returns a UInt64 if scanned in hexadecimal, or `nil` if not found.
    func scanHexLongLong() -> UInt64? {
        var value: UInt64 = 0
        if scanHexLongLong(&value) {
            return value
        }
        return nil
    }
}
