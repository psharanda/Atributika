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
            { _, usedRect, textContainer, _, _ in
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

            if lineRects.count == enclosingRects.count {
                return zip(lineRects, enclosingRects).map { $0.0.intersection($0.1) }
            } else {
                return enclosingRects
            }
        }
    }

#endif
