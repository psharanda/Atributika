//
//  Created by Pavel Sharanda on 21.02.17.
//  Copyright © 2017 Atributika. All rights reserved.
//

import UIKit
import Atributika

class ViewController: UIViewController {

    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        label.numberOfLines = 0
        label.attributedText =  test4()
        
        view.addSubview(label)
    }
    
    func test1() -> NSAttributedString {
        let str = "Hello <b>World</b>!!!".styled(tags: Style("b").font(.boldSystemFont(ofSize: 15)))
            .styled(Style.font(.systemFont(ofSize: 12)))
            .attributedString
        return str
    }
    
    func test2() -> NSAttributedString {
        
        let str = "#Hello @World!!!"
            .styledHashtags(Style.font(.boldSystemFont(ofSize: 45)))
            .styledMentions(Style.foregroundColor(.red))
            .attributedString
        return str
    }
    
    func test3() -> NSAttributedString {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        let str = "Call me (888)555-5512".styled(textCheckingTypes: types.rawValue, style:
            Style.foregroundColor(.red)
            ).attributedString
        return str
    }
    
    func test4() -> NSAttributedString {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        
        let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to ask any details (123)456-7890 #swift #nsattributedstring"
            .styled(tags:
                Style("u").font(.boldSystemFont(ofSize: 12)).underlineStyle(.styleSingle),
                Style("b").font(.boldSystemFont(ofSize: 12))
            )
            .styled(Style.font(.systemFont(ofSize: 12)).foregroundColor(.gray))
            .styledMentions(Style.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black))
            .styledHashtags(Style.foregroundColor(.blue))
            .styled(textCheckingTypes: types.rawValue, style: Style.backgroundColor(.yellow))
            .attributedString

        return str
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = view.bounds.insetBy(dx: 20, dy: 100)
    }
}

