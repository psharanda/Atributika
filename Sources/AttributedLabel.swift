//
//  Created by Pavel Sharanda on 18.10.17.
//  Copyright © 2017 Atributika. All rights reserved.
//
import Foundation

#if os(iOS) || os(tvOS)
    
import UIKit

public class AttributedLabel: UIView {
    
    //MARK: - private properties
    private let label = UILabel()
    private var detectionAreaButtons = [DetectionAreaButton]()
    
    //MARK: - public properties
    public var onClick: ((AttributedLabel, Detection)->Void)?
    
    public var isEnabled: Bool {
        set {
            detectionAreaButtons.forEach { $0.isUserInteractionEnabled = newValue  }
            state.isEnabled = newValue
        }
        get {
            return state.isEnabled
        }
    }
    
    public var attributedText: AttributedText? {
        set {
            state.attributedTextAndString = newValue.map { ($0, $0.attributedString) }
            setNeedsLayout()
        }
        get {
            return state.attributedTextAndString?.0
        }
    }
    
    //MARK: - public properties redirected to underlying UILabel
    public var font: UIFont {
        set { label.font = newValue }
        get { return label.font }
    }
    
    public var numberOfLines: Int {
        set { label.numberOfLines = newValue }
        get { return label.numberOfLines }
    }
    
    public var textAlignment: NSTextAlignment {
        set { label.textAlignment = newValue }
        get { return label.textAlignment }
    }
    
    public var lineBreakMode: NSLineBreakMode {
        set { label.lineBreakMode = newValue }
        get { return label.lineBreakMode }
    }
    
    public var textColor: UIColor {
        set { label.textColor = newValue }
        get { return label.textColor }
    }
    
    public var shadowColor: UIColor? {
        set { label.shadowColor = newValue }
        get { return label.shadowColor }
    }
    
    public var shadowOffset: CGSize {
        set { label.shadowOffset = newValue }
        get { return label.shadowOffset }
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
        addSubview(label)
    }
    
    //MARK: - overrides
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
        
        detectionAreaButtons.forEach {
            $0.removeFromSuperview()
        }
        
        detectionAreaButtons.removeAll()
        
        if let (text, string) = state.attributedTextAndString {
            
            let inheritedString = string.withInherited(font: font, textAlignment: textAlignment)
            
            let textContainer = NSTextContainer(size: bounds.size)
            textContainer.lineBreakMode = lineBreakMode
            textContainer.maximumNumberOfLines = numberOfLines
            textContainer.lineFragmentPadding = 0
            
            let textStorage = NSTextStorage(attributedString: inheritedString)
            
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            
            textStorage.addLayoutManager(layoutManager)
            
            let highlightableDetections = text.detections.filter { $0.style.typedAttributes[.highlighted] != nil }
            
            let usedRect = layoutManager.usedRect(for: textContainer)
            let dy = max(0, (bounds.height - usedRect.height)/2)
            highlightableDetections.forEach { detection in
                let nsrange = NSRange(detection.range, in: inheritedString.string)
                layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textContainer, using: { (rect, stop) in
                    var finalRect = rect
                    finalRect.origin.y += dy
                    self.addDetectionAreaButton(frame: finalRect, detection: detection)
                })
            }
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return label.sizeThatFits(size)
    }

    //MARK: - DetectionAreaButton
    private class DetectionAreaButton: UIControl {
        
        var onHighlightChanged: ((DetectionAreaButton)->Void)?
        
        let detection: Detection
        init(detection: Detection) {
            self.detection = detection
            super.init(frame: .zero)
            self.isExclusiveTouch = true
        }
        
        override var isHighlighted: Bool {
            didSet {
                onHighlightChanged?(self)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private func addDetectionAreaButton(frame: CGRect, detection: Detection) {
        let button = DetectionAreaButton(detection: detection)
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
        var attributedTextAndString: (AttributedText, NSAttributedString)?
        var isEnabled: Bool
        var detection: Detection?
    }
    
    private var state: State = State(attributedTextAndString: nil, isEnabled: true, detection: nil) {
        didSet {
            updateLabel()
        }
    }
    
    private func updateLabel() {
        if let (text, string) = state.attributedTextAndString {
            
            if let detection = state.detection {
                let higlightedAttributedString = NSMutableAttributedString(attributedString: string)
                higlightedAttributedString.addAttributes(detection.style.highlightedAttributes, range: NSRange(detection.range, in: string.string))
                label.attributedText = higlightedAttributedString
            } else {
                if state.isEnabled {
                    label.attributedText = string
                } else {
                    label.attributedText = text.disabledAttributedString
                }
            }
        } else {
            label.attributedText = nil
        }
    }
}

extension NSAttributedString {
    
    func withInherited(font: UIFont, textAlignment: NSTextAlignment) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        let inheritedAttributes = [NSFontAttributeName: font as Any, NSParagraphStyleAttributeName: paragraphStyle as Any]
        let result = NSMutableAttributedString(string: string, attributes: inheritedAttributes)
        
        result.beginEditing()
        enumerateAttributes(in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            result.addAttributes(attributes, range: range)
        })
        result.endEditing()
        
        return result
    }
}

#endif
