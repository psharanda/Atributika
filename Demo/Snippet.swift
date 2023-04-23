//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import Foundation
import UIKit

func stringWithAtributikaLogo() -> NSAttributedString {
    let redColor = UIColor(red: 0xD0 / 255.0, green: 0x02 / 255.0, blue: 0x1B / 255.0, alpha: 1.0)
    let a = Attrs().foregroundColor(redColor)

    let font = UIFont(name: "AvenirNext-Regular", size: 24)!
    let grayColor = UIColor(white: 0x66 / 255.0, alpha: 1)
    let all = Attrs().font(font).foregroundColor(grayColor)

    let str = "<a>&lt;a&gt;</a>tributik<a>&lt;/a&gt;</a>"
        .style(tags: ["a": a])
        .styleBase(all)
        .attributedString
    return str
}

func stringWithTagsAndEmoji() -> NSAttributedString {
    let b = Attrs().font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)
    let all = Attrs().font(.systemFont(ofSize: 20))
    let str = "Hello <b>W🌎rld</b>!!!"
        .style(tags: ["b": b])
        .styleBase(all)
        .attributedString
    return str
}

func stringWithHashTagAndMention() -> NSAttributedString {
    let str = "#Hello @World!!!"
        .styleHashtags(Attrs().font(.boldSystemFont(ofSize: 45)))
        .styleMentions(Attrs().foregroundColor(.red))
        .attributedString
    return str
}

func stringWithPhone() -> NSAttributedString {
    let str = "Call me (888)555-5512"
        .stylePhoneNumbers(Attrs().foregroundColor(.red))
        .attributedString
    return str
}

func stringWithLink() -> NSAttributedString {
    let str = "Check this http://google.com"
        .styleLinks(Attrs().foregroundColor(.blue))
        .attributedString
    return str
}

func stringWithBoldItalic() -> NSAttributedString {
    let baseFont = UIFont.systemFont(ofSize: 12)
    let descriptor = baseFont.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold])
    let font = descriptor.map { UIFont(descriptor: $0, size: baseFont.pointSize) } ?? baseFont

    let a = Attrs().font(font).foregroundColor(.blue)
    let str = "<a href=\"https://en.wikipedia.org/wiki/World_of_Dance_(TV_series)\" target=\"_blank\">World of Dance</a>"
        .style(tags: ["a": a])
        .attributedString
    return str
}

func stringWithManyDetectables() -> NSAttributedString {
    let links = Attrs().foregroundColor(.blue)
    let phoneNumbers = Attrs().backgroundColor(.yellow)
    let mentions = Attrs().font(.italicSystemFont(ofSize: 12)).foregroundColor(.black)
    let b = Attrs().font(.boldSystemFont(ofSize: 12))

    let u = Attrs().underlineStyle(.single)

    let base = Attrs().font(.systemFont(ofSize: 12)).foregroundColor(.gray)

    let str = "@all I found <u>really</u> nice framework to manage attributed strings. It is called <b>Atributika</b>. Call me if you want to know more (123)456-7890 #swift #nsattributedstring https://github.com/psharanda/Atributika"
        .style(tags: ["u": u, "b": b])
        .styleMentions(mentions)
        .styleHashtags(links)
        .styleLinks(links)
        .stylePhoneNumbers(phoneNumbers)
        .styleBase(base)
        .attributedString

    return str
}

func stringWith3Tags() -> NSAttributedString {
    let str = "<r>first</r><g>sec⚽️nd</g><b>third</b>"
        .style(tags: [
            "r": Attrs().foregroundColor(.red),
            "g": Attrs().foregroundColor(.green),
            "b": Attrs().foregroundColor(.blue),
        ])
        .attributedString
    return str
}

func stringWithGrams() -> NSAttributedString {
    let calculatedCoffee = 768
    let g = Attrs().font(.boldSystemFont(ofSize: 12)).foregroundColor(.red)
    let all = Attrs().font(.systemFont(ofSize: 12))

    let str = "\(calculatedCoffee)<g>g</g>"
        .style(tags: ["g": g])
        .styleBase(all)
        .attributedString

    return str
}

