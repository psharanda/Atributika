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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        Atributika(text: "Hello <br><accent>Wor<b>ld</accent>!!</b>!",
                   tags: [
                    "accent": [
                        
                        .BackgroundColor(UIColor.redColor())
                    ],
                    "b" : [
                        .Font(UIFont.boldSystemFontOfSize(45)),
                    ]
                    
            ]).attributedText
    }
    
}
