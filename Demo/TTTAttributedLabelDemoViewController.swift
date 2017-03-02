//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import UIKit
import Atributika


class TTTAttributedLabelDemoViewController: UIViewController {
    
    fileprivate var snippets = allSnippets()
    
    let label = TTTAttributedLabel(frame: CGRect())
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "TTTAttributedLabelDemo"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        let all = Style.foregroundColor(.gray).font(.systemFont(ofSize: 16))
        let link = Style("a").foregroundColor(.blue)
        let activeLink = Style.foregroundColor(.brown)
        
        label.activeLinkAttributes = activeLink.attributes
        label.numberOfLines = 0
        label.delegate = self
        
        let aka = "If only Bradley's arm was longer. Best photo ever. #oscars <a href=\"https://pic.twitter.com/C9U5NOtGap\">pic.twitter.com/C9U5NOtGap</a>".style(tags: link)
            .styleAll(all)
            .styleHashtags(link)
        
        aka.detections.forEach { detection in
            switch detection.type {
            case .hashtag:
                let startIndex = aka.string.index(aka.string.startIndex, offsetBy: detection.range.lowerBound + 1)
                let endIndex = aka.string.index(aka.string.startIndex, offsetBy: detection.range.lowerBound + detection.range.count - 1)
                
                let hashtag = (aka.string[startIndex...endIndex])
                label.addLink(to: URL(string: "https://twitter.com/hashtag/\(hashtag)"), with: NSRange(detection.range))
            case .tag(let tag):
                if tag.name == "a", let href = tag.attributes["href"] {
                    label.addLink(to: URL(string: href), with: NSRange(detection.range))
                }
            default:
                break
            }
        }
        
        label.attributedText = aka.attributedString
        
        view.addSubview(label)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = view.bounds.insetBy(dx: 20, dy: 64)
    }
}

extension TTTAttributedLabelDemoViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}
