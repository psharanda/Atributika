//
//  Created by Pavel Sharanda on 18.10.17.
//  Copyright © 2017 Atributika. All rights reserved.
//
import Foundation

#if os(iOS)

import UIKit

@IBDesignable open class AttributedLabel: UIView {

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        let gray = Style("gray").foregroundColor(.gray)
        attributedText = "<gray>Attributed</gray>Label"
            .style(tags: gray)
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - private properties
    private let textView = UITextView()
    private var detectionAreaButtons = [DetectionAreaButton]()
    
    //MARK: - public properties
    open var onClick: ((AttributedLabel, Detection)->Void)?

    open func rects(for detection: Detection) -> [CGRect] {
        var result = [CGRect]()

        if let attributedText = state.attributedText {
            let nsrange = NSRange(detection.range, in: attributedText.string)
            textView.layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textView.textContainer, using: { (rect, stop) in
                result.append(rect)
            })
        }

        return result
    }
    
    @IBInspectable open var isEnabled: Bool {
        set {
            detectionAreaButtons.forEach { $0.isUserInteractionEnabled = newValue  }
            state.isEnabled = newValue
        }
        get {
            return state.isEnabled
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
    
    open var attributedText: AttributedText? {
        set {
            state = State(attributedText: newValue, isEnabled: state.isEnabled, detection: nil)
            setNeedsLayout()
        }
        get {
            return state.attributedText
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
    
    //MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(textView)
        
        lineBreakMode = .byTruncatingTail
        numberOfLines = 1

        textView.isUserInteractionEnabled = false
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = .zero;
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
    
    //MARK: - overrides
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        detectionAreaButtons.forEach {
            $0.removeFromSuperview()
        }
        
        detectionAreaButtons.removeAll()
        
        if let attributedText = state.attributedText {
            
            let highlightableDetections = attributedText.detections.filter { $0.style.typedAttributes[.highlighted] != nil }
            
            highlightableDetections.forEach { detection in
                let nsrange = NSRange(detection.range, in: attributedText.string)
                textView.layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textView.textContainer, using: { (rect, stop) in
                    self.addDetectionAreaButton(frame: rect, detection: detection, text: String(attributedText.string[detection.range]))
                })
            }
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return textView.sizeThatFits(size)
    }
    
    open override var forFirstBaselineLayout: UIView {
        return textView
    }
    
    open override var forLastBaselineLayout: UIView {
        return textView
    }
    
    //MARK: - DetectionAreaButton
    private class DetectionAreaButton: UIButton {
        
        var onHighlightChanged: ((DetectionAreaButton)->Void)?
        
        let detection: Detection
        init(detection: Detection) {
            self.detection = detection
            super.init(frame: .zero)
            self.isExclusiveTouch = true
        }
        
        override var isHighlighted: Bool {
            didSet {
                if (isHighlighted && isTracking) || !isHighlighted {
                    onHighlightChanged?(self)
                }
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private func addDetectionAreaButton(frame: CGRect, detection: Detection, text: String) {
        let button = DetectionAreaButton(detection: detection)
        button.accessibilityLabel = text
        button.isAccessibilityElement = true
        #if swift(>=4.2)
        button.accessibilityTraits = UIAccessibilityTraits.button
        #else
        button.accessibilityTraits = UIAccessibilityTraitButton
        #endif
        
        button.isUserInteractionEnabled = state.isEnabled
        button.addTarget(self, action: #selector(handleDetectionAreaButtonClick), for: .touchUpInside)
        detectionAreaButtons.append(button)
        
        button.onHighlightChanged = { [weak self] in
            self?.state.detection = $0.isHighlighted ? $0.detection : nil
        }
        
        addSubview(button)
        button.frame = frame
    }
    
    @objc private func handleDetectionAreaButtonClick(_ sender: DetectionAreaButton) {
        onClick?(self, sender.detection)
    }
    
    //MARK: - state
    
    private struct State {
        var attributedText: AttributedText?
        var isEnabled: Bool
        var detection: Detection?
    }
    
    private var state: State = State(attributedText: nil, isEnabled: true, detection: nil) {
        didSet {
            updateText()
        }
    }
    
    private func updateAttributedTextInTextView(_ string: NSAttributedString) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        var inheritedAttributes = [AttributedStringKey.font: font as Any,
                                   AttributedStringKey.paragraphStyle: paragraphStyle as Any,
                                   AttributedStringKey.foregroundColor: textColor]
        
        if let shadowColor = shadowColor {
            let shadow = NSShadow()
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = shadowOffset
            shadow.shadowBlurRadius = shadowBlurRadius
            inheritedAttributes[AttributedStringKey.shadow] = shadow
        }
        
        let length = string.length
        let result = NSMutableAttributedString(string: string.string, attributes: inheritedAttributes)
        
        result.beginEditing()
        
        string.enumerateAttributes(in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            result.addAttributes(attributes, range: range)
        })
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
        if let attributedText = state.attributedText {
            
            if let detection = state.detection {
                let higlightedAttributedString = NSMutableAttributedString(attributedString: attributedText.attributedString)
                higlightedAttributedString.addAttributes(detection.style.highlightedAttributes, range: NSRange(detection.range, in: attributedText.string))
                updateAttributedTextInTextView(higlightedAttributedString)
            } else {
                if state.isEnabled {
                    updateAttributedTextInTextView(attributedText.attributedString)
                } else {
                    updateAttributedTextInTextView(attributedText.disabledAttributedString)
                }
            }
        } else {
            textView.attributedText = nil
        }
    }
}

#endif
