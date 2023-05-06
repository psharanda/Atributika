//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

    import UIKit

    extension NSLayoutManager {
        func enclosingRects(in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> [CGRect] {
            var lineRects = [CGRect]()
            enumerateLineFragments(
                forGlyphRange: glyphRange)
            { _, usedRect, _, _, _ in
                lineRects.append(usedRect)
            }

            var enclosingRects = [CGRect]()
            enumerateEnclosingRects(
                forGlyphRange: glyphRange,
                withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                in: textContainer
            ) { rect, _ in
                enclosingRects.append(rect)
            }

            var result = [CGRect]()
            for lineRect in lineRects {
                var enclosingRectForLine = lineRect

                for enclosingRect in enclosingRects {
                    if enclosingRect.intersects(lineRect) {
                        enclosingRectForLine = enclosingRectForLine.intersection(enclosingRect)
                    }
                }
                result.append(enclosingRectForLine)
            }
            return result
        }
    }

#endif
