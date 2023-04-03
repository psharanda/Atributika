//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit
import Atributika

func stringWithAtributikaLogo() -> NSAttributedString {
    
    let redColor = UIColor(red:(0xD0 / 255.0), green: (0x02 / 255.0), blue:(0x1B / 255.0), alpha:1.0)
    let a = Style().foregroundColor(redColor)
    
    let font = UIFont(name: "AvenirNext-Regular", size: 24)!
    let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
    let all = Style().font(font).foregroundColor(grayColor)
    
    let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>"
        .style(tags: ["a": a])
        .styleAll(all)
        .attributedString
    return str
}

func stringWithTagsAndEmoji() -> NSAttributedString {
    let b = Style().font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
    let all = Style().font(.systemFont(ofSize: 20))
    let str = "Hello <b>W🌎rld</b>!!!"
        .style(tags: ["b": b])
        .styleAll(all)
        .attributedString
    return str
}

func stringWithHashTagAndMention() -> NSAttributedString {
    
    let str = "#Hello @World!!!"
        .styleHashtags(Style().font(.boldSystemFont(ofSize: 45)))
        .styleMentions(Style().foregroundColor(.red))
        .attributedString
    return str
}

func stringWithPhone() -> NSAttributedString {
    let str = "Call me (888)555-5512"
        .stylePhoneNumbers(Style().foregroundColor(.red))
        .attributedString
    return str
}

func stringWithLink() -> NSAttributedString {
    let str = "Check this http://google.com"
        .styleLinks(Style().foregroundColor(.blue))
        .attributedString
    return str
}

func stringWithBoldItalic() -> NSAttributedString {
    
    let baseFont = UIFont.systemFont(ofSize: 12)
    let descriptor = baseFont.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold])
    let font = descriptor.map { UIFont(descriptor: $0, size: baseFont.pointSize) } ?? baseFont
    
    let a = Style().font(font).foregroundColor(.blue)
    let str = "<a href=\"https://en.wikipedia.org/wiki/World_of_Dance_(TV_series)\" target=\"_blank\">World of Dance</a>"
        .style(tags: ["a": a])
        .attributedString
    return str
}

func stringWithManyDetectables() -> NSAttributedString {
    
    let links = Style().foregroundColor(.blue)
    let phoneNumbers = Style().backgroundColor(.yellow)
    let mentions = Style().font(.italicSystemFont(ofSize: 12)).foregroundColor(.black)
    let b = Style().font(.boldSystemFont(ofSize: 12))
    
    #if swift(>=4.2)
    let u = Style().underlineStyle(.single)
    #else
    let u = Style().underlineStyle(.styleSingle)
    #endif
    
    
    let all = Style().font(.systemFont(ofSize: 12)).foregroundColor(.gray)
    
    let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to know more (123)456-7890 #swift #nsattributedstring https://github.com/psharanda/Atributika"
        .style(tags: ["u": u, "b": b])
        .styleMentions(mentions)
        .styleHashtags(links)
        .styleLinks(links)
        .stylePhoneNumbers(phoneNumbers)
        .styleAll(all)
        .attributedString
    
    return str
}

func stringWith3Tags() -> NSAttributedString {
    
    let str = "<r>first</r><g>sec⚽️nd</g><b>third</b>"
        .style(tags: [
            "r": Style().foregroundColor(.red),
            "g": Style().foregroundColor(.green),
            "b": Style().foregroundColor(.blue)
        ])
        .attributedString
    return str
}

func stringWithGrams() -> NSAttributedString {
    
    let calculatedCoffee: Int = 768
    let g = Style().font(.boldSystemFont(ofSize: 12)).foregroundColor(.red)
    let all = Style().font(.systemFont(ofSize: 12))
    
    let str = "\(calculatedCoffee)<g>g</g>"
        .style(tags: ["g": g])
        .styleAll(all)
        .attributedString
    
    return str
}

func stringWithStrong() -> NSAttributedString {
    let str = "<strong>Nice</strong> try, Phil"
        .style(tags: [
            "strong": Style().font(.boldSystemFont(ofSize: 15))
        ])
        .attributedString
    return str
}

func stringWithTagAndHashtag() -> NSAttributedString {
    
    let str = "<b>Hello</b> #World"
    let data = str.data(using: .utf8)
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,
                                                                       .characterEncoding: String.Encoding.utf8.rawValue]
    
    let htmlAttrString = try! NSAttributedString(data: data!, options: options, documentAttributes: nil)
    let result = htmlAttrString
        .styleHashtags(Style().foregroundColor(.blue))
        .attributedString
    return result
}

func stringWithUnorderedList() -> NSAttributedString {
    
    let transformers: [TagTransformer] = [
        TagTransformer.brTransformer,
        TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
        TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
    ]
    
    let li = Style().font(.systemFont(ofSize: 12)).foregroundColor(.red)
    
    return "TODO:<br><li>veni</li><li>vidi</li><li>vici</li>"
        .style(tags: ["li": li], transformers: transformers)
        .styleAll(Style().font(.boldSystemFont(ofSize: 14)))
        .attributedString
}

