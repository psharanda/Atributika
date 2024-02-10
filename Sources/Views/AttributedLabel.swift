//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    @IBDesignable
    open class AttributedLabel: BaseAttributedTextView {
        private class UILabelBackend: TextViewBackend {
            private class TextEngine {
                let textContainer: NSTextContainer
                let layoutManager: NSLayoutManager
                let textStorage: NSTextStorage

                init() {
                    textContainer = NSTextContainer(size: .zero)
                    textContainer.lineFragmentPadding = 0

                    layoutManager = NSLayoutManager()
                    layoutManager.addTextContainer(textContainer)

                    textStorage = NSTextStorage()
                    textStorage.addLayoutManager(layoutManager)
                }
            }

            var preferredMaxLayoutWidth: CGFloat {
                set {
                    label.preferredMaxLayoutWidth = newValue
                }
                get {
                    return label.preferredMaxLayoutWidth
                }
            }

            var attributedText: NSAttributedString? {
                didSet {
                    label.attributedText = attributedText.flatMap {
                        let res = NSMutableAttributedString(attributedString: $0)
                        res.enumerateAttribute(.paragraphStyle, in: NSRange(location: 0, length: $0.length), options: []) { value, range, _ in
                            if let existingParagraphStyle = value as? NSParagraphStyle {
                                let newParagraphStyle = existingParagraphStyle.mutableCopy() as! NSMutableParagraphStyle
                                newParagraphStyle.lineBreakMode = lineBreakMode
                                res.addAttribute(.paragraphStyle, value: newParagraphStyle, range: range)
                            }
                        }
                        return res
                    }

                    if let attributedString = attributedText {
                        textEngine?.textStorage.setAttributedString(attributedString)
                    } else {
                        textEngine?.textStorage.setAttributedString(NSAttributedString())
                    }
                }
            }

            var numberOfLines: Int {
                set {
                    label.numberOfLines = newValue
                    textEngine?.textContainer.maximumNumberOfLines = newValue
                }
                get {
                    return label.numberOfLines
                }
            }

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
                    textEngine?.textContainer.lineBreakMode = newValue
                }
                get {
                    return label.lineBreakMode
                }
            }

            var view: UIView {
                return label
            }

            var textOrigin: CGPoint {
                ensureTextContainerSize()
                let rect = textEngine!.layoutManager.usedRect(for: textEngine!.textContainer)
                return CGPoint(x: 0, y: (label.frame.size.height - rect.size.height) / 2)
            }

            func enclosingRects(forGlyphRange glyphRange: NSRange) -> [CGRect] {
                ensureTextContainerSize()
                return textEngine!.layoutManager.enclosingRects(in: textEngine!.textContainer, forGlyphRange: glyphRange)
            }

            let label = UILabel()

            private var textEngine: TextEngine?

            private func ensureTextContainerSize() {
                createTextEngineIfNeeded()
                let newSize = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
                if textEngine!.textContainer.size != newSize {
                    textEngine!.textContainer.size = newSize
                }
            }

            private func createTextEngineIfNeeded() {
                if textEngine == nil {
                    let textEngine = TextEngine()
                    textEngine.textStorage.setAttributedString(attributedText ?? NSAttributedString())
                    textEngine.textContainer.maximumNumberOfLines = numberOfLines
                    textEngine.textContainer.lineBreakMode = lineBreakMode

                    self.textEngine = textEngine
                }
            }
        }

        override func makeBackend() -> TextViewBackend {
            return UILabelBackend()
        }
    }

#endif
