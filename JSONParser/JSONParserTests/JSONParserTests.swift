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
        
        let nullStr = "null"
        
        expect(nullStr, shouldBe: .null)
        parse(nullStr, shouldBe: nil)
    }
    
    func testParseExpectValue() {
        parse("", shouldBe: .expectValue)
        parse(" ", shouldBe: .expectValue)
    }
    
    func testParseInvalidValue() {
        parse("nul", shouldBe: .invalidValue)
        parse("?", shouldBe: .invalidValue)
    }
    
    func testParseRootNotSingular() {
        parse("null x", shouldBe: .rootNotSingular)
    }
    
    func testParseBoolean() {
        let trueStr = "true"
        expect(trueStr, shouldBe: .bool)
        parse(trueStr, shouldBe: nil)
        
        let falseStr = "false"
        expect(falseStr, shouldBe: .bool)
        parse(falseStr, shouldBe: nil)
    }
    
    func expect(_ jsonString: String, shouldBe type: JSONType) {
        let json = JSON(jsonString)
        XCTAssert(json.type == type)
    }
    
    func parse(_ jsonString: String, shouldBe error: JSONError?) {
        let json = JSON(jsonString)
        XCTAssert(json.error == error)
    }
}