func stringWithOrderedList() -> NSAttributedString {
    var counter = 0
    let transformers: [TagTransformer] = [
        TagTransformer.brTransformer,
        TagTransformer(tagName: "ol", tagType: .start) { _ in
            counter = 0
            return ""
        },
        TagTransformer(tagName: "li", tagType: .start) { _ in
            counter += 1
            return "\(counter > 1 ? "\n" : "")\(counter). "
        }
    ]
    
    return "<ol><li>Coffee</li><li>Tea</li><li>Milk</li></ol>"
        .style(tags: [:], transformers: transformers)
        .attributedString
}

func stringWithHref() -> NSAttributedString {
    return "Hey\r\n<a style=\"text-decoration:none\" href=\"http://www.google.com\">Hello\r\nWorld</a>s"
        .style(tags: [
            "a": Style().font(.boldSystemFont(ofSize: 45)).foregroundColor(.red)
        ])
        .attributedString
}

func stringWithBoldItalicUnderline() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!
    #if swift(>=4.2)
    let uib = Style().font(font).underlineStyle(.single)
    #else
    let uib = Style().font(font).underlineStyle(.styleSingle)
    #endif
    
    let str = "<br><uib>Italicunderline</uib>"
        .style(tags: ["uib": uib])
        .attributedString
    return str
}

func stringWithImage() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!
    
    #if swift(>=4.2)
    let b = Style().font(font).underlineStyle(.single)
    #else
    let b = Style().font(font).underlineStyle(.styleSingle)
    #endif
    let str = "<b>Running</b> with <img id=\"scissors\"></img>!"
        .style(tags: ["b": b])
    
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
    let all = Style().font(.systemFont(ofSize: 20))
    #if swift(>=4.2)
    let strike = Style().strikethroughStyle(.single).strikethroughColor(.black)
    #else
    let strike = Style().strikethroughStyle(.styleSingle).strikethroughColor(.black)
    #endif
    
    let code = Style().foregroundColor(.red)
    
    let str = "<code>my code</code> <strike>test</strike> testing"
        .style(tags: ["strike": strike, "code": code])
        .styleAll(all)
        .attributedString
    return str
}

func stringWithColors() -> NSAttributedString {
    let r = Style().foregroundColor(.red)
    let g = Style().foregroundColor(.green)
    let b = Style().foregroundColor(.blue)
    let c = Style().foregroundColor(.cyan)
    let m = Style().foregroundColor(.magenta)
    let y = Style().foregroundColor(.yellow)
    
    let str = "<r>Hello <g>w<c>orld<m></g>; he<y>l</y></c>lo atributika</r></m>"
        .style(tags: ["r": r, "g": g, "b": b, "c": c, "m": m, "y": y])
        .attributedString
    return str
}

func stringWithParagraph() -> NSAttributedString {
    let p = Style().font(UIFont(name: "HelveticaNeue", size: 20)!)
    let strong = Style().font(UIFont(name: "Copperplate", size: 20)!)
    let str = "<p>some string... <strong> string</strong></p>"
        .style(tags: ["p": p, "strong": strong])
        .attributedString
    return str
}

func stringWithIndentedList() -> NSAttributedString {
    let bullet = "• "
    let transformers: [TagTransformer] = [
        TagTransformer.brTransformer,
        TagTransformer(tagName: "li", tagType: .start, replaceValue: bullet),
        TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
    ]

    let listItemFont = UIFont.systemFont(ofSize: 12)
    let indentation: CGFloat = (bullet as NSString).size(withAttributes: [NSAttributedString.Key.font: listItemFont]).width

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: [NSTextTab.OptionKey: Any]())]
    paragraphStyle.defaultTabInterval = indentation
    paragraphStyle.headIndent = indentation

    let li = Style()
        .font(listItemFont)
        .paragraphStyle(paragraphStyle)

    return "TODO:<br><li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li><li>Vestibulum ornare dui ut orci congue placerat. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li><li>Nunc et tortor vulputate, elementum quam at, tristique nibh. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li>"
        .style(tags: ["li": li], transformers: transformers)
        .styleAll(Style().font(.boldSystemFont(ofSize: 14)))
        .attributedString
}

func allSnippets() -> [NSAttributedString] {
    return [
        stringWithAtributikaLogo(),
        stringWithTagsAndEmoji(),
        stringWithHashTagAndMention(),
        stringWithPhone(),
        stringWithLink(),
        stringWithBoldItalic(),
        stringWithManyDetectables(),
        stringWith3Tags(),
        stringWithGrams(),
        stringWithStrong(),
        stringWithTagAndHashtag(),
        stringWithUnorderedList(),
        stringWithOrderedList(),
        stringWithHref(),
        stringWithBoldItalicUnderline(),
        stringWithImage(),
        stringWithStrikethrough(),
        stringWithColors(),
        stringWithParagraph(),
        stringWithIndentedList()
    ]
}

