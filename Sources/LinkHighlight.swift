//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    public protocol LinkHighlightViewProtocol {
        func didAdd(to textView: BaseAttributedTextView)
        func removeFrom(textView: BaseAttributedTextView)
    }

    public protocol LinkHighlightViewFactoryProtocol {
        func createView(enclosingRects: [CGRect]) -> UIView & LinkHighlightViewProtocol
    }

    public struct RoundedRectLinkHighlightViewFactory: LinkHighlightViewFactoryProtocol {
        private class HighlightView: UIView, LinkHighlightViewProtocol {
            private let enableAnimations: Bool

            init(enableAnimations: Bool) {
                self.enableAnimations = enableAnimations
                super.init(frame: .zero)
            }

            @available(*, unavailable)
            required init?(coder _: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            func didAdd(to _: Atributika.BaseAttributedTextView) {
                if enableAnimations {
                    alpha = 0
                    UIView.animate(withDuration: 0.2) {
                        self.alpha = 1
                    }
                }
            }

            func removeFrom(textView _: Atributika.BaseAttributedTextView) {
                if enableAnimations {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState]) {
                        self.alpha = 0
                    } completion: { _ in
                        self.removeFromSuperview()
                    }
                } else {
                    removeFromSuperview()
                }
            }
        }

        public var fillColor: UIColor = UIColor.black.withAlphaComponent(0.15)
        public var cornerRadius: CGFloat = 2
        public var inset: CGSize = .init(width: 2, height: 2)
        public var enableAnimations = true

        public init() {}

        public func createView(enclosingRects: [CGRect]) -> UIView & LinkHighlightViewProtocol {
            let view = HighlightView(enableAnimations: enableAnimations)
            view.isUserInteractionEnabled = false

            let path = UIBezierPath()

            enclosingRects.forEach { rect in
                path.append(UIBezierPath(roundedRect: rect.insetBy(dx: -inset.width, dy: -inset.height), cornerRadius: cornerRadius))
            }

            let layer = CAShapeLayer()
            layer.fillColor = fillColor.cgColor
            layer.path = path.cgPath

            view.layer.addSublayer(layer)

            return view
        }
    }

#endif
