//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    protocol TextViewBackend: AnyObject {
        var attributedText: NSAttributedString? { get set }
        var numberOfLines: Int { get set }
        var lineBreakMode: NSLineBreakMode { get set }

        @available(iOS 10.0, *)
        var adjustsFontForContentSizeCategory: Bool { get set }

        var textOrigin: CGPoint { get }

        var view: UIView { get }

        func enumerateEnclosingRects(forGlyphRange glyphRange: NSRange, using block: @escaping (CGRect) -> Bool)
    }

    open class BaseAttributedTextView: UIView {
        override open func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            attributedText = NSAttributedString(
                string: "Label",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.darkGray]
            )
            invalidateIntrinsicContentSize()
        }

        // MARK: - private properties

        private var backend: TextViewBackend!

        private let trackingControl = TrackingControl()

        func makeBackend() -> TextViewBackend {
            fatalError("BaseAttributedTextView is for subclassing only")
        }

        // MARK: - links

        open var onLinkTouchUpInside: ((BaseAttributedTextView, Any) -> Void)?

        open func rects(for range: Range<String.Index>) -> [CGRect] {
            var result = [CGRect]()

            if let str = attributedText {
                let nsrange = NSRange(range, in: str.string)
                backend.enumerateEnclosingRects(
                    forGlyphRange: nsrange,
                    using: { rect in
                        result.append(rect)
                        return false
                    }
                )
            }

            return result
        }

        open var highlightedLinkValue: Any? {
            if let range = _highlightedLinkRange,
               let val = attributedText?.attribute(.akaLink, at: range.location, effectiveRange: nil)
            {
                return val
            } else {
                return nil
            }
        }

        open var highlightedLinkRange: Range<String.Index>? {
            if let str = attributedText?.string, let range = _highlightedLinkRange {
                return Range(range, in: str)
            } else {
                return nil
            }
        }

        // MARK: - public properties

        open var isEnabled: Bool = true {
            didSet {
                setNeedsDisplayText()
            }
        }

        @IBInspectable open var attributedText: NSAttributedString? {
            didSet {
                setNeedsDisplayText()
                accessibleElements = nil
            }
        }

        open var highlightedLinkAttributes: [NSAttributedString.Key: Any]? {
            didSet {
                setNeedsDisplayText()
            }
        }

        open var disabledLinkAttributes: [NSAttributedString.Key: Any]? {
            didSet {
                setNeedsDisplayText()
            }
        }

        @IBInspectable open var numberOfLines: Int {
            set {
                backend.numberOfLines = newValue
            }
            get {
                return backend.numberOfLines
            }
        }

        @IBInspectable open var lineBreakMode: NSLineBreakMode {
            set {
                backend.lineBreakMode = newValue
            }
            get {
                return backend.lineBreakMode
            }
        }

        open var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy = [.pushOut] {
            didSet {
                setNeedsDisplayText()
            }
        }

        @available(iOS 10.0, *)
        @IBInspectable open var adjustsFontForContentSizeCategory: Bool {
            set {
                backend.adjustsFontForContentSizeCategory = newValue
            }
            get {
                return backend.adjustsFontForContentSizeCategory
            }
        }

        @IBInspectable open var font: UIFont = .preferredFont(forTextStyle: .body) {
            didSet {
                setNeedsDisplayText()
            }
        }

        @IBInspectable open var textAlignment: NSTextAlignment = .natural {
            didSet {
                setNeedsDisplayText()
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
                setNeedsDisplayText()
            }
        }

        @IBInspectable open var shadowColor: UIColor? {
            didSet {
                setNeedsDisplayText()
            }
        }

        @IBInspectable open var shadowOffset = CGSize(width: 0, height: -1) {
            didSet {
                setNeedsDisplayText()
            }
        }

        @IBInspectable open var shadowBlurRadius: CGFloat = 0 {
            didSet {
                setNeedsDisplayText()
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
            backend = makeBackend()

            trackingControl.parent = self
            isAccessibilityElement = false

            addSubview(backend.view)

            backend.view.addSubview(trackingControl)

            lineBreakMode = .byTruncatingTail
            numberOfLines = 1

            backend.view.translatesAutoresizingMaskIntoConstraints = false

            backend.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            backend.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            backend.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            backend.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }

        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            return backend.view.sizeThatFits(size)
        }

        override open var forFirstBaselineLayout: UIView {
            return backend.view
        }

        override open var forLastBaselineLayout: UIView {
            return backend.view
        }

        // MARK: - tracking

        private class TrackingControl: UIControl {
            weak var parent: BaseAttributedTextView?

            override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
                if super.beginTracking(touch, with: event) {
                    return parent?._beginTracking(touch, with: event) ?? false
                } else {
                    return false
                }
            }

            override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
                parent?._continueTracking(touch, with: event)
                return super.continueTracking(touch, with: event)
            }

            override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
                super.endTracking(touch, with: event)
                parent?._endTracking(touch, with: event)
            }

            override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                parent?._preTouchesEnded(touches, with: event)

                super.touchesEnded(touches, with: event)

                parent?._postTouchesEnded(touches, with: event)
            }

            override open func cancelTracking(with event: UIEvent?) {
                super.cancelTracking(with: event)
                parent?._cancelTracking(with: event)
            }
        }

        private var trackedLinkRange: NSRange? {
            didSet {
                setNeedsDisplayText()
            }
        }

        private var _highlightedLinkRange: NSRange? {
            didSet {
                setNeedsDisplayText()
            }
        }

        func _beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
            let pt = touch.location(in: backend.view)
            trackedLinkRange = linkRange(at: trackingControl.convert(pt, to: backend.view))
            if trackedLinkRange != nil {
                _highlightedLinkRange = trackedLinkRange
                return true
            } else {
                return false
            }
        }

        func _continueTracking(_ touch: UITouch, with _: UIEvent?) {
            let pt = touch.location(in: backend.view)
            if let currentDetection = linkRange(at: trackingControl.convert(pt, to: backend.view)) {
                if currentDetection == trackedLinkRange {
                    if _highlightedLinkRange != trackedLinkRange {
                        _highlightedLinkRange = trackedLinkRange
                    }
                } else {
                    if _highlightedLinkRange != nil {
                        _highlightedLinkRange = nil
                    }
                }
            } else {
                _highlightedLinkRange = nil
            }
        }

        func _endTracking(_: UITouch?, with _: UIEvent?) {
            trackedLinkRange = nil
        }

        func _preTouchesEnded(_: Set<UITouch>, with _: UIEvent?) {
            if let val = highlightedLinkValue {
                onLinkTouchUpInside?(self, val)
            }
        }

        func _postTouchesEnded(_: Set<UITouch>, with _: UIEvent?) {
            _highlightedLinkRange = nil
        }

        func _cancelTracking(with _: UIEvent?) {
            trackedLinkRange = nil
            _highlightedLinkRange = nil
        }

        override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let superResult = super.hitTest(point, with: event)

            if trackingControl.isTracking {
                return trackingControl
            }

            if (superResult == self || superResult == backend.view) && linkRange(at: convert(point, to: backend.view)) != nil {
                return trackingControl
            }

            if !backend.view.isUserInteractionEnabled {
                return nil
            } else {
                return superResult
            }
        }

        private func linkRange(at point: CGPoint) -> NSRange? {
            let textOrigin = backend.textOrigin
            let adjustedPoint = CGPoint(x: point.x - textOrigin.x, y: point.y - textOrigin.y)

            var result: NSRange?

            if let str = attributedText {
                str.enumerateAttribute(
                    .akaLink,
                    in: NSRange(location: 0, length: str.length)
                ) { val, range, stop in

                    guard val != nil else {
                        return
                    }
                    backend.enumerateEnclosingRects(
                        forGlyphRange: range,
                        using: { rect in
                            if rect.contains(adjustedPoint) {
                                result = range
                                return true
                            }
                            return false
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
        }

        override open var intrinsicContentSize: CGSize {
            displayTextIfNeeded()
            return super.intrinsicContentSize
        }

        private var needsDisplayText: Bool = true

        private func setNeedsDisplayText() {
            needsDisplayText = true
            invalidateIntrinsicContentSize()
        }

        private func displayTextIfNeeded() {
            if needsDisplayText {
                needsDisplayText = false
                updateText()
            }
        }

        private func updateText() {
            guard let str = attributedText else {
                backend.attributedText = nil
                return
            }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            paragraphStyle.lineBreakStrategy = lineBreakStrategy

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

            let length = str.length
            let result = NSMutableAttributedString(string: str.string, attributes: inheritedAttributes)

            result.beginEditing()

            str.enumerateAttributes(in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { attributes, range, _ in
                result.addAttributes(attributes, range: range)

                if attributes[.akaLink] != nil {
                    if !isEnabled, let attrs = disabledLinkAttributes {
                        result.addAttributes(attrs, range: range)
                    }
                }
            })

            if let range = _highlightedLinkRange, let attrs = highlightedLinkAttributes {
                result.addAttributes(attrs, range: range)
            }

            result.endEditing()

            if #available(iOS 10.0, *) {
                let shouldAdjustsFontForContentSizeCategory = backend.adjustsFontForContentSizeCategory

                if shouldAdjustsFontForContentSizeCategory {
                    backend.adjustsFontForContentSizeCategory = false
                }

                backend.attributedText = result

                if shouldAdjustsFontForContentSizeCategory {
                    backend.adjustsFontForContentSizeCategory = true
                }
            } else {
                backend.attributedText = result
            }
        }

        // MARK: - Accessibitilty

        private class AccessibilityElement: UIAccessibilityElement {
            private weak var view: UIView?
            private let enclosingRects: [CGRect]
            private let usePath: Bool

            init(container: Any, view: UIView, enclosingRects: [CGRect], usePath: Bool) {
                self.view = view
                self.enclosingRects = enclosingRects
                self.usePath = usePath
                super.init(accessibilityContainer: container)
            }

            override var accessibilityActivationPoint: CGPoint {
                get {
                    guard let view = view else {
                        return .zero
                    }

                    if enclosingRects.count == 0 {
                        return .zero
                    } else {
                        let rect = UIAccessibility.convertToScreenCoordinates(enclosingRects[0], in: view)
                        return CGPoint(x: rect.midX, y: rect.midY)
                    }
                }
                set {}
            }

            override var accessibilityFrame: CGRect {
                get {
                    guard let view = view else {
                        return .null
                    }

                    if enclosingRects.count == 0 {
                        return .null
                    }

                    if enclosingRects.count == 1 {
                        return UIAccessibility.convertToScreenCoordinates(enclosingRects[0], in: view)
                    }

                    var resultRect = enclosingRects[0]

                    for i in 1 ..< enclosingRects.count {
                        resultRect = resultRect.union(enclosingRects[i])
                    }

                    return UIAccessibility.convertToScreenCoordinates(resultRect, in: view)
                }
                set {}
            }

            override var accessibilityPath: UIBezierPath? {
                get {
                    if !usePath {
                        return nil
                    }
                    guard let view = view else {
                        return nil
                    }

                    let path = UIBezierPath()

                    enclosingRects.forEach { rect in
                        path.append(UIBezierPath(rect: rect))
                    }

                    return UIAccessibility.convertToScreenCoordinates(path, in: view)
                }
                set {}
            }
        }

        private var accessibleElements: [Any]?

        override open var accessibilityElements: [Any]? {
            get {
                if accessibleElements == nil {
                    accessibleElements = []

                    if let str = attributedText {
                        let text = AccessibilityElement(container: self, view: self, enclosingRects: [backend.view.frame], usePath: false)
                        text.accessibilityLabel = str.string
                        text.accessibilityTraits = UIAccessibilityTraits.staticText
                        accessibleElements?.append(text)

                        str.enumerateAttribute(
                            .akaLink,
                            in: NSRange(location: 0, length: str.length)
                        ) { val, range, _ in

                            guard val != nil else {
                                return
                            }

                            var enclosingRects = [CGRect]()

                            backend.enumerateEnclosingRects(
                                forGlyphRange: range,
                                using: { rect in
                                    enclosingRects.append(rect)
                                    return false
                                }
                            )

                            let element = AccessibilityElement(container: self, view: self, enclosingRects: enclosingRects, usePath: true)
                            element.isAccessibilityElement = false

                            let innerElement = AccessibilityElement(container: element, view: self, enclosingRects: enclosingRects, usePath: false)

                            if let r = Range(range, in: str.string) {
                                innerElement.accessibilityLabel = String(str.string[r])
                            }
                            innerElement.accessibilityTraits = UIAccessibilityTraits.link

                            element.accessibilityElements = [innerElement]

                            accessibleElements?.append(element)
                        }
                    }
                }

                return accessibleElements
            }
            set {}
        }
    }

    public extension NSAttributedString.Key {
        static let akaLink = NSAttributedString.Key("Atributika.Link")
    }

    public extension Attributes {
        @discardableResult
        func akaLink(_ value: Any) -> Self {
            return attribute(.akaLink, value)
        }
    }

#endif
