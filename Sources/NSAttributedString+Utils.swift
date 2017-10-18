//
//  Created by Pavel Sharanda on 21.02.17.
//  Copyright © 2017 psharanda. All rights reserved.
//

import Foundation

public func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let s = NSMutableAttributedString(attributedString: lhs)
    s.append(rhs)
    return s
}

public func + (lhs: String, rhs: NSAttributedString) -> NSAttributedString {
    let s = NSMutableAttributedString(string: lhs)
    s.append(rhs)
    return s
}

public func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
    let s = NSMutableAttributedString(attributedString: lhs)
    s.append(NSAttributedString(string: rhs))
    return s
}



