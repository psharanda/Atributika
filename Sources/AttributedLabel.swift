//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    @IBDesignable open class AttributedLabel: UIControl {
        // MARK: - private properties

        private let textView = UITextView()

        // MARK: - links

        open var onLinkTouchUpInside: ((AttributedLabel, Any) -> Void)?

        open func rects(for range: Range<String.Index>) -> [CGRect] {
            var result = [CGRect]()

            if let attributedText = internalState.attributedText {
                let nsrange = NSRange(range, in: attributedText.string)
                textView.layoutManager.enumerateEnclosingRects(
                    forGlyphRange: nsrange,
                    withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                    in: textView.textContainer,
                    using: { rect, _ in
                        result.append(rect)
                    }
                )
            }

            return result
        }

        open var highlightedLinkValue: Any? {
            if let range = internalState.highlightedLinkRange,
               let val = internalState.attributedText?.attribute(.attributedLabelLink, at: range.location, effectiveRange: nil)
            {
                return val
            } else {
                return nil
            }
        }

        open var highlightedLinkRange: Range<String.Index>? {
            if let str = internalState.attributedText?.string, let range = internalState.highlightedLinkRange {
                return Range(range, in: str)
            } else {
                return nil
            }
        }

        // MARK: - public properties

        @IBInspectable override open var isEnabled: Bool {
            set {
                internalState.isEnabled = newValue
            }
            get {
                return internalState.isEnabled
            }
        }

        @IBInspectable open var isSelectable: Bool {
            get {
                return textView.isSelectable
            }
            set {
                textView.isSelectable = newValue
            }
        }

        @IBInspectable open var attributedText: NSAttributedString? {
            set {
                internalState = State(attributedText: newValue, isEnabled: internalState.isEnabled)
            }
            get {
                return internalState.attributedText
            }
        }

        open var highlightedLinkAttributes: AttributesProvider? {
            didSet {
                updateText()
            }
        }

        open var disabledLinkAttributes: AttributesProvider? {
            didSet {
                updateText()
            }
        }

        @IBInspectable open var numberOfLines: Int {
            set { textView.textContainer.maximumNumberOfLines = newValue }
            get { return textView.textContainer.maximumNumberOfLines }
        }

        @IBInspectable open var lineBreakMode: NSLineBreakMode {
            set { textView.textContainer.lineBreakMode = newValue }
            get { return textView.textContainer.lineBreakMode }
        }

        @available(iOS 10.0, *)
        @IBInspectable open var adjustsFontForContentSizeCategory: Bool {
            set { textView.adjustsFontForContentSizeCategory = newValue }
            get { return textView.adjustsFontForContentSizeCategory }
        }

        @IBInspectable open var font: UIFont = .preferredFont(forTextStyle: .body) {
            didSet {
                updateText()
            }
        }

        @IBInspectable open var textAlignment: NSTextAlignment = .natural {
            didSet {
                updateText()
            }
        }

        @IBInspectable open var textColor: UIColor = {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }() {
            didSet {
                updateText()
            }
        }

        @IBInspectable open var shadowColor: UIColor? {
            didSet {
                updateText()
            }
        }

        @IBInspectable open var shadowOffset = CGSize(width: 0, height: -1) {
            didSet {
                updateText()
            }
        }

        @IBInspectable open var shadowBlurRadius: CGFloat = 0 {
            didSet {
                updateText()
            }
        }

        // MARK: - init

        override public init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }

        private func commonInit() {
            isAccessibilityElement = false

            addSubview(textView)

            lineBreakMode = .byTruncatingTail
            numberOfLines = 1

            textView.isUserInteractionEnabled = false
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = .zero
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.isSelectable = false
            textView.backgroundColor = nil

            textView.translatesAutoresizingMaskIntoConstraints = false

            textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }

        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            return textView.sizeThatFits(size)
        }

        override open var forFirstBaselineLayout: UIView {
            return textView
        }

        override open var forLastBaselineLayout: UIView {
            return textView
        }

        struct Detection {
            let range: NSRange
        }

        private var trackedLinkRange: NSRange?

        override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            let pt = touch.location(in: self)
            if super.beginTracking(touch, with: event) {
                trackedLinkRange = linkRange(at: pt)
                if trackedLinkRange != nil {
                    internalState.highlightedLinkRange = trackedLinkRange
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }

        override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            let pt = touch.location(in: self)
            if let currentDetection = linkRange(at: pt) {
                if currentDetection == trackedLinkRange {
                    if internalState.highlightedLinkRange != trackedLinkRange {
                        internalState.highlightedLinkRange = trackedLinkRange
                    }
                } else {
                    if internalState.highlightedLinkRange != nil {
                        internalState.highlightedLinkRange = nil
                    }
                }
            } else {
                internalState.highlightedLinkRange = nil
            }
            return super.continueTracking(touch, with: event)
        }

        override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
            super.endTracking(touch, with: event)
            trackedLinkRange = nil
        }
        
        
        open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            if let val = highlightedLinkValue {
                onLinkTouchUpInside?(self, val)
            }
            
            super.touchesEnded(touches, with: event)

            internalState.highlightedLinkRange = nil
        }
        

        override open func cancelTracking(with event: UIEvent?) {
            super.cancelTracking(with: event)
            trackedLinkRange = nil
            internalState.highlightedLinkRange = nil
        }

        override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let superResult = super.hitTest(point, with: event)
            if isTracking {
                return superResult
            }

            if linkRange(at: point) != nil {
                return superResult
            }

            return nil
        }

        private func linkRange(at point: CGPoint) -> NSRange? {
            var result: NSRange?

            if let attributedText = internalState.attributedText {
                attributedText.enumerateAttribute(
                    .attributedLabelLink,
                    in: NSRange(location: 0, length: attributedText.length)
                ) { val, range, stop in

                    guard val != nil else {
                        return
                    }
                    textView.layoutManager.enumerateEnclosingRects(
                        forGlyphRange: range,
                        withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                        in: textView.textContainer, using: { rect, innerStop in
                            if rect.contains(point) {
                                innerStop.pointee = true
                                result = range
                            }
                        }
                    )
                    if result != nil {
                        stop.pointee = true
                    }
                }
            }

            return result
        }

        override open func layoutSubviews() {
            super.layoutSubviews()
            // accessibleElements = nil
        }

        // MARK: - state

        private struct State {
            var attributedText: NSAttributedString?
            var isEnabled: Bool
            var highlightedLinkRange: NSRange?
        }

        private var internalState: State = .init(attributedText: nil, isEnabled: true, highlightedLinkRange: nil) {
            didSet {
                updateText()
            }
        }

        private func updateAttributedTextInTextView(_ string: NSAttributedString) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment

            var inheritedAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: textColor,
            ]

            if let shadowColor = shadowColor {
                let shadow = NSShadow()
                shadow.shadowColor = shadowColor
                shadow.shadowOffset = shadowOffset
                shadow.shadowBlurRadius = shadowBlurRadius
                inheritedAttributes[.shadow] = shadow
            }

            let length = string.length
            let result = NSMutableAttributedString(string: string.string, attributes: inheritedAttributes)

            result.beginEditing()

            string.enumerateAttributes(in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { attributes, range, _ in
                result.addAttributes(attributes, range: range)

                if attributes[.attributedLabelLink] != nil {
                    if !internalState.isEnabled, let attrs = disabledLinkAttributes {
                        result.addAttributes(attrs.attributes, range: range)
                    }
                }
            })

            if let range = internalState.highlightedLinkRange, let attrs = highlightedLinkAttributes {
                result.addAttributes(attrs.attributes, range: range)
            }

            result.endEditing()

            if #available(iOS 10.0, *) {
                let shouldAdjustsFontForContentSizeCategory = textView.adjustsFontForContentSizeCategory

                if shouldAdjustsFontForContentSizeCategory {
                    textView.adjustsFontForContentSizeCategory = false
                }

                textView.attributedText = result

                if shouldAdjustsFontForContentSizeCategory {
                    textView.adjustsFontForContentSizeCategory = true
                }
            } else {
                textView.attributedText = string
            }
        }

        private func updateText() {
            if let attributedText = internalState.attributedText {
                updateAttributedTextInTextView(attributedText)
            } else {
                textView.attributedText = nil
            }
        }
