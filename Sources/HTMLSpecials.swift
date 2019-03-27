// Credits to https://github.com/alexaubry/HTMLString

import Foundation

let HTMLSpecialMaxLength = 31

extension String {
    func unescapeAsNumber() -> String? {
        
        let isHexadecimal = hasPrefix("X") || hasPrefix("x")
        let radix = isHexadecimal ? 16 : 10
        
        let numberStartIndex = index(startIndex, offsetBy: isHexadecimal ? 1 : 0)
        let numberString = self[numberStartIndex ..< endIndex]
        
        guard let codePoint = UInt32(numberString, radix: radix),
            let scalar = UnicodeScalar(codePoint) else {
                return nil
        }
        
        return String(scalar)
    }
}

private final class BundleToken { }

func HTMLSpecial(for code: String) -> String? {
    if let res = popularHTMLSpecialsMap[code] {
        return res
    }
    
    if otherHTMLSpecialsMap == nil {
        let decoder = PropertyListDecoder()
        
        guard let url = Bundle(for: BundleToken.self).url(forResource: "html_specials", withExtension: "plist") else {
            fatalError()
        }
        
        do {
            let data = try Data(contentsOf: url)
            otherHTMLSpecialsMap = try decoder.decode([String: String].self, from: data)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    return otherHTMLSpecialsMap?[code]
}

private let popularHTMLSpecialsMap: [String : String] = [
    "gt":"\u{3e}",
    "lt":"\u{3c}",
    "amp":"\u{26}"
]

private var otherHTMLSpecialsMap: [String : String]?
