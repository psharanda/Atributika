//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import UIKit
import Atributika


class AttributedLabelDemoViewController: UIViewController {
    
    let tweetLabel = AttributedLabel()
    
    let tosLabel = AttributedLabel()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "AttributedTextDemo"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let all = Style.font(.systemFont(ofSize: 16))
        let link = Style("a")
            .foregroundColor(.blue, .normal)
            .foregroundColor(.brown, .highlighted)
        let i = Style("i").font(.italicSystemFont(ofSize: 16))
        
        tweetLabel.numberOfLines = 0
        tweetLabel.attributedText = "@potus If only <i>Bradley's</i> arm was longer. Best photo ever. #oscars <a href=\"https://pic.twitter.com/C9U5NOtGap\">pic.twitter.com/C9U5NOtGap</a>"
            .style(tags: link, i)
            .styleAll(all)
            .styleHashtags(link)
            .styleMentions(link)
        
        tweetLabel.onClick = { label, detection in
            switch detection.type {
            case .hashtag(let tag):
                if let url = URL(string: "https://twitter.com/hashtag/\(tag)") {
                    UIApplication.shared.openURL(url)
                }
            case .mention(let name):
                if let url = URL(string: "https://twitter.com/\(name)") {
                    UIApplication.shared.openURL(url)
                }
            case .tag(let tag):
                if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                    UIApplication.shared.openURL(url)
                }
            default:
                break
            }
        }
        
        view.addSubview(tweetLabel)
        
        addTosLabel()
    }
    
    private func addTosLabel() {
        let link = Style
            .font(.boldSystemFont(ofSize: 14))
            .foregroundColor(.black)
            .foregroundColor(.red, .highlighted)
        
        let tos = link.named("tos")
        let pp = link.named("pp")
        
        let all = Style
            .font(.systemFont(ofSize: 14))
            .foregroundColor(.gray)
        
        let text = "<tos>Terms of Service</tos> and <pp>Privacy Policy</pp>"
            .style(tags: tos, pp)
            .styleAll(all)
        
        tosLabel.textAlignment = .center
        tosLabel.attributedText = text
        
        tosLabel.onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                switch tag.name {
                case "pp":
                    print("Privacy Policy clicked")
                case "tos":
                    print("Terms of Service clicked")
                default:
                    break
                }
            default:
                break
            }
        }
        
        view.addSubview(tosLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tweetLabel.frame = view.bounds.insetBy(dx: 20, dy: 64)
        tosLabel.frame = CGRect(x: 10, y: view.bounds.height - 100, width: view.bounds.width - 20, height: 40)
    }
}
