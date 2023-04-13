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
                    textEngine.attributedString = newValue
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
                    textEngine.lineBreakMode = newValue
                }
                get {
                    return label.lineBreakMode
                }
            }

            var size: CGSize {
                set {
                    textEngine.size = newValue
                }
                get {
                    return textEngine.size
                }
            }

            var layoutManager: NSLayoutManager {
                return textEngine.layoutManager
            }

            var textContainer: NSTextContainer {
                return textEngine.textContainer
            }

            var view: UIView {
                return label
            }

            let textEngine = TextEngine()

            let label = UILabel()
        }

        override func makeBackend() -> TextViewBackend {
            return UILabelBackend()
        }
    }

#endif
