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

        func enclosingRects(forGlyphRange glyphRange: NSRange) -> [CGRect]
    }

    open class BaseAttributedTextView: UIView {
        // MARK: - Private properties

        private var _backend: TextViewBackend!

        private let _trackingControl = TrackingControl()

        func makeBackend() -> TextViewBackend {
            fatalError("BaseAttributedTextView is for subclassing only")
        }

        // MARK: - Links

        open var linkHighlightViewFactory: LinkHighlightViewFactoryProtocol?

        open var onLinkTouchUpInside: ((BaseAttributedTextView, Any) -> Void)?

        open func rects(for range: Range<String.Index>) -> [CGRect] {
            if let str = attributedText {
                let nsrange = NSRange(range, in: str.string)
                let textOrigin = _backend.textOrigin
                return _backend.enclosingRects(forGlyphRange: nsrange)
                    .map {
                        CGRect(
                            x: $0.origin.x + textOrigin.x,
                            y: $0.origin.y + textOrigin.y,
                            width: $0.size.width,
                            height: $0.size.height
                        )
                    }
                    .map {
                        convert($0, from: _backend.view)
                    }
            } else {
                return []
            }
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

        // MARK: - Link rect calculation

        private struct RangeRects {
            let range: NSRange
            let rects: [CGRect]
        }

        private var _linkFramesCache: [RangeRects]?

        private func invalidateLinkFramesCache() {
            _linkFramesCache = nil
        }

        private func calculateLinksRangeRectsIfNeeded() {
            guard let str = attributedText, _linkFramesCache == nil else {
                return
            }

            var newLinkFramesCache: [RangeRects] = []

            str.enumerateAttribute(
                .akaLink,
                in: NSRange(location: 0, length: str.length)
            ) { val, range, _ in

                guard val != nil else {
                    return
                }

                let rects = _backend.enclosingRects(forGlyphRange: range)
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

        // MARK: - Public properties

        @IBInspectable open var attributedText: NSAttributedString? {
            didSet {
                setNeedsDisplayText()
                invalidateLinkFramesCache()
                invalidateAccessibilityElements()
            }
        }

        open var isEnabled: Bool = true {
            didSet {
                isUserInteractionEnabled = isEnabled
                if oldValue != isEnabled {
                    setNeedsDisplayText()
                }
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

        @IBInspectable open var textAlignment: NSTextAlignment = .natural {
            didSet {
                if oldValue != textAlignment {
                    setNeedsDisplayText()
                }
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

        // MARK: - Init

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

        // MARK: - Overrides

        override open func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            attributedText = NSAttributedString(
                string: "Label",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.darkGray]
            )
            invalidateIntrinsicContentSize()
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

        override open func layoutSubviews() {
            super.layoutSubviews()
            invalidateLinkFramesCache()
            invalidateAccessibilityElements()
        }

        override open var intrinsicContentSize: CGSize {
            displayTextIfNeeded()
            return super.intrinsicContentSize
        }

        // MARK: - Links tracking

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

        private var _linkHighlightView: (UIView & LinkHighlightViewProtocol)?

        private var _highlightedLinkRange: NSRange? {
            didSet {
                if oldValue != _highlightedLinkRange {
                    _linkHighlightView?.removeFrom(textView: self)
                    _linkHighlightView = nil
                    if let range = _highlightedLinkRange,
                       let cache = _linkFramesCache,
                       let factory = linkHighlightViewFactory
                    {
                        for item in cache {
                            if item.range == range {
                                let unionRect = item.rects.reduce(item.rects[0]) {
                                    $0.union($1)
                                }

                                let linkHighlightView = factory.createView(
                                    enclosingRects: item.rects.map {
                                        CGRect(x: $0.origin.x - unionRect.minX,
                                               y: $0.origin.y - unionRect.minY,
                                               width: $0.width,
                                               height: $0.height)
                                    })
                                insertSubview(linkHighlightView, belowSubview: _backend.view)

                                let textOrigin = _backend.textOrigin
                                linkHighlightView.frame = convert(
                                    unionRect.offsetBy(dx: textOrigin.x, dy: textOrigin.y),
                                    from: _backend.view
                                )
                                linkHighlightView.didAdd(to: self)
                                _linkHighlightView = linkHighlightView
                            }
                        }
                    }
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
            if _trackingControl.isTracking {
                return _trackingControl
            }

            let superResult = super.hitTest(point, with: event)

            if (superResult == self || superResult == _backend.view) && linkRange(at: convert(point, to: _backend.view)) != nil {
                return _trackingControl
            }

            if !_backend.view.isUserInteractionEnabled {
                return nil
            } else {
                return superResult
            }
        }

        // MARK: - Update text

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

            str.enumerateAttributes(in: NSMakeRange(0, length),
                                    options: .longestEffectiveRangeNotRequired,
                                    using: { attributes, range, _ in
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

        private struct RangeInfo {
            let range: NSRange
            let substring: String
            let type: UIAccessibilityTraits
        }

        private func invalidateAccessibilityElements() {
            _accessibilityElements = nil
            _accessibilityRanges = nil
        }

        private var _accessibilityElements: [RectsAccessibilityElement?]?
        private var _accessibilityRanges: [RangeInfo]?

        override open func accessibilityElementCount() -> Int {
            if let count = _accessibilityElements?.count {
                return count
            }

            guard let str = attributedText else {
                return 0
            }

            var newAccessibilityRanges: [RangeInfo] = []
            var newAccessibilityElements: [RectsAccessibilityElement?] = []

            let nsString = str.string as NSString

            nsString.enumerateSubstrings(
                in: NSRange(location: 0, length: nsString.length), options: [.byParagraphs, .substringNotRequired]
            ) { _, substringRange, _, _ in
                str.enumerateAttribute(
                    .akaLink,
                    in: substringRange
                ) { val, range, _ in
                    newAccessibilityRanges.append(
                        RangeInfo(range: range,
                                  substring: nsString.substring(with: range),
                                  type: val != nil ? .link : .staticText)
                    )
                    newAccessibilityElements.append(nil)
                }
            }
            _accessibilityRanges = newAccessibilityRanges
            _accessibilityElements = newAccessibilityElements

            return newAccessibilityElements.count
        }

        override open func accessibilityElement(at index: Int) -> Any? {
            guard let ranges = _accessibilityRanges
            else {
                return nil
            }

            if let cached = _accessibilityElements![index] {
                return cached
            }

            let textOrigin = _backend.textOrigin

            let rangeInfo = ranges[index]

            let enclosingRects = _backend.enclosingRects(forGlyphRange: rangeInfo.range)
                .map { rect in
                    CGRect(x: rect.origin.x + textOrigin.x,
                           y: rect.origin.y + textOrigin.y,
                           width: rect.width,
                           height: rect.height)
                }

            let element = RectsAccessibilityElement(container: self,
                                                    view: _backend.view,
                                                    enclosingRects: enclosingRects,
                                                    usePath: true)
            element.isAccessibilityElement = false

            let innerElement = RectsAccessibilityElement(container: element,
                                                         view: _backend.view,
                                                         enclosingRects: enclosingRects,
                                                         usePath: false)
            innerElement.accessibilityLabel = rangeInfo.substring
            innerElement.accessibilityTraits = rangeInfo.type

            element.accessibilityElements = [innerElement]

            _accessibilityElements![index] = element

            return element
        }

        override open func index(ofAccessibilityElement element: Any) -> Int {
            guard let elements = _accessibilityElements,
                  let elObject = element as? RectsAccessibilityElement
            else {
                return NSNotFound
            }

            for (idx, el) in elements.enumerated() {
                if elObject === el {
                    return idx
                }
            }

            return NSNotFound
        }
    }

    public extension NSAttributedString.Key {
        static let akaLink = NSAttributedString.Key("Atributika.Link")
    }

    public extension Attrs {
        @discardableResult
        func akaLink(_ value: Any) -> Self {
            return attribute(.akaLink, value)
        }
    }

#endif
