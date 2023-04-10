//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    @IBDesignable open class AttributedLabel: UIControl {
//
        // @IBDesignable open class AttributedLabel: UIControl {
//    open func setTextAttributes(for key: NSAttributedString.Key, _ attrs: [NSAttributedString.Key: Any], for state: UIControl.State) {
//
//    }
//
//    open override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//
//        let gray = Attrs.foregroundColor(.gray)
//        internalState.attributedText = "<gray>Attributed</gray>Label"
//            .style(tags: ["gray": gray])
//            .attributedString
//
//        invalidateIntrinsicContentSize()
//    }

        // MARK: - private properties

        private let textView = UITextView()
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
                return textView.isUserInteractionEnabled && textView.isSelectable
            }
            set {
                textView.isSelectable = newValue
                textView.isUserInteractionEnabled = newValue
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

        @IBInspectable open var font: UIFont? {
            get {
                return textView.font
            }
            set {
                textView.font = newValue
            }
        }

        @IBInspectable open var textAlignment: NSTextAlignment {
            get {
                return textView.textAlignment
            }
            set {
                textView.textAlignment = newValue
            }
        }

        @IBInspectable open var textColor: UIColor? {
            get {
                return textView.textColor
            }
            set {
                textView.textColor = newValue
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

        private struct AttributeHitInfo {}

        private func attributes(at _: CGPoint) -> [AttributeHitInfo] {
            var result: [AttributeHitInfo] = []

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
        }

        private var internalState: State = .init(attributedText: nil, isEnabled: true) {
            didSet {
                updateText()
            }
        }

        private func updateText() {
            if let attributedText = internalState.attributedText {
                textView.attributedText = attributedText
            } else {
                textView.attributedText = nil
            }
            // accessibleElements = nil
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

#endif
