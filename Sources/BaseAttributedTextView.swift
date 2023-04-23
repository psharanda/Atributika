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

        private var _backend: TextViewBackend!

        private let _trackingControl = TrackingControl()

        func makeBackend() -> TextViewBackend {
            fatalError("BaseAttributedTextView is for subclassing only")
        }

        // MARK: - links

        open var onLinkTouchUpInside: ((BaseAttributedTextView, Any) -> Void)?

        open func rects(for range: Range<String.Index>) -> [CGRect] {
            var result = [CGRect]()

            if let str = attributedText {
                let nsrange = NSRange(range, in: str.string)
                _backend.enumerateEnclosingRects(
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
                if (oldValue != isEnabled) {
                    setNeedsDisplayText()
                }
            }
        }

        @IBInspectable open var attributedText: NSAttributedString? {
            didSet {
                setNeedsDisplayText()
                _linkFramesCache = nil
                _accessibleElements = nil
                
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
                if _backend.numberOfLines != newValue {
                    _backend.numberOfLines = newValue
                    setNeedsDisplayText()
                }
            }
            get {
                return _backend.numberOfLines
            }
        }

        @IBInspectable open var lineBreakMode: NSLineBreakMode {
            set {
                if _backend.lineBreakMode != newValue {
                    _backend.lineBreakMode = newValue
                    setNeedsDisplayText()
                }
            }
            get {
                return _backend.lineBreakMode
            }
        }

        open var lineBreakStrategy: NSParagraphStyle.LineBreakStrategy = [.pushOut] {
            didSet {
                if oldValue != lineBreakStrategy {
                    setNeedsDisplayText()
                }
            }
        }

        @available(iOS 10.0, *)
        @IBInspectable open var adjustsFontForContentSizeCategory: Bool {
            set {
                if _backend.adjustsFontForContentSizeCategory != newValue {
                    _backend.adjustsFontForContentSizeCategory = newValue
                    setNeedsDisplayText()
                }
            }
            get {
                return _backend.adjustsFontForContentSizeCategory
            }
        }

        @IBInspectable open var font: UIFont = .preferredFont(forTextStyle: .body) {
            didSet {
                if oldValue != font {
                    setNeedsDisplayText()
                }
            }
        }

        @IBInspectable open var textAlignment: NSTextAlignment = .natural {
            didSet {
                if oldValue != textAlignment {
                    setNeedsDisplayText()
                }
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
                if oldValue != textColor {
                    setNeedsDisplayText()
                }
            }
        }

        @IBInspectable open var shadowColor: UIColor? {
            didSet {
                if oldValue != shadowColor {
                    setNeedsDisplayText()
                }
            }
        }

        @IBInspectable open var shadowOffset = CGSize(width: 0, height: -1) {
            didSet {
                if oldValue != shadowOffset {
                    setNeedsDisplayText()
                }
            }
        }

        @IBInspectable open var shadowBlurRadius: CGFloat = 0 {
            didSet {
                if oldValue != shadowBlurRadius {
                    setNeedsDisplayText()
                }
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
            _backend = makeBackend()

            _trackingControl.parent = self
            isAccessibilityElement = false

            addSubview(_backend.view)

            _backend.view.addSubview(_trackingControl)

            lineBreakMode = .byTruncatingTail
            numberOfLines = 1

            _backend.view.translatesAutoresizingMaskIntoConstraints = false

            _backend.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            _backend.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            _backend.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            _backend.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }

        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            return _backend.view.sizeThatFits(size)
        }

        override open var forFirstBaselineLayout: UIView {
            return _backend.view
        }

        override open var forLastBaselineLayout: UIView {
            return _backend.view
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

        private var _trackedLinkRange: NSRange?

        private var _highlightedLinkRange: NSRange? {
            didSet {
                if (oldValue != _highlightedLinkRange) {
                    setNeedsDisplayText()
                }
            }
        }

        func _beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
            let pt = touch.location(in: _backend.view)
            _trackedLinkRange = linkRange(at: _trackingControl.convert(pt, to: _backend.view))
            if _trackedLinkRange != nil {
                _highlightedLinkRange = _trackedLinkRange
                return true
            } else {
                return false
            }
        }

        func _continueTracking(_ touch: UITouch, with _: UIEvent?) {
            let pt = touch.location(in: _backend.view)
            if let currentDetection = linkRange(at: _trackingControl.convert(pt, to: _backend.view)) {
                if currentDetection == _trackedLinkRange {
                    if _highlightedLinkRange != _trackedLinkRange {
                        _highlightedLinkRange = _trackedLinkRange
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
            _trackedLinkRange = nil
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
            _trackedLinkRange = nil
            _highlightedLinkRange = nil
        }

        override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let superResult = super.hitTest(point, with: event)

            if _trackingControl.isTracking {
                return _trackingControl
            }

            if (superResult == self || superResult == _backend.view) && linkRange(at: convert(point, to: _backend.view)) != nil {
                return _trackingControl
            }

            if !_backend.view.isUserInteractionEnabled {
                return nil
            } else {
                return superResult
            }
        }
        
        private struct RangeRects {
            let range: NSRange
            let rects: [CGRect]
        }
        
        private var _linkFramesCache: [RangeRects]?
        
        
        private func calculateLinksRangeRectsIfNeeded() {
            guard let str = _backend.attributedText, _linkFramesCache == nil else {
                return
            }
            
            var newLinkFramesCache: [RangeRects] = []
            
            str.enumerateAttribute(
                .akaLink,
                in: NSRange(location: 0, length: str.length)
            ) { val, range, stop in

                guard val != nil else {
                    return
                }
                
                var rects = [CGRect]()
                _backend.enumerateEnclosingRects(
                    forGlyphRange: range,
                    using: { rect in
                        rects.append(rect)
                        return false
                    }
                )
                
                newLinkFramesCache.append(RangeRects(range: range, rects: rects))
            }
            
            _linkFramesCache = newLinkFramesCache
        }

        private func linkRange(at point: CGPoint) -> NSRange? {
            
            calculateLinksRangeRectsIfNeeded()
            
            let textOrigin = _backend.textOrigin
            let adjustedPoint = CGPoint(x: point.x - textOrigin.x, y: point.y - textOrigin.y)

            guard let linkFramesCache = _linkFramesCache else {
                return nil
            }
            
            for rr in linkFramesCache {
                for rect in rr.rects {
                    if rect.contains(adjustedPoint) {
                        return rr.range
                    }
                }
            }
            
            return nil
        }

        override open func layoutSubviews() {
            super.layoutSubviews()
            _linkFramesCache = nil
        }

        override open var intrinsicContentSize: CGSize {
            displayTextIfNeeded()
            return super.intrinsicContentSize
        }

        private var _needsDisplayText: Bool = true

        private func setNeedsDisplayText() {
            _needsDisplayText = true
            invalidateIntrinsicContentSize()
        }

        private func displayTextIfNeeded() {
            if _needsDisplayText {
                _needsDisplayText = false
                updateText()
            }
        }

        private func updateText() {
            guard let str = attributedText else {
                _backend.attributedText = nil
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
                let shouldAdjustsFontForContentSizeCategory = _backend.adjustsFontForContentSizeCategory

                if shouldAdjustsFontForContentSizeCategory {
                    _backend.adjustsFontForContentSizeCategory = false
                }

                _backend.attributedText = result

                if shouldAdjustsFontForContentSizeCategory {
                    _backend.adjustsFontForContentSizeCategory = true
                }
            } else {
                _backend.attributedText = result
            }
        }

        // MARK: - Accessibitilty
        
        public enum AccessibilityBehaviour {
            case natural
            case textFirstLinksAfter
        }
        
        open var accessibilityBehaviour: AccessibilityBehaviour = .natural {
            didSet {
                _accessibleElements = nil
            }
        }

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

            override func accessibilityElementDidBecomeFocused() {
                super.accessibilityElementDidBecomeFocused()

                guard let view = view else {
                    return
                }

                if let scrollView = view as? UIScrollView {

                    if enclosingRects.count == 0 {
                        return
                    }

                    var resultRect = enclosingRects[0]

                    for i in 1 ..< enclosingRects.count {
                        resultRect = resultRect.union(enclosingRects[i])
                    }

                    scrollView.scrollRectToVisible(resultRect, animated: false)
                }
            }
        }

        private var _accessibleElements: [Any]?

        override open var accessibilityElements: [Any]? {
            get {
                if _accessibleElements == nil {
                    _accessibleElements = []

                    if let str = attributedText {

                        if (accessibilityBehaviour != .natural) {
                            let text = AccessibilityElement(container: self, view: self, enclosingRects: [_backend.view.frame], usePath: false)
                            text.accessibilityLabel = str.string
                            text.accessibilityTraits = .staticText
                            _accessibleElements?.append(text)
                        }

                        let textOrigin = _backend.textOrigin

                        str.enumerateAttribute(
                            .akaLink,
                            in: NSRange(location: 0, length: str.length)
                        ) { val, range, _ in

                            if accessibilityBehaviour == .natural {
                                if range.length == 0 {
                                    return
                                }

                                if range.length == 1 {
                                    if let r = Range(range, in: str.string) {
                                        let char = str.string[r.lowerBound]
                                        if CharacterSet.whitespaces.contains(char.unicodeScalars.first!) {
                                            return
                                        }
                                    }
                                }
                            } else {
                                if (val == nil) {
                                    return
                                }
                            }

                            var enclosingRects = [CGRect]()

                            _backend.enumerateEnclosingRects(
                                forGlyphRange: range,
                                using: { rect in
                                    enclosingRects.append(CGRect(
                                        x:  rect.origin.x + textOrigin.x,
                                        y:  rect.origin.y + textOrigin.y,
                                        width: rect.width,
                                        height: rect.height))
                                    return false
                                }
                            )

                            let element = AccessibilityElement(container: self, view: _backend.view, enclosingRects: enclosingRects, usePath: true)
                            element.isAccessibilityElement = false

                            let innerElement = AccessibilityElement(container: element, view: _backend.view, enclosingRects: enclosingRects, usePath: false)

                            if let r = Range(range, in: str.string) {
                                innerElement.accessibilityLabel = String(str.string[r])
                            }

                            if (accessibilityBehaviour == .natural) {
                                innerElement.accessibilityTraits = val == nil ? .staticText : .link
                            } else {
                                innerElement.accessibilityTraits = .staticText
                            }


                            element.accessibilityElements = [innerElement]

                            _accessibleElements?.append(element)
                        }
                    }
                }

                return _accessibleElements
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
