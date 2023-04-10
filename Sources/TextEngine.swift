//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit

class TextEngine {
    let textContainer: NSTextContainer
    let layoutManager: NSLayoutManager
    let textStorage: NSTextStorage

    var size: CGSize {
        get {
            return textContainer.size
        }
        set {
            if textContainer.size != newValue {
                textContainer.size = newValue
            }
        }
    }

    var lineBreakMode: NSLineBreakMode {
        get {
            return textContainer.lineBreakMode
        }
        set {
            if textContainer.lineBreakMode != newValue {
                textContainer.lineBreakMode = newValue
            }
        }
    }

    var maximumNumberOfLines: Int {
        get {
            return textContainer.maximumNumberOfLines
        }
        set {
            if textContainer.maximumNumberOfLines != newValue {
                textContainer.maximumNumberOfLines = newValue
            }
        }
    }

    var attributedString: NSAttributedString? {
        didSet {
            if let attributedString = attributedString {
                textStorage.setAttributedString(attributedString)
            } else {
                textStorage.setAttributedString(NSAttributedString())
            }
        }
    }

    init() {
        textContainer = NSTextContainer(size: .zero)
        textContainer.lineFragmentPadding = 0

        layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
    }
}
