//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation

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

public enum AtributikaConfig {
    public static var htmlSpecialsProvider: HTMLSpecialsProvider = DefaultHTMLSpecialsProvider()
}
