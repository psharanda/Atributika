//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    @IBDesignable
    open class AttributedLabel: BaseAttributedTextView {
        private class UILabelBackend: TextViewBackend {
            var attributedText: NSAttributedString? {
                set {
                    label.attributedText = newValue

                    if let attributedString = newValue {
                        textStorage.setAttributedString(attributedString)
                    } else {
                        textStorage.setAttributedString(NSAttributedString())
                    }
                }
                get {
                    return label.attributedText
                }
            }

            var numberOfLines: Int {
                set {
                    label.numberOfLines = newValue
                    textContainer.maximumNumberOfLines = newValue
                }
                get {
                    return label.numberOfLines
                }
            }

            @available(iOS 10.0, *)
            var adjustsFontForContentSizeCategory: Bool {
                set {
                    label.adjustsFontForContentSizeCategory = newValue
                }
                get {
                    return label.adjustsFontForContentSizeCategory
                }
            }

            var lineBreakMode: NSLineBreakMode {
                set {
                    label.lineBreakMode = newValue
                    textContainer.lineBreakMode = newValue
                }
                get {
                    return label.lineBreakMode
                }
            }

            var size: CGSize {
                set {
                    textContainer.size = newValue
                }
                get {
                    return textContainer.size
                }
            }

            var textOrigin: CGPoint {
                let rect = layoutManager.usedRect(for: textContainer)
                return CGPoint(x: 0, y: (label.frame.size.height - rect.size.height) / 2)
            }

            var view: UIView {
                return label
            }

            func enumerateEnclosingRects(forGlyphRange glyphRange: NSRange, using block: @escaping (CGRect) -> Bool) {
                layoutManager.enumerateEnclosingRects(
                    forGlyphRange: glyphRange,
                    withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                    in: textContainer
                ) { rect, stop in
                    if block(rect) {
                        stop.pointee = true
                    }
                }
            }

            var usedRect: CGRect {
                return layoutManager.usedRect(for: textContainer)
            }

            let textContainer: NSTextContainer
            let layoutManager: NSLayoutManager
            let textStorage: NSTextStorage

            let label = UILabel()

            init() {
                textContainer = NSTextContainer(size: .zero)
                textContainer.lineFragmentPadding = 0

                layoutManager = NSLayoutManager()
                layoutManager.addTextContainer(textContainer)

                textStorage = NSTextStorage()
                textStorage.addLayoutManager(layoutManager)
            }
        }

        override func makeBackend() -> TextViewBackend {
            return UILabelBackend()
        }
    }

#endif
