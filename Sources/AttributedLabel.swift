//
//  Created by Pavel Sharanda on 18.10.17.
//  Copyright © 2017 Atributika. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
import UIKit

public class AttributedLabel: UIView {
    
    private let label = UILabel()
    private var clickButtons = [ClickButton]()
    
    public var onClick: ((AttributedLabel, Detection)->Void)?
    
    public var isEnabled: Bool = true {
        didSet {
            clickButtons.forEach { $0.isUserInteractionEnabled = isEnabled  }
            update()
        }
    }
    
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
    
    public var attributedText: AttributedText? {
        didSet {
            label.attributedText = attributedText?.attributedString
            setNeedsLayout()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
        
        clickButtons.forEach {
            $0.removeFromSuperview()
        }
        
        clickButtons.removeAll()
        
        if let attributedText = attributedText  {
            
            let attributedTextString = fixedAttributedText(string: attributedText.attributedString)
            
            let textContainer = NSTextContainer(size: bounds.size)
            textContainer.lineBreakMode = lineBreakMode
            textContainer.maximumNumberOfLines = numberOfLines
            textContainer.lineFragmentPadding = 0
            
            let textStorage = NSTextStorage(attributedString: attributedTextString)
            
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            
            textStorage.addLayoutManager(layoutManager)
            
            let highlightableDetections = attributedText.detections.filter { $0.style.typedAttributes[.highlighted] != nil }
            
            let usedRect = layoutManager.usedRect(for: textContainer)
            let dy = max(0, (bounds.height - usedRect.height)/2)
            highlightableDetections.forEach { detection in
                let nsrange = NSRange(detection.range, in: attributedTextString.string)
                layoutManager.enumerateEnclosingRects(forGlyphRange: nsrange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textContainer, using: { (rect, stop) in
                    var finalRect = rect
                    finalRect.origin.y += dy
                    self.addClickButton(frame: finalRect, detection: detection)
                })
            }
        }
    }
    
    private class ClickButton: UIControl {
        
        var onChangeIsHighlighted: ((ClickButton)->Void)?
        
        let detection: Detection
        init(detection: Detection) {
            self.detection = detection
            super.init(frame: .zero)
        }
        
        override var isHighlighted: Bool {
            didSet {
                onChangeIsHighlighted?(self)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private func addClickButton(frame: CGRect, detection: Detection) {
        let button = ClickButton(detection: detection)
        button.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        clickButtons.append(button)
        
        button.onChangeIsHighlighted = { [weak self] in
            self?.update(isHighlighted: $0.isHighlighted, detection: $0.detection)
        }
        
        addSubview(button)
        button.frame = frame
    }
    
    private func update(isHighlighted: Bool, detection: Detection) {
        if isHighlighted {
            if let attributedString = attributedText?.attributedString {
                let mutAttributedString = NSMutableAttributedString(attributedString: attributedString)
                mutAttributedString.addAttributes(detection.style.highlightedAttributes, range: NSRange(detection.range, in: attributedString.string))
                label.attributedText = mutAttributedString
            }
        } else {
            update()
        }
    }
    
    private func update() {
        if isEnabled {
            label.attributedText = attributedText?.attributedString
        } else {
            label.attributedText = attributedText?.disabledAttributedString
        }
    }
    
    @objc private func handleClick(_ sender: ClickButton) {
        onClick?(self, sender.detection)
    }
    
    private func fixedAttributedText(string: NSAttributedString) -> NSAttributedString {
        
        let ps = NSMutableParagraphStyle()
        ps.alignment = textAlignment
        
        let inheritedAttributes = [NSAttributedStringKey.font: font as Any, NSAttributedStringKey.paragraphStyle: ps as Any]
        let attributedTextWithFont = NSMutableAttributedString(string: string.string, attributes: inheritedAttributes)
        
        attributedTextWithFont.beginEditing()
        string.enumerateAttributes(in: NSMakeRange(0, string.length), options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            attributedTextWithFont.addAttributes(attributes, range: range)
        })
        attributedTextWithFont.endEditing()
        
        return attributedTextWithFont
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return label.sizeThatFits(size)
    }
}

#endif
