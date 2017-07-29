//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit
import Atributika

func test0() -> NSAttributedString {
    
    let font = UIFont(name: "AvenirNext-Regular", size: 24)!
    
    let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
    let redColor = UIColor(red:(0xD0 / 255.0), green: (0x02 / 255.0), blue:(0x1B / 255.0), alpha:1.0)
    
    let a = Style("a").foregroundColor(redColor)
    
    let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>".style(tags: a)
        .styleAll(Style.font(font).foregroundColor(grayColor))
        .attributedString
    return str
}

func test1() -> NSAttributedString {
    let b = Style("b").font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
    let str = "Hello <b>World</b>!!!".style(tags: b)
        .styleAll(Style.font(.systemFont(ofSize: 20)))
        .attributedString
    return str
}

func test2() -> NSAttributedString {
    
    let str = "#Hello @World!!!"
        .styleHashtags(Style.font(.boldSystemFont(ofSize: 45)))
        .styleMentions(Style.foregroundColor(.red))
        .attributedString
    return str
}

func test3() -> NSAttributedString {
    let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
    let str = "Call me (888)555-5512".style(textCheckingTypes: types.rawValue, style:
        Style.foregroundColor(.red)
        ).attributedString
    return str
}

func test4() -> NSAttributedString {
    let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
    
    let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to ask any details (123)456-7890 #swift #nsattributedstring"
        .style(tags:
            Style("u").font(.boldSystemFont(ofSize: 12)).underlineStyle(.styleSingle),
               Style("b").font(.boldSystemFont(ofSize: 12))
        )
        .styleAll(Style.font(.systemFont(ofSize: 12)).foregroundColor(.gray))
        .styleMentions(Style.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black))
        .styleHashtags(Style.foregroundColor(.blue))
        .style(textCheckingTypes: types.rawValue, style: Style.backgroundColor(.yellow))
        .attributedString
    
    return str
}

func test5() -> NSAttributedString {
    
    let str = "<r>first</r><g>second</g><b>third</b>".style(tags:
        Style("r").foregroundColor(.red),
                                                            Style("g").foregroundColor(.green),
                                                            Style("b").foregroundColor(.blue)).attributedString
    return str
}

func test6() -> NSAttributedString {
    
    let calculatedCoffee: Int = 768
    let g = Style("g").font(.boldSystemFont(ofSize: 12)).foregroundColor(.red)
    let all = Style.font(.systemFont(ofSize: 12))
    
    let str = "\(calculatedCoffee)<g>g</g>".style(tags: g)
        .styleAll(all)
        .attributedString
    
    return str
}

func test7() -> NSAttributedString {
    let str = "<strong>Nice</strong> try, Phil".style(tags:
        Style("strong").font(.boldSystemFont(ofSize: 15)))
        .attributedString
    
    return str
}

func test8() -> NSAttributedString {
    
    // Makes <div> fill completely, without just the text gets colored
    let divStyle = NSMutableParagraphStyle()
    divStyle.headIndent = 1
    
    let blueBoxColor = UIColor.init(colorLiteralRed: (233/255.0), green: (242/255.0), blue: (246/255.0), alpha: 1.0)

    let str = "<div>Testing prepend, and style\n<ul><li>list item 1</li>\n<li>list item 2</li>\n<li>list item 3</li>\n<li>list item 4</li>\n<li>list item 5</li>\n</ul>\n<ul></div>"
        .style(tags: [
            Style("div").backgroundColor(blueBoxColor).paragraphStyle(divStyle),
            Mutation("li").prepend("\t😀\t")
        ])
        .attributedString
    
    return str
}

func test9() -> NSAttributedString {
    
    let str = "<div>Testing append\n<ul><li>list item 1</li><li>list item 2</li><li>list item 3</li><li>list item 4</li><li>list item 5</li></ul></div>"
        .style(tags: [
            Mutation("li").append(" - 😀\n")
        ])
        .attributedString
    
    return str
}

func test10() -> NSAttributedString {
    
    let str = "<div>Testing replace\n<ul><li>list item 1</li><li>list item 2</li><li>list item 3</li><li>list item 4</li><li>list item 5</li></ul></div>"
        .style(tags: [
            Mutation("li").replace("\t●\tCustom Text\n")
            ])
        .attributedString
    
    return str
}

func allSnippets() -> [NSAttributedString] {
    return [
        test0(),
        test1(),
        test2(),
        test3(),
        test4(),
        test5(),
        test6(),
        test7(),
        test8(),
        test9(),
        test10()
    ]
}
