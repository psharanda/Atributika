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
                    
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        
        XCTAssert(test == reference)
    }
    
    func testEmpty() {
        let test = Atributika(text: "Hello World!!!", tags: [:]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssert(test == reference)
    }
    
    func testBase() {
        let test = Atributika(text: "Hello World!!!", tags: [:], baseAttributes: [.Font(UIFont.boldSystemFontOfSize(45))]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(45)])
        
        XCTAssert(test == reference)
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
                                
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.italicSystemFontOfSize(12)], range: NSMakeRange(2, 3))
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        
        XCTAssert(test == reference)
    }
    
    func testTagsOverlap() {
        let test = Atributika(text: "He<red>llo <b>World</b>!!!</red>",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ],
                                "red" : [
                                    .ForegroundColor(UIColor.redColor()),
                                ]
                                
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSMakeRange(2, 12))
        
        XCTAssert(test == reference)
    }
    
    func testBr() {
        let test = Atributika(text: "Hello<br>World!!!").attributedText
        
        let reference = NSMutableAttributedString(string: "Hello\nWorld!!!")
        
        XCTAssert(test == reference)
    }
    
    func testNotClosedTag() {
        let test = Atributika(text: "Hello <b>World!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssert(test == reference)
    }
    
    func testNotOpenedTag() {
        let test = Atributika(text: "Hello </b>World!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        
        XCTAssert(test == reference)
    }
    
    func testBadTag() {
        
        //TODO: throw error???
        let test = Atributika(text: "Hello <bWorld!!!",
                              tags: [
                                "b" : [
                                    .Font(UIFont.boldSystemFontOfSize(45)),
                                ]
                                
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello ")
        
        XCTAssert(test == reference)
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
                                
            ]).attributedText
        
        let reference = NSMutableAttributedString(string: "Hello World!!!")
        reference.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(45)], range: NSMakeRange(6, 5))
        reference.addAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSMakeRange(8, 3))
        reference.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(10, 1))
        
        XCTAssert(test == reference)
    }
    
}
