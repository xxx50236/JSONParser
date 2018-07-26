//
//  Paser.swift
//  JSONParser
//
//  Created by CB on 2018/7/19.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation
import UIKit

/*
 JSON Syntax:
 
    JSON-text = ws value ws
 
    ws = *(%x20 / %x09 / %x0A / %x0D)
    value = null / false / true / number
    null  = "null"
    false = "false"
    true  = "true"
 
 */

enum JSONType {
    case null
    case bool
    case number
    case string
    case array
    case object
    case unknown
}

enum JSONError: Error {
    case expectValue
    case invalidValue
    case rootNotSingular
    case missQuotationMark
//    case invalidStringEscape
//    case invalidStringCharacter
}

struct JSON {
    
    private var _type = JSONType.unknown
    
    var type: JSONType {
        return _type
    }
    var error: JSONError? {
        return _error
    }
    
    var number: Double? {
        guard _type == .number else {
            return nil
        }
        return _rawNumber
    }
    
    var bool: Bool? {
        guard _type == .bool else {
            return nil
        }
        return _rawBool
    }
    
    var string: String? {
        guard _type == .string else {
            return nil
        }
        return _rawString
    }
    
    private let _rawValue: String
    
    private var _rawNumber: Double?
    private var _rawBool: Bool?
    private var _rawString: String?
    
    private var _error: JSONError? = nil
    
    init(_ jsonString: String) {
        _rawValue = jsonString
        _error = parse()
    }
    
    private mutating func parse() -> JSONError? {
        
        guard !_rawValue.isEmpty else {
            return .expectValue
        }
        
        let characterSet = CharacterSet.controlCharacters.union(.whitespacesAndNewlines)
        let seperateValue = _rawValue
            .components(separatedBy: characterSet)
            .filter { !$0.isEmpty }
        
        if seperateValue.isEmpty {
            return .expectValue
        } else if seperateValue.count > 1 {
            return .rootNotSingular
        }

        return parseValue(_rawValue)
    }
}

extension JSON {
    private mutating func parseValue(_ value: String) -> JSONError? {
        
        var parseError: JSONError?
        
        if value == "null" {
            _type = .null
        } else if value == "false" || value == "true" {
            _type = .bool
            _rawBool = value == "true"
        } else if String(value.first!).rangeOfCharacter(from: CharacterSet(charactersIn: "-0123456789")) != nil {
            
            parseError = parseNumber(value)
        } else if value.first == "\"" {
            parseError = parseString(value)
        } else {
            _type = .unknown
            parseError = .invalidValue
        }
        
        return parseError
    }
}

extension JSON {
    private mutating func parseString(_ value: String) -> JSONError? {
        guard value.first == "\"" && value.last == "\"" && value.count > 1 else {
            return .missQuotationMark
        }
        
        let range = Range(NSRange(location: 1, length: value.count - 2), in: value)!
        _type = .string
        _rawString = String(value[range])
        return nil
    }
}

extension JSON {
    private mutating func parseNumber(_ value: String) -> JSONError? {
        
        var parseError: JSONError?
        let numberArray = Array(value)
        var startIndex: Int = 0
        
        if let number = numberArray[safe: startIndex], number == "-" {
            startIndex += 1
        }
        
        if let number = numberArray[safe: startIndex], number == "0" {
            startIndex += 1
        } else if let number = numberArray[safe: startIndex], isDigit1to9(number) {
            startIndex += 1
            while let anotherNumber = numberArray[safe: startIndex], isDigit(anotherNumber) {
                startIndex += 1
            }
        } else {
            parseError = .invalidValue
        }
        
        if let number = numberArray[safe: startIndex], number == "." {
            startIndex += 1
            parseError = passDigit(numberArray: numberArray, startIndex: &startIndex)
        }
        
        if let number = numberArray[safe: startIndex], number == "e" || number == "E" {
            startIndex += 1
            
            if let number = numberArray[safe: startIndex], number == "+" || number == "-" {
                startIndex += 1
            }
            parseError = passDigit(numberArray: numberArray, startIndex: &startIndex)
        }
        
        if startIndex != numberArray.count {
            parseError = .rootNotSingular
        } else if let decimalNumber = Double(_rawValue) {
            _type = .number
            _rawNumber = decimalNumber
        } else {
            parseError = .invalidValue
        }
        
        return parseError
    }
    
    private func passDigit(numberArray: [Character], startIndex: inout Int) -> JSONError? {
        if let anotherNumber = numberArray[safe: startIndex], isDigit(anotherNumber) {
            while let anotherNumber = numberArray[safe: startIndex], isDigit(anotherNumber) {
                startIndex += 1
            }
        } else {
            return .invalidValue
        }
        
        return nil
    }
    
    private func isDigit1to9(_ ch: Character) -> Bool {
        return ch >= "1" && ch <= "9"
    }
    
    private func isDigit(_ ch: Character) -> Bool {
        return ch >= "0" && ch <= "9"
    }
}
