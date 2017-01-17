//
//  AtributikaTests.swift
//  AtributikaTests
//
//  Created by Pavel Sharanda on 09.05.16.
//  Copyright © 2016 psharanda. All rights reserved.
//

import XCTest
@testable import Atributika

class AtributikaTests: XCTestCase {
    

    func testHello() {
        let test = Atributika(text: "Hello <b>World</b>!!!",
                   styles: [
                    "b" : [
                        .font(UIFont.boldSystemFont(ofSize: 45)),
                    ]
                    
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test,reference)
    }
    
    func testEmpty() {
        let test = Atributika(text: "Hello World!!!").buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testParams() {
        let (test, tags) = Atributika(text: "<a href=\"http://google.com\">Hello</a> World!!!").buildAttributedStringAndTagsInfo()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
        
        let referenceTags = [TagInfo(tag: Tag(name: "a", attributes: ["href":"http://google.com"]), range: 0..<5)]
        XCTAssertEqual(tags, referenceTags)
    }
    
    func testBase() {
        let test = Atributika(text: "Hello World!!!", styles: [:], baseStyle: [.font(UIFont.boldSystemFont(ofSize: 45))]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)])
        
        XCTAssertEqual(test, reference)
    }
    
    func testManyTags() {
        let test = Atributika(text: "He<i>llo</i> <b>World</b>!!!",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ],
                                "i" : [
                                    .font(UIFont.italicSystemFont(ofSize: 12)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.italicSystemFont(ofSize: 12)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testManySameTags() {
        let test = Atributika(text: "He<b>llo</b> <b>World</b>!!!",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsOverlap() {
        let test = Atributika(text: "Hello <b>W<red>orld</b>!!!</red>",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ],
                                "red" : [
                                    .foregroundColor(UIColor.red),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(7, 7))
        
        XCTAssertEqual(test, reference)
    }
    
    func testBr() {
        let test = Atributika(text: "Hello<br>World!!!").buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotClosedTag() {
        let test = Atributika(text: "Hello <b>World!!!",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotOpenedTag() {
        let test = Atributika(text: "Hello </b>World!!!",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testBadTag() {
        
        //TODO: throw error???
        let test = Atributika(text: "Hello <bWorld!!!",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello ")
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsStack() {
        let test = Atributika(text: "Hello <b>Wo<red>rl<u>d</u></red></b>!!!",
                              styles: [
                                "b" : [
                                    .font(UIFont.boldSystemFont(ofSize: 45)),
                                ],
                                "red" : [
                                    .foregroundColor(UIColor.red)
                                ],
                                "u" : [
                                    .underlineStyle(.styleSingle)
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(8, 3))
        reference.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue], range: NSMakeRange(10, 1))
        
        XCTAssertEqual(test, reference)
    }
    
    func testHashCodes() {
        
        var a = Atributika(text: "#Hello @World!!!",
                           styles: [
                            "#" : [
                                .font(UIFont.boldSystemFont(ofSize: 45)),
                            ],
                            "@" : [
                                .foregroundColor(UIColor.red),
                            ]
                            
            ])
        a.hashtags = "#@"
        let test = a.buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "#Hello @World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(0, 6))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: NSMakeRange(7, 6))
        
        XCTAssertEqual(test, reference)
    }
    
    func testDataDetector() {
        var a = Atributika(text: "Call me (888)555-5512",
                           styles: [
                            "data" : [
                                .font(UIFont.boldSystemFont(ofSize: 45)),
                            ]
                            
            ])
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        
        a.dataDetectorTypes = types.rawValue
        a.dataDetectorTagName = "data"
        let test = a.buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Call me (888)555-5512")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 45)], range: NSMakeRange(8, 13))
        
        XCTAssertEqual(test, reference)
    }
    
    func testIssue1() {
        
        let bad = "<b>Save $1.00</b> on <b>any</b> order!"
        
        let badDesc = Atributika(text: bad,
                                 styles: [
                                    "b" : [.font( UIFont.boldSystemFont(ofSize: 14))]
            ],
                                 baseStyle: [
                                    .font( UIFont.systemFont(ofSize: 14)), .foregroundColor(UIColor.red)
            ])
            .buildAttributedString()
        
        
        
        let badReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.red])
        
        badReference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSMakeRange(0, 10))
        badReference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(badDesc, badReference)
        
        
        let good = "Save <b>$1.00</b> on <b>any</b> order!"
        
        
        let goodDesc = Atributika(text: good,
                                  styles: [
                                    "b" : [.font( UIFont.boldSystemFont(ofSize: 14))]
            ],
                                  baseStyle: [
                                    .font( UIFont.systemFont(ofSize: 14)), .foregroundColor(UIColor.red)
            ])
            .buildAttributedString()
        
        let goodReference = NSMutableAttributedString(string: "Save $1.00 on any order!", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.red])
        goodReference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSMakeRange(5, 5))
        goodReference.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSMakeRange(14, 3))
        
        XCTAssertEqual(goodDesc, goodReference)
    }

}
