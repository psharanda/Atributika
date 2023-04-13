//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    @IBDesignable
    open class AttributedTextView: BaseAttributedTextView {
        private class UITextViewBackend: TextViewBackend {
            var attributedText: NSAttributedString? {
                set {
                    textView.attributedText = newValue
                }
                get {
                    return textView.attributedText
                }
            }

            var numberOfLines: Int {
                set {
                    textView.textContainer.maximumNumberOfLines = newValue
                }
                get {
                    return textView.textContainer.maximumNumberOfLines
                }
            }

            @available(iOS 10.0, *)
            var adjustsFontForContentSizeCategory: Bool {
                set {
                    textView.adjustsFontForContentSizeCategory = newValue
                }
                get {
                    return textView.adjustsFontForContentSizeCategory
                }
            }

            var lineBreakMode: NSLineBreakMode {
                set {
                    textView.textContainer.lineBreakMode = newValue
                }
                get {
                    return textView.textContainer.lineBreakMode
                }
            }

            var size: CGSize = .zero

            var layoutManager: NSLayoutManager {
                return textView.layoutManager
            }

            var textContainer: NSTextContainer {
                return textView.textContainer
            }

            var view: UIView {
                return textView
            }

            let textView: UITextView

            init() {
                textView = UITextView()
                textView.isUserInteractionEnabled = false
                textView.textContainer.lineFragmentPadding = 0
                textView.textContainerInset = .zero
                textView.isEditable = false
                textView.isScrollEnabled = false
                textView.isSelectable = false
                textView.backgroundColor = nil
            }
        }

        private var textView: UITextView!

        override func makeBackend() -> TextViewBackend {
            let backend = UITextViewBackend()
            textView = backend.textView
            return backend
        }

        @IBInspectable open var isSelectable: Bool {
            get {
                return textView.isSelectable && textView.isUserInteractionEnabled
            }
            set {
                textView.isSelectable = newValue
                textView.isUserInteractionEnabled = newValue || textView.isScrollEnabled
            }
        }

        @IBInspectable open var isScrollEnabled: Bool {
            get {
                return textView.isScrollEnabled && textView.isUserInteractionEnabled
            }
            set {
                textView.isScrollEnabled = newValue
                textView.isUserInteractionEnabled = newValue || textView.isSelectable
            }
        }

        @IBInspectable open var alwaysBounceVertical: Bool {
            get {
                return textView.alwaysBounceVertical
            }
            set {
                textView.alwaysBounceVertical = newValue
            }
        }

        @IBInspectable open var alwaysBounceHorizontal: Bool {
            get {
                return textView.alwaysBounceHorizontal
            }
            set {
                textView.alwaysBounceHorizontal = newValue
            }
        }

        @IBInspectable open var textContainerInset: UIEdgeInsets {
            get {
                return textView.textContainerInset
            }
            set {
                textView.textContainerInset = newValue
            }
        }
    }

#endif
