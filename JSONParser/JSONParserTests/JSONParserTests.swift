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
        
        // invalid number
        parse("+0", shouldBe: .invalidValue)
        parse("+1", shouldBe: .invalidValue)
        parse(".123", shouldBe: .invalidValue)
        parse("1.", shouldBe: .invalidValue)
        parse("INF", shouldBe: .invalidValue)
        parse("inf", shouldBe: .invalidValue)
        parse("NAN", shouldBe: .invalidValue)
        parse("nan", shouldBe: .invalidValue)
    }
    
    func testParseRootNotSingular() {
        parse("null x", shouldBe: .rootNotSingular)
        
        parse("0123", shouldBe: .rootNotSingular)
        parse("0x0", shouldBe: .rootNotSingular)
        parse("0x123", shouldBe: .rootNotSingular)
    }
    
    func testParseBoolean() {
        let trueStr = "true"
        expect(trueStr, shouldBe: .bool)
        parse(trueStr, shouldBe: nil)
        
        let falseStr = "false"
        expect(falseStr, shouldBe: .bool)
        parse(falseStr, shouldBe: nil)
    }
    
    func testParseNumber() {
        parseNumber("0", shouldBe: 0.0)
        parseNumber("-0", shouldBe: 0.0)
        parseNumber("-0.0", shouldBe: 0.0)
        parseNumber("1", shouldBe: 1.0)
        parseNumber("-1", shouldBe: -1.0)
        parseNumber("1.5", shouldBe: 1.5)
        parseNumber("-1.5", shouldBe: -1.5)
        parseNumber("3.1416", shouldBe: 3.1416)
        parseNumber("1E10", shouldBe: 1E10)
        parseNumber("1e10", shouldBe: 1e10)
        parseNumber("1E+10", shouldBe: 1E+10)
        parseNumber("1E-10", shouldBe: 1E-10)
        parseNumber("-1E10", shouldBe: -1E10)
        parseNumber("-1e10", shouldBe: -1e10)
        parseNumber("-1E+10", shouldBe: -1E+10)
        parseNumber("-1E-10", shouldBe: -1E-10)
        parseNumber("1.234E+10", shouldBe: 1.234E+10)
        parseNumber("1.234E-10", shouldBe: 1.234E-10)
        
        parseNumber("1.0000000000000002", shouldBe: 1.0000000000000002)
        parseNumber("4.9406564584124654e-324", shouldBe: 4.9406564584124654e-324)
        parseNumber("-4.9406564584124654e-324", shouldBe: -4.9406564584124654e-324)
        parseNumber("2.2250738585072009e-308", shouldBe: 2.2250738585072009e-308)
        parseNumber("-2.2250738585072009e-308", shouldBe: -2.2250738585072009e-308)
        parseNumber("2.2250738585072014e-308", shouldBe: 2.2250738585072014e-308)
        parseNumber("-2.2250738585072014e-308", shouldBe: -2.2250738585072014e-308)
        parseNumber("1.7976931348623157e+308", shouldBe: 1.7976931348623157e+308)
        parseNumber("-1.7976931348623157e+308", shouldBe: -1.7976931348623157e+308)
        
        // don't know how to process it
        //parseNumber("1e-10000", shouldBe: 0.0)
    }
    
    func testParseString() {
        parseString("\"\"", shouldBe: "")
        parseString("\"Hello\"", shouldBe: "Hello")
    }
    
    func testParseStringMissingQuotationMark() {
        parse("\"", shouldBe: .missQuotationMark)
        parse("\"abc", shouldBe: .missQuotationMark)
    }
    
    func expect(_ jsonString: String, shouldBe type: JSONType) {
        let json = JSON(jsonString)
        XCTAssert(json.type == type)
    }
    
    func parse(_ jsonString: String, shouldBe error: JSONError?) {
        let json = JSON(jsonString)
        XCTAssert(json.error == error)
    }
    
    func parseNumber(_ jsonString: String, shouldBe number: Double) {
        let json = JSON(jsonString)
        parse(jsonString, shouldBe: nil)
        XCTAssert(json.number == number, "\(jsonString) != \(number))")
    }
    
    func parseString(_ jsonString: String, shouldBe string: String) {
        let json = JSON(jsonString)
        parse(jsonString, shouldBe: nil)
        XCTAssert(json.string == string, "\(jsonString) can't be parsed to \(string)")
    }
}
