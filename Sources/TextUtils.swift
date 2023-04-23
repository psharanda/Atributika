//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

#if os(iOS)

import UIKit

extension NSLayoutManager {
    
    func enumerateUsedEnclosingRects(in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange, using block: @escaping (CGRect) -> Bool) {
        var lineRects = [CGRect]()
        enumerateLineFragments(
            forGlyphRange: glyphRange) { rect, usedRect, cont, range, stop in
                lineRects.append(usedRect)
            }
        
        var idx = 0
        enumerateEnclosingRects(
            forGlyphRange: glyphRange,
            withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
            in: textContainer
        ) { rect, stop in
            if block(rect.intersection(lineRects[idx])) {
                stop.pointee = true
            }
            idx += 1
        }
    }
}

#endif
