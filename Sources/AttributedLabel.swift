//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

 #if os(iOS)

 import UIKit

@IBDesignable open class AttributedLabel: UIControl {}

//
// @IBDesignable open class AttributedLabel: UIControl {
//    open func setTextAttributes(for key: NSAttributedString.Key, _ attrs: [NSAttributedString.Key: Any], for state: UIControl.State) {
//
//    }
//
//    open override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        let gray = AttributesBuilder().foregroundColor(.gray).attributes
//        attributedText = "<gray>Attributed</gray>Label"
//            .style(tags: ["gray": gray])
//        invalidateIntrinsicContentSize()
//    }
//
//    //MARK: - private properties
//    private let textView = UITextView()
//
//    //MARK: - public properties
//    open var onClick: ((AttributedLabel, Detection)->Void)?
//
//    open func rects(for detection: Detection) -> [CGRect] {
//        var result = [CGRect]()
//
//        if let attributedText = internalState.attributedText {
//            let nsrange = NSRange(detection.range, in: attributedText.string)
//            textView.layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textView.textContainer, using: { (rect, stop) in
//                result.append(rect)
//            })
//        }
//
//        return result
//    }
//
//    @IBInspectable open override var isEnabled: Bool {
//        set {
//            internalState.isEnabled = newValue
//        }
//        get {
//            return internalState.isEnabled
//        }
//    }
//
//    @IBInspectable open var isSelectable: Bool {
//        get {
//            return textView.isUserInteractionEnabled && textView.isSelectable
//        }
//        set {
//            textView.isSelectable = newValue
//            textView.isUserInteractionEnabled = newValue
//        }
//    }
//
//    open var attributedText: AttributedText? {
//        set {
//            internalState = State(attributedText: newValue, isEnabled: internalState.isEnabled, detection: nil)
//            setNeedsLayout()
//        }
//        get {
//            return internalState.attributedText
//        }
//    }
//
//    @IBInspectable open var numberOfLines: Int {
//        set { textView.textContainer.maximumNumberOfLines = newValue }
//        get { return textView.textContainer.maximumNumberOfLines }
//    }
//
//    @IBInspectable open var lineBreakMode: NSLineBreakMode {
//        set { textView.textContainer.lineBreakMode = newValue }
//        get { return textView.textContainer.lineBreakMode }
//    }
//
//    @available(iOS 10.0, *)
//    @IBInspectable open var adjustsFontForContentSizeCategory: Bool {
//        set { textView.adjustsFontForContentSizeCategory = newValue }
//        get { return textView.adjustsFontForContentSizeCategory }
//    }
//
//    @IBInspectable open var font: UIFont = .preferredFont(forTextStyle: .body) {
//        didSet {
//            updateText()
//        }
//    }
//
//    @IBInspectable open var textAlignment: NSTextAlignment = .natural {
//        didSet {
//            updateText()
//        }
//    }
//
//    @IBInspectable open var textColor: UIColor = {
//        if #available(iOS 13.0, *) {
//            return .label
//        } else {
//            return .black
//        }
//        }() {
//        didSet {
//            updateText()
//        }
//    }
//
//    @IBInspectable open var shadowColor: UIColor? {
//        didSet {
//            updateText()
//        }
//    }
//
//    @IBInspectable open var shadowOffset = CGSize(width: 0, height: -1) {
//        didSet {
//            updateText()
//        }
//    }
//
//    @IBInspectable open var shadowBlurRadius: CGFloat = 0 {
//        didSet {
//            updateText()
//        }
//    }
//
//    //MARK: - init
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        isAccessibilityElement = false
//
//        addSubview(textView)
//
//        lineBreakMode = .byTruncatingTail
//        numberOfLines = 1
//
//        textView.isUserInteractionEnabled = false
//        textView.textContainer.lineFragmentPadding = 0;
//        textView.textContainerInset = .zero;
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        textView.isSelectable = false
//        textView.backgroundColor = nil
//
//        textView.translatesAutoresizingMaskIntoConstraints = false
//
//        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//    }
//
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return textView.sizeThatFits(size)
//    }
//
//    open override var forFirstBaselineLayout: UIView {
//        return textView
//    }
//
//    open override var forLastBaselineLayout: UIView {
//        return textView
//    }
//
//    private var trackedDetection: Detection?
//
//    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let pt = touch.location(in: self)
//        if super.beginTracking(touch, with: event) {
//            trackedDetection = detection(at: pt)
//            if trackedDetection != nil {
//                internalState.detection = trackedDetection
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
//    }
//
//    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let pt = touch.location(in: self)
//        if let currentDetection = detection(at: pt) {
//            if currentDetection.range == trackedDetection?.range {
//                if internalState.detection?.range != trackedDetection?.range {
//                    internalState.detection = trackedDetection
//                }
//            } else {
//                if internalState.detection != nil {
//                    internalState.detection = nil
//                }
//            }
//        } else {
//            internalState.detection = nil
//        }
//        return super.continueTracking(touch, with: event)
//    }
//
//    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        super.endTracking(touch, with: event)
//        if let detection = internalState.detection {
//            onClick?(self, detection)
//        }
//        trackedDetection = nil
//        internalState.detection = nil
//    }
//
//    open override func cancelTracking(with event: UIEvent?) {
//        super.cancelTracking(with: event)
//        trackedDetection = nil
//        internalState.detection = nil
//    }
//
//    private var highlightableDetections: [Detection] {
////        guard let detections = attributedText?.detections else {
////            return []
////        }
////
////        var previousDetection: Detection?
////
////        return detections
////            .filter { $0.style.typedAttributes[.highlighted] != nil }
////            .sorted { $0.range.lowerBound < $1.range.lowerBound }
////            .filter { d in
////                var result = true
////                if let previousDetection = previousDetection {
////                    result = !d.range.overlaps(previousDetection.range)
////                }
////                previousDetection = d
////                return result
////            }
//        return []
//    }
//
//    private func detection(at point: CGPoint) -> Detection? {
//
//        var result: Detection?
//
//        if let attributedText = internalState.attributedText {
//
//            for detection in highlightableDetections {
//                let nsrange = NSRange(detection.range, in: attributedText.string)
//                textView.layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange,
//                                                               withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
//                                                               in: textView.textContainer, using: { (rect, stop) in
//                    if rect.contains(point) {
//                        stop.pointee = true
//                        result = detection
//                    }
//                })
//                if result != nil {
//                    break
//                }
//            }
//        }
//
//        return result;
//    }
//
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        //accessibleElements = nil
//    }
//
//    //MARK: - state
//
//    private struct State {
//        var attributedText: AttributedText?
//        var isEnabled: Bool
//        var detection: Detection?
//    }
//
//    private var internalState: State = State(attributedText: nil, isEnabled: true, detection: nil) {
//        didSet {
//            updateText()
//        }
//    }
//
//    private func updateAttributedTextInTextView(_ string: NSAttributedString) {
//
//        let paragraphStyle = NSMutableParagraphStyle
//        paragraphStyle.alignment = textAlignment
//
//        var inheritedAttributes = [NSAttributedString.Key.font: font as Any,
//                                   NSAttributedString.Key.paragraphStyle: paragraphStyle as Any,
//                                   NSAttributedString.Key.foregroundColor: textColor]
//
//        if let shadowColor = shadowColor {
//            let shadow = NSShadow()
//            shadow.shadowColor = shadowColor
//            shadow.shadowOffset = shadowOffset
//            shadow.shadowBlurRadius = shadowBlurRadius
//            inheritedAttributes[NSAttributedString.Key.shadow] = shadow
//        }
//
//        let length = string.length
//        let result = NSMutableAttributedString(string: string.string, attributes: inheritedAttributes)
//
//        result.beginEditing()
//
//        string.enumerateAttributes(in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
//            result.addAttributes(attributes, range: range)
//        })
//        result.endEditing()
//
//
//        if #available(iOS 10.0, *) {
//            let shouldAdjustsFontForContentSizeCategory = textView.adjustsFontForContentSizeCategory
//
//            if shouldAdjustsFontForContentSizeCategory {
//                textView.adjustsFontForContentSizeCategory = false
//            }
//
//            textView.attributedText = result
//
//            if shouldAdjustsFontForContentSizeCategory {
//                textView.adjustsFontForContentSizeCategory = true
//            }
//        } else {
//            textView.attributedText = string
//        }
//    }
//
//    private func updateText() {
////        if let attributedText = internalState.attributedText {
////
////            if let detection = internalState.detection {
////                let higlightedAttributedString = NSMutableAttributedString(attributedString: attributedText.attributedString)
////                higlightedAttributedString.addAttributes(detection.style.highlightedAttributes,
////                                                         range: NSRange(detection.range, in: attributedText.string))
////                updateAttributedTextInTextView(higlightedAttributedString)
////            } else {
////                if internalState.isEnabled {
////                    updateAttributedTextInTextView(attributedText.attributedString)
////                } else {
////                    updateAttributedTextInTextView(attributedText.disabledAttributedString)
////                }
////            }
////        } else {
////            textView.attributedText = nil
////        }
//        //accessibleElements = nil
//    }
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
// }
//
#endif
