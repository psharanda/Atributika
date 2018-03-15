/**
 *  Atributika
 *
 *  Copyright (c) 2017 Pavel Sharanda. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import Foundation
import XCTest
import Atributika


class AtributikaTests: XCTestCase {
    
    func testHello() {        
        let test = "Hello <b>World</b>!!!".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45))
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test,reference)
    }
    
    func testHelloWithBase() {
        
        let test = "<b>Hello World</b>!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 45)))
            .styleAll(.font(.systemFont(ofSize: 12)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([NSAttributedStringKey.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
        XCTAssertEqual(test,reference)
    }
    
    func testTagsWithNumbers() {
        
        let test = "<b1>Hello World</b1>!!!".style(tags: Style("b1").font(.boldSystemFont(ofSize: 45)))
            .styleAll(.font(.systemFont(ofSize: 12)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([NSAttributedStringKey.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
        XCTAssertEqual(test,reference)
    }
    
    func testLines() {
        
        let test = "<b>Hello\nWorld</b>!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 45)))
            .styleAll(.font(.systemFont(ofSize: 12)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([NSAttributedStringKey.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
        XCTAssertEqual(test,reference)
    }
    
    func testEmpty() {
        let test = "Hello World!!!".style().attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testParams() {
        let a = "<a href=\"http://google.com\">Hello</a> World!!!".style()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(a.attributedString, reference)
        
        XCTAssertEqual(a.detections[0].range, a.string.startIndex..<a.string.index(a.string.startIndex, offsetBy: 5))
        
        if case .tag(let tag) = a.detections[0].type {
            XCTAssertEqual(tag.name, "a")
            XCTAssertEqual(tag.attributes, ["href":"http://google.com"])
            
        }
        
    }
    
    func testBase() {
        let test = "Hello World!!!".styleAll(Style.font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)])
        
        XCTAssertEqual(test, reference)
    }
    
    func testManyTags() {
            
        let test = "He<i>llo</i> <b>World</b>!!!".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45)),
            Style("i").font(.boldSystemFont(ofSize: 12))
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 12)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testManySameTags() {
        
        let test = "He<b>llo</b> <b>World</b>!!!".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45))
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsOverlap() {
        
        let test = "Hello <b>W<red>orld</b>!!!</red>".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45)),
            Style("red").foregroundColor(.red)
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSAttributedStringKey.foregroundColor: Color.red], range: NSMakeRange(7, 7))
        
        XCTAssertEqual(test, reference)
    }
    
    func testBr() {
        let test = "Hello<br>World!!!".style(tags: []).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotClosedTag() {
        
        let test = "Hello <b>World!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotOpenedTag() {
        
        let test = "Hello </b>World!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testBadTag() {
        
        let test = "Hello <World!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello ")
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsStack() {
        
        let test = "Hello <b>Wo<red>rl<u>d</u></red></b>!!!"
            .style(tags:
                Style("b").font(.boldSystemFont(ofSize: 45)),
                Style("red").foregroundColor(.red),
                Style("u").underlineStyle(.styleSingle))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSAttributedStringKey.foregroundColor: Color.red], range: NSMakeRange(8, 3))
        reference.addAttributes([NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue], range: NSMakeRange(10, 1))
        
        XCTAssertEqual(test, reference)
    }
    
    func testHashCodes() {
        
        let test = "#Hello @World!!!"
            .styleHashtags(Style.font(.boldSystemFont(ofSize: 45)))
            .styleMentions(Style.foregroundColor(.red))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "#Hello @World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([NSAttributedStringKey.foregroundColor: Color.red], range: NSMakeRange(7, 6))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorPhoneRaw() {
        
        let test = "Call me (888)555-5512".style(textCheckingTypes: [.phoneNumber],
                                                  style: Style.font(.boldSystemFont(ofSize: 45)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorLinkRaw() {
        
        let test = "Check this http://google.com".style(textCheckingTypes: [.link],
                                                 style: Style.font(.boldSystemFont(ofSize: 45)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Check this http://google.com")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(11, 17))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorPhone() {
        
        let test = "Call me (888)555-5512".stylePhoneNumbers(Style.font(.boldSystemFont(ofSize: 45)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetectorLink() {
        
        let test = "Check this http://google.com".styleLinks(Style.font(.boldSystemFont(ofSize: 45)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Check this http://google.com")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(11, 17))
        
        XCTAssertEqual(test, reference)
    }
    
    func testIssue1() {
        
        let bad = "<b>Save $1.00</b> on <b>any</b> order!".style(tags:
                Style("b").font(.boldSystemFont(ofSize: 14))
            )
            .styleAll(Style.font(.systemFont(ofSize: 14)).foregroundColor(.red))
            .attributedString
        
        
        
        let badReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [NSAttributedStringKey.font: Font.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Color.red])
        
        badReference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(0, 10))
        badReference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(bad, badReference)
        
        let good = "Save <b>$1.00</b> on <b>any</b> order!".style(tags:
                Style("b").font(.boldSystemFont(ofSize: 14)))
            .styleAll(Style.font(.systemFont(ofSize: 14)).foregroundColor(.red))
            .attributedString
        
        let goodReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [NSAttributedStringKey.font: Font.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Color.red])
        goodReference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(5, 5))
        goodReference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(good, goodReference)
    }
    
    func testRange() {
        let str = "Hello World!!!"
        
        let test = "Hello World!!!".style(range: str.startIndex..<str.index(str.startIndex, offsetBy: 5), style: Style("b").font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testEmojis() {
        
        let test = "Hello <b>W🌎rld</b>!!!".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45))
            ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello W🌎rld!!!")
        reference.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 6))
        
        XCTAssertEqual(test,reference)
    }
    
    func testTransformers() {
        
        let transformers: [TagTransformer] = [
            TagTransformer.brTransformer,
            TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
            TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
        ]
        
        let li = Style("li").font(.systemFont(ofSize: 12))
        
        let test = "TODO:<br><li>veni</li><li>vidi</li><li>vici</li>"
            .style(tags: li, transformers: transformers)
            .attributedString
        
        let reference = NSMutableAttributedString(string: "TODO:\n- veni\n- vidi\n- vici\n")
        reference.addAttributes([NSAttributedStringKey.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(6, 6))
        reference.addAttributes([NSAttributedStringKey.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(13, 6))
        reference.addAttributes([NSAttributedStringKey.font: Font.systemFont(ofSize: 12)], range: NSMakeRange(20, 6))
        
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
        
        let test = "<div><ol type=\"\"><li>Coffee</li><li>Tea</li><li>Milk</li></ol><ol type=\"\"><li>Coffee</li><li>Tea</li><li>Milk</li></ol></div>".style(tags: [], transformers: transformers).string
        let reference = "1. Coffee\n2. Tea\n3. Milk\n1. Coffee\n2. Tea\n3. Milk\n"
        
        XCTAssertEqual(test,reference)
    }
    
    func testStyleBuilder() {
        
        let s = Style
            .font(.boldSystemFont(ofSize: 12), .normal)
            .font(.systemFont(ofSize: 12), .highlighted)
            .font(.boldSystemFont(ofSize: 13), .normal)
            .foregroundColor(.red, .normal)
            .foregroundColor(.green, .highlighted)
        
        let ref = Style("", [.normal: [.font: Font.boldSystemFont(ofSize: 13) as Any, .foregroundColor: Color.red as Any],
                   .highlighted: [.font: Font.systemFont(ofSize: 12) as Any,  .foregroundColor: Color.green as Any]])
        
        
        XCTAssertEqual("test".styleAll(s).attributedString,"test".styleAll(ref).attributedString)
    }
    
    func testStyleBuilder2() {
        
        let s = Style
            .foregroundColor(.red, .normal)
            .font(.boldSystemFont(ofSize: 12), .normal)
            .font(.boldSystemFont(ofSize: 13), .normal)
            .foregroundColor(.green, .highlighted)
            .font(.systemFont(ofSize: 12), .highlighted)
        
        let ref = Style("", [.normal: [.font: Font.boldSystemFont(ofSize: 13) as Any, .foregroundColor: Color.red as Any],
                             .highlighted: [.font: Font.systemFont(ofSize: 12) as Any,  .foregroundColor: Color.green as Any]])
        
        XCTAssertEqual("test".styleAll(s).attributedString,"test".styleAll(ref).attributedString)
    }
    
    func testHelloWithRHTMLTag() {
        let test = "\r\n<a style=\"text-decoration:none\" href=\"http://www.google.com\">Hello World</a>".style(tags:
            Style("a").font(.boldSystemFont(ofSize: 45))
            ).attributedString
        
        let reference1 = NSMutableAttributedString.init(string: "Hello World")
        
        XCTAssertEqual(reference1.length, 11)
        XCTAssertEqual(reference1.string.count, 11)
        
        let reference2 = NSMutableAttributedString.init(string: "\rHello World")
        
        XCTAssertEqual(reference2.length, 12)
        XCTAssertEqual(reference2.string.count, 12)
        
        let reference3 = NSMutableAttributedString.init(string: "\r\nHello World")
        
        XCTAssertEqual(reference3.length, 13)
        XCTAssertEqual(reference3.string.count, 12)
        
        reference3.addAttributes([NSAttributedStringKey.font: Font.boldSystemFont(ofSize: 45)], range: NSRange(reference3.string.range(of: "Hello World")!, in: reference3.string) )
        
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
