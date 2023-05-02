//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

@testable import Atributika
import Foundation
import XCTest

#if os(macOS)
    typealias Font = NSFont
    typealias Color = NSColor
#else
    typealias Font = UIFont
    typealias Color = UIColor
#endif

class AtributikaTests: XCTestCase {
    func testHello() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <b>World</b>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))

        XCTAssertEqual(test, reference)
    }

    func testHelloUppercase() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <B>World</B>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))

        XCTAssertEqual(test, reference)
    }

    func testHelloMixedcase() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <B>World</b>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))

        XCTAssertEqual(test, reference)
    }

    func testHelloWithBase() {
        let test = "<b>Hello World</b>!!!"
            .style(tags: ["b": Attrs().font(.boldSystemFont(ofSize: 45))])
            .styleBase(Attrs().font(.systemFont(ofSize: 12)))
            .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))

        XCTAssertEqual(test, reference)
    }

    func testTagsWithNumbers() {
        let test = AttributedStringBuilder(
            htmlString: "<b1>Hello World</b1>!!!",
            baseAttributes: Attrs().font(.systemFont(ofSize: 12)),
            tags: [
                "b1": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))

        XCTAssertEqual(test, reference)
    }

    func testLines() {
        let test = AttributedStringBuilder(
            htmlString: "<b>Hello\nWorld</b>!!!",
            baseAttributes: Attrs().font(.systemFont(ofSize: 12)),
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))

        XCTAssertEqual(test, reference)
    }

    func testEmpty() {
        let test = AttributedStringBuilder(htmlString: "Hello World!!!")
            .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")

        XCTAssertEqual(test, reference)
    }

    func testParams() {
        let link = URL(string: "http://google.com")!
        let a = AttributedStringBuilder(
            htmlString: "<a href=\"\(link)\">Hello</a> World!!!",
            tags: ["a": TagTuner { _ in
                Attrs().link(link)
            }]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.setAttributes([.link: link], range: NSMakeRange(0, 5))

        XCTAssertEqual(a, reference)
    }

    func testBase() {
        let test = AttributedStringBuilder(
            string: "Hello World!!!",
            baseAttributes: Attrs().font(.boldSystemFont(ofSize: 45))
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [.font: Font.boldSystemFont(ofSize: 45)])

        XCTAssertEqual(test, reference)
    }

    func testManyTags() {
        let test = AttributedStringBuilder(
            htmlString: "He<i>llo</i> <b>World</b>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
                "i": Attrs().font(.boldSystemFont(ofSize: 12)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 12)], range: NSMakeRange(2, 3))
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))

        XCTAssertEqual(test, reference)
    }

    func testManySameTags() {
        let test = AttributedStringBuilder(
            htmlString: "He<b>llo</b> <b>World</b>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(2, 3))
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))

        XCTAssertEqual(test, reference)
    }

    func testTagsOverlap() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <b>W<red>orld</b>!!!</red>",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
                "red": Attrs().foregroundColor(.red),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(7, 7))

        XCTAssertEqual(test, reference)
    }

    func testBr() {
        let test1 = AttributedStringBuilder(htmlString: "Hello<br>World!!!")
            .attributedString

        let test2 = AttributedStringBuilder(htmlString: "Hello<br/>World!!!")
            .attributedString

        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")

        XCTAssertEqual(test1, reference)
        XCTAssertEqual(test2, reference)
    }

    func testNotClosedTag() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <b>World!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")

        XCTAssertEqual(test, reference)
    }

    func testNotOpenedTag() {
        let test = AttributedStringBuilder(
            htmlString: "Hello </b>World!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")

        XCTAssertEqual(test, reference)
    }

    func testBadTag() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <World!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello ")

        XCTAssertEqual(test, reference)
    }

    func testTagsStack() {
        let u = Attrs().underlineStyle(.single)

        let test = AttributedStringBuilder(
            htmlString: "Hello <b>Wo<red>rl<u>d</u></red></b>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
                "red": Attrs().foregroundColor(.red),
                "u": u,
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(8, 3))

        reference.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(10, 1))

        XCTAssertEqual(test, reference)
    }

    func testHashCodes() {
        let test = AttributedStringBuilder(string: "#Hello @World!!!")
            .styleHashtags(Attrs().font(.boldSystemFont(ofSize: 45)))
            .styleMentions(Attrs().foregroundColor(.red))
            .attributedString

        let reference = NSMutableAttributedString(string: "#Hello @World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(7, 6))

        XCTAssertEqual(test, reference)
    }

    func testHashCodesUnderscore() {
        let test = AttributedStringBuilder(string: "#He_lo @Wo_ld!!!")
            .styleHashtags(Attrs().font(.boldSystemFont(ofSize: 45)))
            .styleMentions(Attrs().foregroundColor(.red))
            .attributedString

        let reference = NSMutableAttributedString(string: "#He_lo @Wo_ld!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(7, 6))

        XCTAssertEqual(test, reference)
    }

    func testHashCodesLoc() {
        let test = AttributedStringBuilder(string: "#Парам @Тадам!!!")
            .styleHashtags(Attrs().font(.boldSystemFont(ofSize: 45)))
            .styleMentions(Attrs().foregroundColor(.red))
            .attributedString

        let reference = NSMutableAttributedString(string: "#Парам @Тадам!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(7, 6))

        XCTAssertEqual(test, reference)
    }

    func testDataDetectorPhoneRaw() {
        let test = AttributedStringBuilder(string: "Call me (888)555-5512")
            .style(textCheckingTypes: [.phoneNumber], attributes: Attrs().font(.boldSystemFont(ofSize: 45)))
            .attributedString

        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))

        XCTAssertEqual(test, reference)
    }

    func testDataDetectorLinkRaw() {
        let test = AttributedStringBuilder(string: "Check this http://google.com")
            .style(
                textCheckingTypes: [.link],
                attributes: Attrs().font(.boldSystemFont(ofSize: 45))
            )
            .attributedString

        let reference = NSMutableAttributedString(string: "Check this http://google.com")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(11, 17))

        XCTAssertEqual(test, reference)
    }

    func testDataDetectorPhone() {
        let test = AttributedStringBuilder(string: "Call me (888)555-5512")
            .stylePhoneNumbers(Attrs().font(.boldSystemFont(ofSize: 45)))
            .attributedString

        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))

        XCTAssertEqual(test, reference)
    }

    func testDataDetectorLink() {
        let test = AttributedStringBuilder(string: "Check this http://google.com")
            .styleLinks(Attrs().font(.boldSystemFont(ofSize: 45)))
            .attributedString

        let reference = NSMutableAttributedString(string: "Check this http://google.com")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(11, 17))

        XCTAssertEqual(test, reference)
    }

    func testIssue1() {
        let bad = AttributedStringBuilder(
            htmlString: "<b>Save $1.00</b> on <b>any</b> order!",
            baseAttributes: Attrs().font(.systemFont(ofSize: 14)).foregroundColor(.red),
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 14)),
            ]
        )
        .attributedString

        let badReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [.font: Font.systemFont(ofSize: 14), .foregroundColor: Color.red])

        badReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(0, 10))
        badReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))

        XCTAssertEqual(bad, badReference)

        let good = AttributedStringBuilder(
            htmlString: "Save <b>$1.00</b> on <b>any</b> order!",
            baseAttributes: Attrs().font(.systemFont(ofSize: 14)).foregroundColor(.red),
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 14)),
            ]
        )
        .attributedString

        let goodReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [.font: Font.systemFont(ofSize: 14), .foregroundColor: Color.red])
        goodReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(5, 5))
        goodReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))

        XCTAssertEqual(good, goodReference)
    }

    func testRange() {
        let str = "Hello World!!!"

        let test = AttributedStringBuilder(string: "Hello World!!!")
            .style(range: str.startIndex ..< str.index(str.startIndex, offsetBy: 5), attributes: Attrs().font(.boldSystemFont(ofSize: 45)))
            .attributedString

        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 5))

        XCTAssertEqual(test, reference)
    }

    func testEmojis() {
        let test = AttributedStringBuilder(
            htmlString: "Hello <b>W🌎rld</b>!!!",
            tags: [
                "b": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Hello W🌎rld!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 6))

        XCTAssertEqual(test, reference)
    }

    func testLI() {
        let li = Attrs()
            .font(.systemFont(ofSize: 12))

        let test = AttributedStringBuilder(
            htmlString: "TODO:<br><li>veni</li><li>vidi</li><li>vici</li>",
            tags: ["li": TagTuner(attributes: li, openingTagReplacement: "- ", closingTagReplacement: "\n")]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "TODO:\n- veni\n- vidi\n- vici\n")
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(6, 21))

        XCTAssertEqual(test, reference)
    }

    func testOL() {
        var counter = 0

        let test = AttributedStringBuilder(
            htmlString: "<div><ol type=\"\"><li>Coffee</li><li>Tea</li><li>Milk</li></ol><ol type=\"\"><li>Coffee</li><li>Tea</li><li>Milk</li></ol></div>",
            tags: [
                "ol": TagTuner { _,_  in
                    counter = 0
                    return nil
                },
                "li": TagTuner { _, part in
                    switch part {
                    case .opening:
                        counter += 1
                        return "\(counter). "
                    case .closing:
                        return "\n"
                    case .content:
                        return nil
                    }
                },
            ]
        )
        .attributedString.string
        let reference = "1. Coffee\n2. Tea\n3. Milk\n1. Coffee\n2. Tea\n3. Milk\n"

        XCTAssertEqual(test, reference)
    }

    func testHelloWithRHTMLTag() {
        let test = AttributedStringBuilder(
            htmlString: "\r\n<a style=\"text-decoration:none\" href=\"http://www.google.com\">Hello World</a>",
            tags: [
                "a": Attrs().font(.boldSystemFont(ofSize: 45)),
            ]
        )
        .attributedString

        let reference1 = NSMutableAttributedString(string: "Hello World")

        XCTAssertEqual(reference1.length, 11)
        XCTAssertEqual(reference1.string.count, 11)

        let reference2 = NSMutableAttributedString(string: "\rHello World")

        XCTAssertEqual(reference2.length, 12)
        XCTAssertEqual(reference2.string.count, 12)

        let reference3 = NSMutableAttributedString(string: "\r\nHello World")

        XCTAssertEqual(reference3.length, 13)
        XCTAssertEqual(reference3.string.count, 12)

        reference3.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSRange(reference3.string.range(of: "Hello World")!, in: reference3.string))

        XCTAssertEqual(test, reference3)
    }

    func testTagAttributes() {
        let test = "Hello <a class=\"big\" target=\"\" href=\"http://foo.com\">world</a>!"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello world!")
        XCTAssertEqual(tags[0].tag.attributes["class"], "big")
        XCTAssertEqual(tags[0].tag.attributes["target"], "")
        XCTAssertEqual(tags[0].tag.attributes["href"], "http://foo.com")
    }

    func testSelfClosingTagAttributes() {
        let test = "Hello <img href=\"http://foo.com/image.jpg\"/>!"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello !")

        XCTAssertEqual(tags[0].tag.name, "img")
        XCTAssertEqual(tags[0].tag.attributes["href"], "http://foo.com/image.jpg")
    }

    func testInnerSelfClosingTagAttributes() {
        let test = "Hello <b>bold<img href=\"http://foo.com/image.jpg\"/>!</b>"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello bold!")

        XCTAssertEqual(tags[0].tag.name, "img")
        XCTAssertEqual(tags[0].tag.attributes["href"], "http://foo.com/image.jpg")
    }

    func testTagAttributesWithSingleQuote() {
        let test = "Hello <a class='big' target='' href=\"http://foo.com\">world</a>!"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello world!")
        XCTAssertEqual(tags[0].tag.attributes["class"], "big")
        XCTAssertEqual(tags[0].tag.attributes["target"], "")
        XCTAssertEqual(tags[0].tag.attributes["href"], "http://foo.com")
    }

    func testMalformedTagAttributes() {
        XCTAssertEqual("<# />".detectTags().string, "<# />")
        XCTAssertEqual("</ >".detectTags().string, "</ >")
        XCTAssertEqual("</ ".detectTags().string, "</ ")

        XCTAssertEqual("<a param/>".detectTags().string, "")
        XCTAssertEqual("<a param ".detectTags().string, "")
        XCTAssertEqual("<a param=/>".detectTags().string, "")
        XCTAssertEqual("<a param= />".detectTags().string, "")
        XCTAssertEqual("<a param= ".detectTags().string, "")
        XCTAssertEqual("<a param=\"val/>".detectTags().string, "")
        XCTAssertEqual("<a param=val/>".detectTags().string, "")
        XCTAssertEqual("<a param=val/".detectTags().string, "")

        XCTAssertEqual("<a param/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": ""]))
        XCTAssertEqual("<a param=/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": ""]))
        XCTAssertEqual("<a param= />".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": ""]))
        XCTAssertEqual("<a param=val/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": "val"]))
        XCTAssertEqual("<a param=val/".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": "val"]))

        XCTAssertEqual("<a param=val xxx=\"dd\"  tag   =   1000.1000/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": "val", "xxx": "dd", "tag": "1000.1000"]))
        XCTAssertEqual("<a param=val/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": "val"]))

        XCTAssertEqual("<a  param='x'      t=\"y\"/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": "x", "t": "y"]))

        XCTAssertEqual("<a param='<>' t=\"&&&\"/>".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: ["param": "<>", "t": "&&&"]))

        XCTAssertEqual("<a>xxx</a yyy".detectTags().string, "xxx")
        XCTAssertEqual("<a>xxx</a yyy".detectTags().tagsInfo[0].tag, Tag(name: "a", attributes: [:]))

        XCTAssertEqual("</img id=\"scissors\">".detectTags().string, "")
    }

    func testSpecials() {
        XCTAssertEqual("Hello&amp;World!!!".detectTags().string, "Hello&World!!!")
        XCTAssertEqual("Hello&".detectTags().string, "Hello&")
        XCTAssertEqual("Hello&World".detectTags().string, "Hello&World")
        XCTAssertEqual("&quot;Quote&quot;".detectTags().string, "\"Quote\"")
        XCTAssertEqual("&".detectTags().string, "&")
        XCTAssertEqual("&&amp;".detectTags().string, "&&")
        XCTAssertEqual("4>5".detectTags().string, "4>5")
        XCTAssertEqual("4<5".detectTags().string, "4<5")
        XCTAssertEqual("<".detectTags().string, "<")
        XCTAssertEqual(">".detectTags().string, ">")
        XCTAssertEqual("<a".detectTags().string, "")
        XCTAssertEqual("<a>".detectTags().string, "")
        XCTAssertEqual("< a>".detectTags().string, "< a>")
        XCTAssertEqual("&lt;".detectTags().string, "<")
        XCTAssertEqual("&gt;".detectTags().string, ">")
        XCTAssertEqual("&apos;".detectTags().string, "'")
        XCTAssertEqual("&quot;".detectTags().string, "\"")

        XCTAssertEqual("<tag val='&apos;'/>".detectTags().tagsInfo[0].tag, Tag(name: "tag", attributes: ["val": "'"]))
        XCTAssertEqual("<tag val=\"&quot;\"/>".detectTags().tagsInfo[0].tag, Tag(name: "tag", attributes: ["val": "\""]))
        XCTAssertEqual("<tag val=&amp;/>".detectTags().tagsInfo[0].tag, Tag(name: "tag", attributes: ["val": "&"]))
    }

    func testCustomSpecials() {
        struct TestSpecialProvider: HTMLSpecialsProvider {
            func stringForHTMLSpecial(_ htmlSpecial: String) -> String? {
                if htmlSpecial == "Tab" {
                    return "\t"
                }
                return nil
            }
        }

        let prev = AtributikaConfig.htmlSpecialsProvider

        AtributikaConfig.htmlSpecialsProvider = TestSpecialProvider()
        XCTAssertEqual("&Tab;".detectTags().string, "\t")

        AtributikaConfig.htmlSpecialsProvider = prev
    }

    func testSpecialCodes() {
        XCTAssertEqual("&# ".detectTags().string, "&# ")

        XCTAssertEqual("Fish&#38;Chips".detectTags().string, "Fish&Chips")

        XCTAssertEqual("Hello, world.".detectTags().string, "Hello, world.")

        XCTAssertEqual("Fish & Chips".detectTags().string, "Fish & Chips")

        XCTAssertEqual("My phone number starts with a &#49;".detectTags().string, "My phone number starts with a 1")

        XCTAssertEqual("My phone number starts with a &#4_9;!".detectTags().string, "My phone number starts with a &#4_9;!")

        XCTAssertEqual("Let's meet at the caf&#xe9;".detectTags().string, "Let's meet at the café")

        XCTAssertEqual("Let's meet at the caf&#xzi;!".detectTags().string, "Let's meet at the caf&#xzi;!")

        XCTAssertEqual("What is this character ? -> &#xd8ff;".detectTags().string, "What is this character ? -> &#xd8ff;")

        XCTAssertEqual("I love &swift;".detectTags().string, "I love &swift;")

        XCTAssertEqual("a &amp;&amp; b".detectTags().string, "a && b")

        XCTAssertEqual("Going to the &#127482;&#127480; next June".detectTags().string, "Going to the 🇺🇸 next June")
    }

    func testAttributesBasedTagTuner() {
        func hexStringToUIColor(hex: String) -> Color {
            var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }

            if (cString.count) != 6 {
                return Color.gray
            }

            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            return Color(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }

        let test = AttributedStringBuilder(
            htmlString: "Monday - Friday:<font color=\"#6cc299\"> 8:00 - 19:00</font>",
            tags: [
                "font": TagTuner {
                    let ab = Attrs()
                    if let colorString = $0.tag.attributes["color"] {
                        ab.foregroundColor(hexStringToUIColor(hex: colorString))
                    }
                    return ab
                },
            ]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "Monday - Friday: 8:00 - 19:00")
        reference.addAttributes([.foregroundColor: hexStringToUIColor(hex: "#6cc299")], range: NSMakeRange(16, 13))
        XCTAssertEqual(test, reference)
    }

    func testHrefTagTuner() {
        let test = AttributedStringBuilder(
            htmlString: "<a href=\"https://github.com/psharanda/Atributika\">link</a>",
            tags: ["a": TagTuner {
                let ab = Attrs().foregroundColor(.blue)
                if let link = $0.tag.attributes["href"] {
                    ab.link(URL(string: link)!)
                }
                return ab
            }]
        )
        .attributedString

        let reference = NSMutableAttributedString(string: "link")
        reference.addAttributes([.link: URL(string: "https://github.com/psharanda/Atributika")!, .foregroundColor: Color.blue], range: NSMakeRange(0, 4))
        XCTAssertEqual(test, reference)
    }

    func testHTMLComment() {
        let test = "Hello <!--This is a comment. Comments are erased by Atributika-->world!"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello world!")
        XCTAssertEqual(tags.count, 0)
    }

    func testHTMLComment2() {
        let test = "Hello <!---->world!"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello world!")
        XCTAssertEqual(tags.count, 0)
    }

    func testBrokenTag() {
        let test = "Hello <"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, test)
        XCTAssertEqual(tags.count, 0)
    }

    func testBrokenHTMLComment4() {
        let test = "Hello <!--"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello ")
        XCTAssertEqual(tags.count, 0)
    }

    func testBrokenHTMLComment5() {
        let test = "Hello <!--This is a comment. Comments are erased by Atributika-d->world!"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello ")
        XCTAssertEqual(tags.count, 0)
    }

    func testBrokenHTMLComment6() {
        let test = "Hello <!--f"

        let (string, tags) = test.detectTags()

        XCTAssertEqual(string, "Hello ")
        XCTAssertEqual(tags.count, 0)
    }

    func testScanCharacter() {
        let ref = "Hello W🌎rld-🇬🇧🥗 Text 🍣"

        var test = ""

        let scanner = Scanner(string: ref)
        scanner.charactersToBeSkipped = nil

        while let char = scanner.currentCharacter() {
            _ = scanner._scanString(String(char))
            test.append(char)
        }

        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            let scanner13 = Scanner(string: ref)
            scanner13.charactersToBeSkipped = nil
            var test13 = ""
            while let char = scanner13.scanCharacter() {
                test13.append(char)
            }
            XCTAssertEqual(test13, test)
        }

        XCTAssertEqual(test, ref)
    }

    func testCompatibilityString() {
        XCTAssertEqual("<font>Hello 👨‍👧‍👧</font>".detectTags().string, "Hello 👨‍👧‍👧")
        XCTAssertEqual("<font>Hello 👨‍👧‍👧👨‍👧‍👧</font>".detectTags().string, "Hello 👨‍👧‍👧👨‍👧‍👧")
        XCTAssertEqual("<font>Hello 👨‍👧‍👧👨‍👧‍👧👨‍👧‍👧</font>".detectTags().string, "Hello 👨‍👧‍👧👨‍👧‍👧👨‍👧‍👧")
        XCTAssertEqual("<font>Hello 👨‍👧‍👧👨‍👧‍👧👨‍👧‍👧👨‍👧‍👧</font>".detectTags().string, "Hello 👨‍👧‍👧👨‍👧‍👧👨‍👧‍👧👨‍👧‍👧")
        XCTAssertEqual("<font>Hello 👨‍👨‍👦‍👦👨‍👨‍👦‍👦👨‍👨‍👦‍👦👨‍👨‍👦‍👦</font>".detectTags().string, "Hello 👨‍👨‍👦‍👦👨‍👨‍👦‍👦👨‍👨‍👦‍👦👨‍👨‍👦‍👦")
    }

    func testOuterTags() {
        let italicBoldTuner = TagTuner { info in
            var set = Set<String>()
            set.insert(info.tag.name)
            info.outerTags.forEach { set.insert($0.name) }

            let attrs = Attrs()
            if set.contains("b") && set.contains("i") {
                attrs.font(Font(name: "HelveticaNeue-BoldItalic", size: 12)!)
            } else if set.contains("i") {
                attrs.font(Font(name: "HelveticaNeue-Italic", size: 12)!)
            } else if set.contains("b") {
                attrs.font(Font(name: "HelveticaNeue-Bold", size: 12)!)
            }
            return attrs
        }

        let test = "<u><i><b>Italicunderline</b></i></u>"
            .style(tags: [
                "u": Attrs().underlineStyle(.single),
                "i": italicBoldTuner,
                "b": italicBoldTuner,
            ])
            .attributedString

        let reference = NSMutableAttributedString(string: "Italicunderline")
        reference.addAttributes([.font: Font(name: "HelveticaNeue-BoldItalic", size: 12)!,
                                 .underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, 15))

        XCTAssertEqual(test, reference)
    }

    func testTransformBody() {
        let head = TagTuner { _ in
            Attrs().foregroundColor(.red)
        } transform: { _, part in
            switch part {
            case .opening, .closing:
                return nil
            case let .content(body):
                if body.count > 1 {
                    return String(body.uppercased()[body.startIndex ..< body.index(after: body.startIndex)])
                } else {
                    return String(body)
                }
            }
        }

        let script = TagTuner(contentReplacement: "")

        let test = "<head>Hel<script><head>1</head>var i = 0</script>lo</head> World"
            .style(tags: ["script": script, "head": head])
            .attributedString

        let reference = NSMutableAttributedString(string: "H World")
        reference.addAttributes([.foregroundColor: UIColor.red], range: NSMakeRange(0, 1))
        XCTAssertEqual(test, reference)
    }
}

#if os(Linux)
    extension AtributikaTests {
        static var allTests: [(String, (AtributikaTests) -> () throws -> Void)] {
            return [
                ("testExample", testExample),
            ]
        }
    }
#endif
