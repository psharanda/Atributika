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
            private let touchDownAnimationDuration: CGFloat
            private let touchUpAnimationDuration: CGFloat
            init(enableAnimations: Bool, touchDownAnimationDuration: CGFloat, touchUpAnimationDuration: CGFloat) {
                self.enableAnimations = enableAnimations
                self.touchDownAnimationDuration = touchDownAnimationDuration
                self.touchUpAnimationDuration = touchUpAnimationDuration
                super.init(frame: .zero)
            }

            @available(*, unavailable)
            required init?(coder _: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            func didAdd(to _: BaseAttributedTextView) {
                if enableAnimations {
                    alpha = 0
                    UIView.animate(withDuration: touchDownAnimationDuration) {
                        self.alpha = 1
                    }
                }
            }

            func removeFrom(textView _: BaseAttributedTextView) {
                if enableAnimations {
                    UIView.animate(withDuration: touchUpAnimationDuration, delay: 0, options: [.beginFromCurrentState]) {
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
        public var touchDownAnimationDuration = 0.1
        public var touchUpAnimationDuration = 0.3

        public init() {}

        public func createView(enclosingRects: [CGRect]) -> UIView & LinkHighlightViewProtocol {
            let view = HighlightView(enableAnimations: enableAnimations,
                                     touchDownAnimationDuration: touchDownAnimationDuration,
                                     touchUpAnimationDuration: touchUpAnimationDuration)
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
