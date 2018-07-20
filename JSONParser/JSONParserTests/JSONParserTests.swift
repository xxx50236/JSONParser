//
//  JSONParserTests.swift
//  JSONParserTests
//
//  Created by CB on 2018/7/19.
//  Copyright © 2018 com. All rights reserved.
//

import XCTest
@testable import JSONParser

class JSONParserTests: XCTestCase {
    
    func testParseNULL() {
        let json = JSON("null")
        
        XCTAssert(json.type == .null)
        XCTAssertNil(json.error)
    }
    
    func testParseExpectValue() {
        let json1 = JSON("")
        XCTAssert(json1.error == .expectValue)
        
        let json2 = JSON(" ")
        XCTAssert(json2.error == .expectValue)
    }
    
    func testParseInvalidValue() {
        let json1 = JSON("nul")
        XCTAssert(json1.error == .invalidValue)
    
        let json2 = JSON("?")
        XCTAssert(json2.error == .invalidValue)
    }
    
    func testParseRootNotSingular() {
        let json1 = JSON("null x")
        XCTAssert(json1.error == .rootNotSingular)
    }
}