//
//    //MARK: - Accessibitilty
        ////
        ////    private class AccessibilityElement: UIAccessibilityElement {
        ////        private weak var view: UIView?
        ////        private let enclosingRects: [CGRect]
        ////        private let usePath: Bool
        ////
        ////        init(container: Any, view: UIView, enclosingRects: [CGRect], usePath: Bool) {
        ////            self.view = view
        ////            self.enclosingRects = enclosingRects
        ////            self.usePath = usePath
        ////            super.init(accessibilityContainer: container)
        ////        }
        ////
        ////        override var accessibilityActivationPoint: CGPoint {
        ////            get {
        ////                guard let view = view  else {
        ////                    return .zero
        ////                }
        ////
        ////                if enclosingRects.count == 0 {
        ////                    return .zero
        ////                } else {
        ////                    let rect = UIAccessibilityConvertFrameToScreenCoordinates(enclosingRects[0], view)
        ////                    return CGPoint(x: rect.midX, y: rect.midY)
        ////                }
        ////            }
        ////            set {
        ////            }
        ////        }
        ////
        ////        override var accessibilityFrame: CGRect {
        ////            get {
        ////                guard let view = view  else {
        ////                    return .null
        ////                }
        ////
        ////                if enclosingRects.count == 0 {
        ////                    return .null
        ////                }
        ////
        ////                if enclosingRects.count == 1 {
        ////                    return UIAccessibilityConvertFrameToScreenCoordinates(enclosingRects[0], view)
        ////                }
        ////
        ////                var resultRect = enclosingRects[0]
        ////
        ////                for i in 1..<enclosingRects.count {
        ////                    resultRect = resultRect.union(enclosingRects[i])
        ////                }
        ////
        ////                return UIAccessibilityConvertFrameToScreenCoordinates(resultRect, view)
        ////            }
        ////            set {}
        ////        }
        ////
        ////        override var accessibilityPath: UIBezierPath? {
        ////            get {
        ////                if !usePath {
        ////                    return nil
        ////                }
        ////                guard let view = view  else {
        ////                    return nil
        ////                }
        ////
        ////                let path = UIBezierPath()
        ////
        ////                enclosingRects.forEach { rect in
        ////                    path.append(UIBezierPath(rect: rect))
        ////                }
        ////
        ////                return UIAccessibilityConvertPathToScreenCoordinates(path, view)
        ////            }
        ////            set {}
        ////        }
        ////    }
        ////
        ////    private var accessibleElements: [Any]?
        ////
        ////    open override var accessibilityElements: [Any]? {
        ////        get {
        ////            if (accessibleElements == nil) {
        ////                accessibleElements = []
        ////
        ////                if let attributedText = internalState.attributedText {
        ////
        ////                    let text = AccessibilityElement(container: self, view: self, enclosingRects: [textView.frame], usePath: false)
        ////                    text.accessibilityLabel = attributedText.string
        ////                    text.accessibilityTraits = UIAccessibilityTraitStaticText
        ////                    accessibleElements?.append(text)
        ////
        ////                    for detection in highlightableDetections {
        ////                        let nsrange = NSRange(detection.range, in: attributedText.string)
        ////                        var enclosingRects = [CGRect]()
        ////                        textView.layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange,
        ////                                                                       withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
        ////                                                                       in: textView.textContainer, using: { (rect, stop) in
        ////                            enclosingRects.append(rect)
        ////                        })
        ////
        ////                        let element = AccessibilityElement(container: self, view: self, enclosingRects: enclosingRects, usePath: true)
        ////                        element.isAccessibilityElement = false
        ////
        ////                        let innerElement = AccessibilityElement(container: element, view: self, enclosingRects: enclosingRects, usePath: false)
        ////                        innerElement.accessibilityLabel = String(attributedText.string[detection.range])
        ////                        innerElement.accessibilityTraits = UIAccessibilityTraitLink
        ////
        ////                        element.accessibilityElements = [innerElement]
        ////
        ////                        accessibleElements?.append(element)
        ////                    }
        ////                }
        ////            }
        ////
        ////            return accessibleElements
        ////        }
        ////        set {}
        ////    }
    }

    public extension NSAttributedString.Key {
        static let attributedLabelLink = NSAttributedString.Key("Atributika.AttributedLabel.Link")
    }

    public extension Attributes {
        @discardableResult
        func attributedLabelLink(_ value: String) -> Self {
            return attribute(.attributedLabelLink, value)
        }
    }

#endif
