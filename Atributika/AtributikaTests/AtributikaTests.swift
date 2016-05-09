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
                   tags: [
                    "b" : [
                        .Font(UIFont.boldSystemFontOfSize(45)),
                    ]
                    
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        
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
        
        let referenceTags = [TagInfo(name: "a", attributes: ["href":"http://google.com"], range: 0..<5)]
        XCTAssertEqual(tags, referenceTags)
    }
    
    func testBase() {
        let test = Atributika(text: "Hello World!!!", tags: [:], baseAttributes: [.Font(UIFont.boldSystemFontOfSize(45))]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(45)])
        
        XCTAssertEqual(test, reference)
    }
    
    func testManyTags() {
        let test = Atributika(text: "He<i>llo</i> <b>World</b>!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ],
                                "i" : [
                                    .Font(UIFont.italicSystemFontOfSize(12)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.italicSystemFontOfSize(12)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testManySameTags() {
        let test = Atributika(text: "He<b>llo</b> <b>World</b>!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsOverlap() {
        let test = Atributika(text: "Hello <b>W<red>orld</b>!!!</red>",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ],
                                "red" : [
                                    .ForegroundColor(UIColor.redColor()),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSMakeRange(7, 7))
        
        XCTAssertEqual(test, reference)
    }
    
    func testBr() {
        let test = Atributika(text: "Hello<br>World!!!").buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotClosedTag() {
        let test = Atributika(text: "Hello <b>World!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testNotOpenedTag() {
        let test = Atributika(text: "Hello </b>World!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssertEqual(test, reference)
    }
    
    func testBadTag() {
        
        //TODO: throw error???
        let test = Atributika(text: "Hello <bWorld!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello ")
        
        XCTAssertEqual(test, reference)
    }
    
    func testTagsStack() {
        let test = Atributika(text: "Hello <b>Wo<red>rl<u>d</u></red></b>!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ],
                                "red" : [
                                    .ForegroundColor(UIColor.redColor())
                                ],
                                "u" : [
                                    .UnderlineStyle(.StyleSingle)
                                ]
                                
            ]).buildAttributedString()
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSMakeRange(8, 3))
        reference.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(10, 1))
        
        XCTAssertEqual(test, reference)
    }
    
}
