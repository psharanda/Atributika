//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    class RectsAccessibilityElement: UIAccessibilityElement {
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

                let unionRect = enclosingRects.reduce(enclosingRects[0]) {
                    $0.union($1)
                }

                return UIAccessibility.convertToScreenCoordinates(unionRect, in: view)
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

#endif
