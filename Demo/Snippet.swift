//
//  Created by Pavel Sharanda on 02.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Atributika
import Foundation
import UIKit

func stringWithAtributikaLogo() -> NSAttributedString {
    let redColor = UIColor(red: 0xD0 / 255.0, green: 0x02 / 255.0, blue: 0x1B / 255.0, alpha: 1.0)
    let a = Style.foregroundColor(redColor)

    let font = UIFont(name: "AvenirNext-Regular", size: 24)!
    let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
    let all = Style.font(font).foregroundColor(grayColor)

    let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>"
        .style(tags: ["a": a])
        .styleBase(all)
        .attributedString
    return str
}

func stringWithTagsAndEmoji() -> NSAttributedString {
    let b = Style.font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
    let all = Style.font(.systemFont(ofSize: 20))
    let str = "Hello <b>W🌎rld</b>!!!"
        .style(tags: ["b": b])
        .styleBase(all)
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

func stringWithBoldItalic() -> NSAttributedString {
    let baseFont = UIFont.systemFont(ofSize: 12)
    let descriptor = baseFont.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold])
    let font = descriptor.map { UIFont(descriptor: $0, size: baseFont.pointSize) } ?? baseFont

    let a = Style.font(font).foregroundColor(.blue)
    let str = "<a href=\"https://en.wikipedia.org/wiki/World_of_Dance_(TV_series)\" target=\"_blank\">World of Dance</a>"
        .style(tags: ["a": a])
        .attributedString
    return str
}

func stringWithManyDetectables() -> NSAttributedString {
    let links = Style.foregroundColor(.blue)
    let phoneNumbers = Style.backgroundColor(.yellow)
    let mentions = Style.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black)
    let b = Style.font(.boldSystemFont(ofSize: 12))

    #if swift(>=4.2)
        let u = Style.underlineStyle(.single)
    #else
        let u = Style.underlineStyle(.styleSingle)
    #endif

    let all = Style.font(.systemFont(ofSize: 12)).foregroundColor(.gray)

    let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to know more (123)456-7890 #swift #nsattributedstring https://github.com/psharanda/Atributika"
        .style(tags: ["u": u, "b": b])
        .styleMentions(mentions)
        .styleHashtags(links)
        .styleLinks(links)
        .stylePhoneNumbers(phoneNumbers)
        .styleBase(all)
        .attributedString

    return str
}

func stringWith3Tags() -> NSAttributedString {
    let str = "<r>first</r><g>sec⚽️nd</g><b>third</b>"
        .style(tags: [
            "r": Style.foregroundColor(.red),
            "g": Style.foregroundColor(.green),
            "b": Style.foregroundColor(.blue),
        ])
        .attributedString
    return str
}

func stringWithGrams() -> NSAttributedString {
    let calculatedCoffee = 768
    let g = Style.font(.boldSystemFont(ofSize: 12)).foregroundColor(.red)
    let all = Style.font(.systemFont(ofSize: 12))

    let str = "\(calculatedCoffee)<g>g</g>"
        .style(tags: ["g": g])
        .styleBase(all)
        .attributedString

    return str
}

func stringWithStrong() -> NSAttributedString {
    let str = "<strong>Nice</strong> try, Phil"
        .style(tags: [
            "strong": Style.font(.boldSystemFont(ofSize: 15)),
        ])
        .attributedString
    return str
}

func stringWithTagAndHashtag() -> NSAttributedString {
    let b = Style.font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)

    let str = "<b>Hello</b> #World"

    let result = str
        .style(tags: ["b": b])
        .styleHashtags(Style.foregroundColor(.blue))
        .attributedString
    return result
}

func stringWithUnorderedList() -> NSAttributedString {
    let li = TagTuner(attributes: Style.font(.systemFont(ofSize: 12)).foregroundColor(.red),
                      startReplacement: "- ",
                      endReplacement: "\n")
    return "TODO:<br><li>veni</li><li>vidi</li><li>vici</li>"
        .style(tags: ["li": li])
        .styleBase(Style.font(.boldSystemFont(ofSize: 14)))
        .attributedString
}

