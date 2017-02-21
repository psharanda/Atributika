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
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test,reference)
    }
    
    func testHelloWithBase() {
        
        let test = "<b>Hello World</b>!!!".style(tags: Style("b").font(.boldSystemFont(ofSize: 45)))
            .styleAll(.font(.systemFont(ofSize: 12)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 11))
        reference.addAttributes([NSFontAttributeName: Font.systemFont(ofSize: 12)], range: NSMakeRange(11, 3))
        
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
        
        XCTAssertEqual(a.detections[0].range, 0..<5)
        
        if case .tag(let tag) = a.detections[0].type {
            XCTAssertEqual(tag.name, "a")
            XCTAssertEqual(tag.attributes, ["href":"http://google.com"])
            
        }
        
    }
    
    func testBase() {
        let test = "Hello World!!!".styleAll(Style.font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [NSFontAttributeName: Font.boldSystemFont(ofSize: 45)])
        
        XCTAssertEqual(test, reference)
    }
    
    func testManyTags() {
            
        let test = "He<i>llo</i> <b>World</b>!!!".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45)),
            Style("i").font(.boldSystemFont(ofSize: 12))
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 12)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testManySameTags() {
        
        let test = "He<b>llo</b> <b>World</b>!!!".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45))
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsOverlap() {
        
        let test = "Hello <b>W<red>orld</b>!!!</red>".style(tags:
            Style("b").font(.boldSystemFont(ofSize: 45)),
            Style("red").foregroundColor(.red)
        ).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: Color.red], range: NSMakeRange(7, 7))
        
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
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: Color.red], range: NSMakeRange(8, 3))
        reference.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue], range: NSMakeRange(10, 1))
        
        XCTAssertEqual(test, reference)
    }
    
    func testHashCodes() {
        
        let test = "#Hello @World!!!"
            .styleHashtags(Style.font(.boldSystemFont(ofSize: 45)))
            .styleMentions(Style.foregroundColor(.red))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "#Hello @World!!!")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([NSForegroundColorAttributeName: Color.red], range: NSMakeRange(7, 6))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetector() {
        
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        
        let test = "Call me (888)555-5512".style(textCheckingTypes: types.rawValue,
                                                  style: Style.font(.boldSystemFont(ofSize: 45)))
            .attributedString
        
        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))
        
        XCTAssertEqual(test, reference)
    }
    
    func testIssue1() {
        
        let bad = "<b>Save $1.00</b> on <b>any</b> order!".style(tags:
                Style("b").font(.boldSystemFont(ofSize: 14))
            )
            .styleAll(Style.font(.systemFont(ofSize: 14)).foregroundColor(.red))
            .attributedString
        
        
        
        let badReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [NSFontAttributeName: Font.systemFont(ofSize: 14), NSForegroundColorAttributeName: Color.red])
        
        badReference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(0, 10))
        badReference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(bad, badReference)
        
        let good = "Save <b>$1.00</b> on <b>any</b> order!".style(tags:
                Style("b").font(.boldSystemFont(ofSize: 14)))
            .styleAll(Style.font(.systemFont(ofSize: 14)).foregroundColor(.red))
            .attributedString
        
        let goodReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [NSFontAttributeName: Font.systemFont(ofSize: 14), NSForegroundColorAttributeName: Color.red])
        goodReference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(5, 5))
        goodReference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(good, goodReference)
    }
    
    func testRange() {
        
        let test = "Hello World!!!".style(range: 0..<5, style: Style("b").font(.boldSystemFont(ofSize: 45))).attributedString
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: Font.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 5))
        
        XCTAssertEqual(test, reference)
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
