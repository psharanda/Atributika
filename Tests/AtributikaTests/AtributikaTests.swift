//
//  Copyright © 2017-2023 psharanda. All rights reserved.
//

import Foundation
import XCTest
@testable import Atributika

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
            htmlString:"Hello <b>World</b>!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test,reference)
    }
    
    func testHelloWithBase() {
        
        let test = AttributedStringBuilder(
            htmlString:"<b>Hello World</b>!!!",
            baseAttributes: AttributesBuilder().font(.systemFont(ofSize: 12)).attributes,
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
        XCTAssertEqual(test,reference)
    }
    
    func testTagsWithNumbers() {
        
        let test = AttributedStringBuilder(
            htmlString:"<b1>Hello World</b1>!!!",
            baseAttributes: AttributesBuilder().font(.systemFont(ofSize: 12)).attributes,
            tags: [
                "b1": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
        XCTAssertEqual(test,reference)
    }
    
    func testLines() {
        
        let test = AttributedStringBuilder(
            htmlString:"<b>Hello\nWorld</b>!!!",
            baseAttributes: AttributesBuilder().font(.systemFont(ofSize: 12)).attributes,
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
        XCTAssertEqual(test,reference)
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
            htmlString:"<a href=\"\(link)\">Hello</a> World!!!",
            tuner: { attrs, tag in
                if (tag.name == "a") {
                    return AttributesBuilder(attrs).link(link).attributes
                } else {
                    return attrs
                }
            })
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.setAttributes([.link: link], range: NSMakeRange(0, 5))
        
        XCTAssertEqual(a, reference)
    }
    
    func testBase() {
        let test = AttributedStringBuilder(
            string: "Hello World!!!",
            baseAttributes: AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [.font: Font.boldSystemFont(ofSize: 45)])
        
        XCTAssertEqual(test, reference)
    }
    
    func testManyTags() {
            
        let test = AttributedStringBuilder(
            htmlString:"He<i>llo</i> <b>World</b>!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes,
                "i": AttributesBuilder().font(.boldSystemFont(ofSize: 12)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 12)], range: NSMakeRange(2, 3))
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testManySameTags() {
        
        let test = AttributedStringBuilder(
            htmlString:"He<b>llo</b> <b>World</b>!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(2, 3))
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsOverlap() {
        
        let test = AttributedStringBuilder(
            htmlString:"Hello <b>W<red>orld</b>!!!</red>",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes,
                "red": AttributesBuilder().foregroundColor(.red).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(7, 7))
        
        XCTAssertEqual(test, reference)
    }
    
    func testBr() {
        let test = AttributedStringBuilder(htmlString:"Hello<br>World!!!")
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotClosedTag() {
        
        let test = AttributedStringBuilder(
            htmlString:"Hello <b>World!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotOpenedTag() {
        
        let test = AttributedStringBuilder(
            htmlString:"Hello </b>World!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testBadTag() {
        
        let test = AttributedStringBuilder(
            htmlString:"Hello <World!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello <World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsStack() {
        
#if swift(>=4.2)
        let u = AttributesBuilder().underlineStyle(.single).attributes
#else
        let u = AttributesBuilder().underlineStyle(.styleSingle).attributes
#endif
        
        let test = AttributedStringBuilder(
            htmlString:"Hello <b>Wo<red>rl<u>d</u></red></b>!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes,
                "red": AttributesBuilder().foregroundColor(.red).attributes,
                "u": u
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(8, 3))
        
#if swift(>=4.2)
        reference.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(10, 1))
#else
        reference.addAttributes([.underlineStyle: NSUnderlineStyle.styleSingle.rawValue], range: NSMakeRange(10, 1))
#endif
        
        XCTAssertEqual(test, reference)
    }
    
    func testHashCodes() {
        
        let test = AttributedStringBuilder(string: "#Hello @World!!!")
            .styleHashtags(AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes)
            .styleMentions(AttributesBuilder().foregroundColor(.red).attributes)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "#Hello @World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([.foregroundColor: Color.red], range: NSMakeRange(7, 6))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorPhoneRaw() {
        
        let test = AttributedStringBuilder(string: "Call me (888)555-5512")
            .style(textCheckingTypes: [.phoneNumber], attributes: AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorLinkRaw() {
        
        let test = AttributedStringBuilder(string: "Check this http://google.com")
            .style(
                textCheckingTypes: [.link],
                attributes: AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            )
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Check this http://google.com")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(11, 17))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorPhone() {
        
        let test = AttributedStringBuilder(string: "Call me (888)555-5512")
            .stylePhoneNumbers(AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorLink() {
        
        let test = AttributedStringBuilder(string: "Check this http://google.com")
            .styleLinks(AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Check this http://google.com")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(11, 17))
        
        XCTAssertEqual(test, reference)
    }
    
    func testIssue1() {
        
        let bad = AttributedStringBuilder(
            htmlString:"<b>Save $1.00</b> on <b>any</b> order!",
            baseAttributes: AttributesBuilder().font(.systemFont(ofSize: 14)).foregroundColor(.red).attributes,
            tags: [
                "b":AttributesBuilder().font(.boldSystemFont(ofSize: 14)).attributes
            ])
            .attributedString
        
        let badReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [.font: Font.systemFont(ofSize: 14), .foregroundColor: Color.red])
        
        badReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(0, 10))
        badReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(bad, badReference)
        
        let good = AttributedStringBuilder(
            htmlString:"Save <b>$1.00</b> on <b>any</b> order!",
            baseAttributes: AttributesBuilder().font(.systemFont(ofSize: 14)).foregroundColor(.red).attributes,
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 14)).attributes
            ])
            .attributedString
        
        let goodReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [.font: Font.systemFont(ofSize: 14), .foregroundColor: Color.red])
        goodReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(5, 5))
        goodReference.addAttributes([.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(good, goodReference)
    }
    
    func testRange() {
        let str = "Hello World!!!"
        
        let test = AttributedStringBuilder(string: "Hello World!!!")
            .style(range: str.startIndex..<str.index(str.startIndex, offsetBy: 5), attributes: AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testEmojis() {
        
        let test = AttributedStringBuilder(
            htmlString:"Hello <b>W🌎rld</b>!!!",
            tags: [
                "b": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello W🌎rld!!!")
        reference.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 6))
        
        XCTAssertEqual(test,reference)
    }
    
    func testTransformers() {
        
        let transformers: [TagTransformer] = [
            TagTransformer.brTransformer,
            TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
            TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
        ]
        
        let li = AttributesBuilder()
            .font(.systemFont(ofSize: 12))
            .attributes
        
        let test = AttributedStringBuilder(
            htmlString:"TODO:<br><li>veni</li><li>vidi</li><li>vici</li>",
            tags: ["li": li], transformers: transformers)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "TODO:\n- veni\n- vidi\n- vici\n")
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(6, 6))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(13, 6))
        reference.addAttributes([.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(20, 6))
        
        XCTAssertEqual(test,reference)
    }
    
    
    func testOL() {
        var counter = 0
        let transformers: [TagTransformer] = [
            TagTransformer.brTransformer,
            TagTransformer(tagName: "ol", tagType: .start) { _ in
                counter = 0
                return ""
            },
            TagTransformer(tagName: "li", tagType: .start) { _ in
                counter += 1
                return "\(counter). "
            },
            TagTransformer(tagName: "li", tagType: .end) { _ in
                return "\n"
            }
        ]
        
        let test = AttributedStringBuilder(
            htmlString:"<div><ol type=\"\"><li>Coffee</li><li>Tea</li><li>Milk</li></ol><ol type=\"\"><li>Coffee</li><li>Tea</li><li>Milk</li></ol></div>",
            transformers: transformers)
            .attributedString.string
        let reference = "1. Coffee\n2. Tea\n3. Milk\n1. Coffee\n2. Tea\n3. Milk\n"
        
        XCTAssertEqual(test,reference)
    }
    
    func testHelloWithRHTMLTag() {
        let test = AttributedStringBuilder(htmlString:"\r\n<a style=\"text-decoration:none\" href=\"http://www.google.com\">Hello World</a>", tags: [
                "a": AttributesBuilder().font(.boldSystemFont(ofSize: 45)).attributes
            ])
            .attributedString
        
        let reference1 = NSMutableAttributedString.init(string: "Hello World")
        
        XCTAssertEqual(reference1.length, 11)
        XCTAssertEqual(reference1.string.count, 11)
        
        let reference2 = NSMutableAttributedString.init(string: "\rHello World")
        
        XCTAssertEqual(reference2.length, 12)
        XCTAssertEqual(reference2.string.count, 12)
        
        let reference3 = NSMutableAttributedString.init(string: "\r\nHello World")
        
        XCTAssertEqual(reference3.length, 13)
        XCTAssertEqual(reference3.string.count, 12)
        
        reference3.addAttributes([.font: Font.boldSystemFont(ofSize: 45)], range: NSRange(reference3.string.range(of: "Hello World")!, in: reference3.string) )
        
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
        XCTAssertEqual("<a".detectTags().string, "<a")
        XCTAssertEqual("<a>".detectTags().string, "")
        XCTAssertEqual("< a>".detectTags().string, "< a>")        
        XCTAssertEqual("&frasl;".detectTags().string, "⁄")
        XCTAssertEqual("&raquo;".detectTags().string, "»")
    }
    
    func testSpecialCodes() {
        XCTAssertEqual("Fish&#38;Chips".detectTags().string, "Fish&Chips")
        
        XCTAssertEqual("Hello, world.".detectTags().string, "Hello, world.")
        
        XCTAssertEqual("Fish & Chips".detectTags().string, "Fish & Chips")
        
        XCTAssertEqual("My phone number starts with a &#49;".detectTags().string, "My phone number starts with a 1")
        
        XCTAssertEqual("My phone number starts with a &#4_9;!".detectTags().string, "My phone number starts with a &#4_9;!")
        
        XCTAssertEqual("Let's meet at the caf&#xe9;".detectTags().string ,"Let's meet at the café")
        
        XCTAssertEqual("Let's meet at the caf&#xzi;!".detectTags().string, "Let's meet at the caf&#xzi;!")
        
        XCTAssertEqual("What is this character ? -> &#xd8ff;".detectTags().string, "What is this character ? -> &#xd8ff;")
        
        XCTAssertEqual("I love &swift;".detectTags().string ,"I love &swift;")
        
        XCTAssertEqual("Do you know &aleph;?".detectTags().string, "Do you know ℵ?")
        
        XCTAssertEqual("a &amp;&amp; b".detectTags().string, "a && b")
        
        XCTAssertEqual("Going to the &#127482;&#127480; next June".detectTags().string, "Going to the 🇺🇸 next June")
        
    }
    
    func testTuner() {
        
        func hexStringToUIColor (hex:String) -> Color {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return Color.gray
            }
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return Color(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        let font: [NSAttributedString.Key: Any] = [:]
        
        let test = AttributedStringBuilder(htmlString:"Monday - Friday:<font color=\"#6cc299\"> 8:00 - 19:00</font>", tags: ["font": font], tuner: { style, tag in
                if tag.name == "font" {
                    if let colorString = tag.attributes["color"] {
                        return AttributesBuilder(style)
                            .foregroundColor(hexStringToUIColor(hex: colorString))
                            .attributes
                    }
                }
                return style
            })
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Monday - Friday: 8:00 - 19:00")
        reference.addAttributes([.foregroundColor: hexStringToUIColor(hex: "#6cc299")], range: NSMakeRange(16, 13))
        XCTAssertEqual(test, reference)
    }
    
    func testHrefTuner() {
        
        let test = AttributedStringBuilder(htmlString:"<a href=\"https://github.com/psharanda/Atributika\">link</a>", tags: [:], tuner: { style, tag in
                if tag.name == "a" {
                    if let link = tag.attributes["href"] {
                        return AttributesBuilder(style)
                            .link(URL(string: link)!)
                            .attributes
                    }
                }
                return style
            })
            .attributedString
        
        let reference = NSMutableAttributedString(string: "link")
        reference.addAttributes([.link: URL(string: "https://github.com/psharanda/Atributika")!], range: NSMakeRange(0, 4))
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
    
    func testBrokenHTMLComment() {
        let test = "Hello <!-This is a comment. Comments are erased by Atributika-->world!"
        
        let (string, tags) = test.detectTags()
        
        
        XCTAssertEqual(string, test)
        XCTAssertEqual(tags.count, 0)
    }
    
    func testBrokenHTMLComment2() {
        let test = "Hello <!"
        
        let (string, tags) = test.detectTags()
        
        
        XCTAssertEqual(string, test)
        XCTAssertEqual(tags.count, 0)
    }
    
    func testBrokenHTMLComment3() {
        let test = "Hello <!"
        
        let (string, tags) = test.detectTags()
        
        
        XCTAssertEqual(string, test)
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
        
        if #available(iOS 13.0, *) {
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
}




#if os(Linux)
extension AtributikaTests {
    static var allTests : [(String, (AtributikaTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
#endif