func stringWithStrong() -> NSAttributedString {
    let str = "<strong>Nice</strong> try, Phil"
        .style(tags: [
            "strong": Attrs().font(.boldSystemFont(ofSize: 15)),
        ])
        .attributedString
    return str
}

func stringWithTagAndHashtag() -> NSAttributedString {
    let b = Attrs().font(.boldSystemFont(ofSize: 20)).foregroundColor(.red)

    let str = "<b>Hello</b> #World"

    let result = str
        .style(tags: ["b": b])
        .styleHashtags(Attrs().foregroundColor(.blue))
        .attributedString
    return result
}

func stringWithUnorderedList() -> NSAttributedString {
    let li = TagTuner(attributes: Attrs().font(.systemFont(ofSize: 12)).foregroundColor(.red),
                      startReplacement: "- ",
                      endReplacement: "\n")
    return "TODO:<br><li>veni</li><li>vidi</li><li>vici</li>"
        .style(tags: ["li": li])
        .styleBase(Attrs().font(.boldSystemFont(ofSize: 14)))
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
            "a": Attrs().font(.boldSystemFont(ofSize: 45)).foregroundColor(.red),
        ])
        .attributedString
}

func stringWithBoldItalicUnderline() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!
    let uib = Attrs().font(font).underlineStyle(.single)

    let str = "<br><uib>Italicunderline</uib>"
        .style(tags: ["uib": uib])
        .attributedString
    return str
}

func stringWithImage() -> NSAttributedString {
    let font = UIFont(name: "HelveticaNeue-BoldItalic", size: 12)!

    let b = Attrs().font(font).underlineStyle(.single)

    let img = TagTuner(style: { tag in
        let style = Attrs()
        if let imageId = tag.attributes["id"] {
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: imageId)
            style.attachment(textAttachment)
        }
        return style
    }, transform: { _, position in
        switch position {
        case .start:
            return "\u{FFFC}"
        case .end:
            return nil
        }
    })

    let str = "<b>Running</b> with <img id=\"scissors\"></img><img id=\"scissors\"/></img id=\"scissors\">!"
        .style(tags: ["b": b, "img": img])
        .attributedString

    return str
}

func stringWithStrikethrough() -> NSAttributedString {
    let all = Attrs().font(.systemFont(ofSize: 20))
    let strike = Attrs().strikethroughStyle(.single).strikethroughColor(.black)

    let code = Attrs().foregroundColor(.red)

    let str = "<code>my code</code> <strike>test</strike> testing"
        .style(tags: ["strike": strike, "code": code])
        .styleBase(all)
        .attributedString
    return str
}

func stringWithColors() -> NSAttributedString {
    let r = Attrs().foregroundColor(.red)
    let g = Attrs().foregroundColor(.green)
    let b = Attrs().foregroundColor(.blue)
    let c = Attrs().foregroundColor(.cyan)
    let m = Attrs().foregroundColor(.magenta)
    let y = Attrs().foregroundColor(.yellow)

    let str = "<r>Hello <g>w<c>orld<m></g>; he<y>l</y></c>lo atributika</r></m>"
        .style(tags: ["r": r, "g": g, "b": b, "c": c, "m": m, "y": y])
        .attributedString
    return str
}

func stringWithParagraph() -> NSAttributedString {
    let p = Attrs().font(UIFont(name: "HelveticaNeue", size: 20)!)
    let strong = Attrs().font(UIFont(name: "Copperplate", size: 20)!)
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

    let li = TagTuner(attributes: Attrs().font(listItemFont).paragraphStyle(paragraphStyle),
                      startReplacement: bullet,
                      endReplacement: "\n")

    return "TODO:<br><li>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li><li>Vestibulum ornare dui ut orci congue placerat. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li><li>Nunc et tortor vulputate, elementum quam at, tristique nibh. Cras a mollis mauris. Cras non mauris nisi. Ut turpis tellus, pretium sed erat eu, consectetur volutpat nisl. Praesent at bibendum ante</li>"
        .style(tags: ["li": li])
        .styleBase(Attrs().font(.boldSystemFont(ofSize: 14)))
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
