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

            var textOrigin: CGPoint {
                ensureTextContainerSize()
                let rect = layoutManager.usedRect(for: textContainer)
                return CGPoint(x: 0, y: (label.frame.size.height - rect.size.height) / 2)
            }

            var view: UIView {
                return label
            }

            func enclosingRects(forGlyphRange glyphRange: NSRange) -> [CGRect] {
                ensureTextContainerSize()
                return layoutManager.enclosingRects(in: textContainer, forGlyphRange: glyphRange)
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

            private func ensureTextContainerSize() {
                let newSize = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
                if textContainer.size != newSize {
                    textContainer.size = newSize
                }
            }
        }

        override func makeBackend() -> TextViewBackend {
            return UILabelBackend()
        }
    }

#endif
