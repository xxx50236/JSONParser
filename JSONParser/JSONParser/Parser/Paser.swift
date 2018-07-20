//
//  Paser.swift
//  JSONParser
//
//  Created by CB on 2018/7/19.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation

/*
 JSON Syntax:
 
    JSON-text = ws value ws
 
    ws = *(%x20 / %x09 / %x0A / %x0D)
    value = null / false / true
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
}

struct JSON {
    
    private var _type = JSONType.unknown
    
    var type: JSONType {
        return _type
    }
    var error: JSONError? {
        return _error
    }
    
    private let _rawValue: String
    private var _error: JSONError? = nil
    
    init(_ jsonString: String) {
        _rawValue = jsonString
        _error = parse()
    }
    
    private mutating func parse() -> JSONError? {
        
        guard !_rawValue.isEmpty else {
            return .expectValue
        }
        
        var parseError: JSONError?
        let characterSet = CharacterSet.controlCharacters.union(.whitespacesAndNewlines)
        let seperateValue = _rawValue
            .components(separatedBy: characterSet)
            .filter { !$0.isEmpty }
        
        if seperateValue.isEmpty {
            parseError = .expectValue
        } else if seperateValue.count > 1 {
            parseError = .rootNotSingular
        } else {
            switch seperateValue.first! {
            case "null":
                _type = .null
            case "false", "true":
                _type = .bool
            default:
                _type = .unknown
                parseError = .invalidValue
            }
        }
        
        return parseError
    }
}
