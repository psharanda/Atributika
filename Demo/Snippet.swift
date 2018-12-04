//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit
import Atributika

func stringWithAtributikaLogo() -> NSAttributedString {
    
    let redColor = UIColor(red:(0xD0 / 255.0), green: (0x02 / 255.0), blue:(0x1B / 255.0), alpha:1.0)
    let a = Style("a").foregroundColor(redColor)
    
    let font = UIFont(name: "AvenirNext-Regular", size: 24)!
    let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
    let all = Style.font(font).foregroundColor(grayColor)
    
    let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>".style(tags: a)
        .styleAll(all)
        .attributedString
    return str
}

func stringWithTagsAndEmoji() -> NSAttributedString {
    let b = Style("b").font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
    let all = Style.font(.systemFont(ofSize: 20))
    let str = "Hello <b>W🌎rld</b>!!!".style(tags: b)
        .styleAll(all)
        .attributedString
    return str
}

func stringWithHashTagAndMention() -> NSAttributedString {
    
    let str = "#Hello @World!!!"
        .styleHashtags(Style.font(.boldSystemFont(ofSize: 45)))
        .styleMentions(Style.foregroundColor(.red))
        .attributedString
    return str
}

func stringWithPhone() -> NSAttributedString {
    let str = "Call me (888)555-5512"
        .stylePhoneNumbers(Style.foregroundColor(.red))
        .attributedString
    return str
}

func stringWithLink() -> NSAttributedString {
    let str = "Check this http://google.com"
        .styleLinks(Style.foregroundColor(.blue))
        .attributedString
    return str
}

func stringWithManyDetectables() -> NSAttributedString {
    
    let links = Style.foregroundColor(.blue)
    let phoneNumbers = Style.backgroundColor(.yellow)
    let mentions = Style.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black)
    let b = Style("b").font(.boldSystemFont(ofSize: 12))
    
    #if swift(>=4.2)
    let u = Style("u").underlineStyle(.single)
    #else
    let u = Style("u").underlineStyle(.styleSingle)
    #endif
    
    
    let all = Style.font(.systemFont(ofSize: 12)).foregroundColor(.gray)
    
    let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to know more (123)456-7890 #swift #nsattributedstring https://github.com/psharanda/Atributika"
        .style(tags: u, b)
        .styleMentions(mentions)
        .styleHashtags(links)
        .styleLinks(links)
        .stylePhoneNumbers(phoneNumbers)
        .styleAll(all)
        .attributedString
    
    return str
}

func stringWith3Tags() -> NSAttributedString {
    
    let str = "<r>first</r><g>sec⚽️nd</g><b>third</b>".style(tags:
        Style("r").foregroundColor(.red),
                                                            Style("g").foregroundColor(.green),
                                                            Style("b").foregroundColor(.blue)).attributedString
    return str
}

func stringWithGrams() -> NSAttributedString {
    
    let calculatedCoffee: Int = 768
    let g = Style("g").font(.boldSystemFont(ofSize: 12)).foregroundColor(.red)
    let all = Style.font(.systemFont(ofSize: 12))
    
    let str = "\(calculatedCoffee)<g>g</g>".style(tags: g)
        .styleAll(all)
        .attributedString
    
    return str
}

func stringWithStrong() -> NSAttributedString {
    let str = "<strong>Nice</strong> try, Phil".style(tags:
        Style("strong").font(.boldSystemFont(ofSize: 15)))
        .attributedString
    
    return str
}

func stringWithTagAndHashtag() -> NSAttributedString {
    
    let str = "<b>Hello</b> #World"
    let data = str.data(using: .utf8)
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
    
    let htmlAttrString = try! NSAttributedString(data: data!, options: options, documentAttributes: nil)
    let result = htmlAttrString.styleHashtags(Style.foregroundColor(.blue)).attributedString
    return result
}

func stringWithUnorderedList() -> NSAttributedString {
    
    let transformers: [TagTransformer] = [
        TagTransformer.brTransformer,
        TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
        TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
    ]
    
    let li = Style("li").font(.systemFont(ofSize: 12)).foregroundColor(.red)
    
    return "TODO:<br><li>veni</li><li>vidi</li><li>vici</li>"
        .style(tags: li, transformers: transformers)
        .styleAll(Style.font(.boldSystemFont(ofSize: 14)))
        .attributedString
}

func stringWithHref() -> NSAttributedString {
    return "Hey\r\n<a style=\"text-decoration:none\" href=\"http://www.google.com\">Hello\r\nWorld</a>s".style(tags:
        Style("a").font(.boldSystemFont(ofSize: 45)).foregroundColor(.red)
        ).attributedString
}

func stringWithBoldItalicUnderline() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!
    #if swift(>=4.2)
    let uib = Style("uib").font(font).underlineStyle(.single)
    #else
    let uib = Style("uib").font(font).underlineStyle(.styleSingle)
    #endif
    
    let str = "<br><uib>Italicunderline</uib>".style(tags: uib)
        .attributedString
    return str
}

func stringWithImage() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!
    
    #if swift(>=4.2)
    let uib = Style("b").font(font).underlineStyle(.single)
    #else
    let uib = Style("b").font(font).underlineStyle(.styleSingle)
    #endif
    let str = "<b>Running</b> with <img id=\"scissors\"></img>!".style(tags: uib)
    
    let mutableAttrStr = NSMutableAttributedString(attributedString: str.attributedString)
    
    var locationShift = 0
    for detection in str.detections {
        switch detection.type {
        case .tag(let tag):
            if let imageId =  tag.attributes["id"] {
                let textAttachment = NSTextAttachment()
                textAttachment.image = UIImage(named: imageId)
                let imageAttrStr = NSAttributedString(attachment: textAttachment)
                let nsrange = NSRange.init(detection.range, in: mutableAttrStr.string)
                mutableAttrStr.insert(imageAttrStr, at: nsrange.location + locationShift)
                locationShift += 1
            }
        default:
            break
        }
    }

    return mutableAttrStr
}

func stringWithStrikethrough() -> NSAttributedString {
    let all = Style.font(.systemFont(ofSize: 20))
    #if swift(>=4.2)
    let strike = Style("strike").strikethroughStyle(.single).strikethroughColor(.black)
    #else
    let strike = Style("strike").strikethroughStyle(.styleSingle).strikethroughColor(.black)
    #endif
    
    let code = Style("code").foregroundColor(.red)
    
    let str = "<code>my code</code> <strike>test</strike> testing"
        .style(tags: [strike,code])
        .styleAll(all)
        .attributedString
    return str
}

func allSnippets() -> [NSAttributedString] {
    return [
        stringWithAtributikaLogo(),
        stringWithTagsAndEmoji(),
        stringWithHashTagAndMention(),
        stringWithPhone(),
        stringWithLink(),
        stringWithManyDetectables(),
        stringWith3Tags(),
        stringWithGrams(),
        stringWithStrong(),
        stringWithTagAndHashtag(),
        stringWithUnorderedList(),
        stringWithHref(),
        stringWithBoldItalicUnderline(),
        stringWithImage(),
        stringWithStrikethrough()
    ]
}