func stringWithOrderedList() -> NSAttributedString {
    var counter = 0
    let ol = TagTuner { _, position in
        switch position {
        case .start:
            counter = 0
        case .end:
            break
        }
        return nil
    }

    let li = TagTuner { _, position in
        switch position {
        case .start:
            counter += 1
            return "\(counter). "
        case .end:
            return "\n"
        }
    }

    return "<ol><li>Coffee</li><li>Tea</li><li>Milk</li></ol>"
        .style(tags: ["li": li, "ol": ol])
        .attributedString
}

func stringWithHref() -> NSAttributedString {
    return "Hey\r\n<a style=\"text-decoration:none\" href=\"http://www.google.com\">Hello\r\nWorld</a>s"
        .style(tags: [
            "a": Style.font(.boldSystemFont(ofSize: 45)).foregroundColor(.red),
        ])
        .attributedString
}

func stringWithBoldItalicUnderline() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!
    #if swift(>=4.2)
        let uib = Style.font(font).underlineStyle(.single)
    #else
        let uib = Style.font(font).underlineStyle(.styleSingle)
    #endif

    let str = "<br><uib>Italicunderline</uib>"
        .style(tags: ["uib": uib])
        .attributedString
    return str
}

func stringWithImage() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!

    #if swift(>=4.2)
        let b = Style.font(font).underlineStyle(.single)
    #else
        let b = Style.font(font).underlineStyle(.styleSingle)
    #endif

    let img = TagTuner(style: { tagAttributes in
        let style = Style
        if let imageId = tagAttributes["id"] {
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: imageId)
            style.attachment(textAttachment)
        }
        return style
    }, transform: { _, _ in
        return "\u{FFFC}"
    })

    let str = "<b>Running</b> with <img id=\"scissors\"></img>!"
        .style(tags: ["b": b, "img": img])
        .attributedString

    return str
}

func stringWithStrikethrough() -> NSAttributedString {
    let all = Style.font(.systemFont(ofSize: 20))
    #if swift(>=4.2)
        let strike = Style.strikethroughStyle(.single).strikethroughColor(.black)
    #else
        let strike = Style.strikethroughStyle(.styleSingle).strikethroughColor(.black)
    #endif

    let code = Style.foregroundColor(.red)

    let str = "<code>my code</code> <strike>test</strike> testing"
        .style(tags: ["strike": strike, "code": code])
        .styleBase(all)
        .attributedString
    return str
}

func stringWithColors() -> NSAttributedString {
    let r = Style.foregroundColor(.red)
    let g = Style.foregroundColor(.green)
    let b = Style.foregroundColor(.blue)
    let c = Style.foregroundColor(.cyan)
    let m = Style.foregroundColor(.magenta)
    let y = Style.foregroundColor(.yellow)

    let str = "<r>Hello <g>w<c>orld<m></g>; he<y>l</y></c>lo atributika</r></m>"
        .style(tags: ["r": r, "g": g, "b": b, "c": c, "m": m, "y": y])
        .attributedString
    return str
}

func stringWithParagraph() -> NSAttributedString {
    let p = Style.font(UIFont(name: "HelveticaNeue", size: 20)!)
    let strong = Style.font(UIFont(name: "Copperplate", size: 20)!)
    let str = "<p>some string... <strong> string</strong></p>"
        .style(tags: ["p": p, "strong": strong])
        .attributedString
    return str
}

func stringWithIndentedList() -> NSAttributedString {
    let bullet = "• "

    let listItemFont = UIFont.systemFont(ofSize: 12)
    let indentation: CGFloat = (bullet as NSString).size(withAttributes: [NSAttributedString.Key.font: listItemFont]).width

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: [NSTextTab.OptionKey: Any]())]
    paragraphStyle.defaultTabInterval = indentation
    paragraphStyle.headIndent = indentation

    let li = TagTuner(attributes: Style.font(listItemFont).paragraphStyle(paragraphStyle),
                      startReplacement: bullet,
                      endReplacement: "\n")

    return "TODO:<br><li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li><li>Vestibulum ornare dui ut orci congue placerat. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li><li>Nunc et tortor vulputate, elementum quam at, tristique nibh. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li>"
        .style(tags: ["li": li])
        .styleBase(Style.font(.boldSystemFont(ofSize: 14)))
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
        stringWithIndentedList(),
    ]
}
