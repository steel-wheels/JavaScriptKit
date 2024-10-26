/*
 * @file KSJSon.swift
 * @description Define decode and encoder for JSON data
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public class KSJsonDecoder
{
        public struct Member {
                var name:       String
                var value:      KSValue
        }

        public static func parse(tokens: Array<KSToken>) -> Result<KSValue, NSError> {
                var index = 0
                return parse(index: &index, tokens: tokens)
        }
        
        public static func parse(index: inout Int, tokens: Array<KSToken>) -> Result<KSValue, NSError> {
                guard index < tokens.count else {
                        let err = KSError.parseError(message: "Unexpected end of token", line: KSToken.lastLine(tokens: tokens))
                        return .failure(err)
                }
                let line = tokens[index].lineNo
                let result: KSValue
                switch tokens[index].value {
                case .symbol(let sym):
                        switch sym {
                        case "{":
                                switch parseInterface(index: &index, tokens: tokens) {
                                case .success(let value):
                                        return .success(value)
                                case .failure(let err):
                                        return .failure(err)
                                }
                        case "[":
                                switch parseArray(index: &index, tokens: tokens) {
                                case .success(let value):
                                        return .success(value)
                                case .failure(let err):
                                        return .failure(err)
                                }
                        default:
                                let err = KSError.parseError(message: "Unexpected symbol \"\(sym)\"", line: line)
                                return .failure(err)
                        }
                case .identifier(let ident):
                        let err = KSError.parseError(message: "Unexpected identifier \"\(ident)\"", line: line)
                        return .failure(err)
                case .bool(let value):
                        result = KSValue.booleanValue(value)
                case .uint(let value):
                        result = KSValue.uintValue(value)
                case .int(let value):
                        result = KSValue.intValue(value)
                case .float(let value):
                        result = KSValue.floatValue(value)
                case .string(let value):
                        result = KSValue.stringValue(value)
                case .text(let value):
                        result = KSValue.stringValue(value)
                case .comment(let value):
                        result = KSValue.stringValue(value)
                }
                index += 1
                return .success(result)
        }
        
        public static func parseInterface(index: inout Int, tokens: Array<KSToken>) -> Result<KSValue, NSError> {
                let count = tokens.count
                guard index < count else {
                        let err = KSError.parseError(message: "\"{\" is required", line: KSToken.lastLine(tokens: tokens))
                        return .failure(err)
                }
                index += 1

                var members: Dictionary<String, KSValue> = [:]
                loop: while index < count {
                        /* get identifier */
                        let ident: String
                        switch requireIdentifier(index: &index, tokens: tokens){
                        case .success(let str):
                                ident = str
                        case .failure(let err):
                                return .failure(err)
                        }
                        
                        /* get symbol */
                        if let err = requireSymbol(index: &index, tokens: tokens, symbol: ":") {
                                return .failure(err)
                        }
                        
                        /* get value */
                        switch parse(index: &index, tokens: tokens) {
                        case .success(let value):
                                members[ident] = value
                        case .failure(let err):
                                return .failure(err)
                        }
                }
                
                if let err = requireSymbol(index: &index, tokens: tokens, symbol: "}") {
                        return .failure(err)
                } else {
                        return .success(.interfaceValue(name: nil, values: members))
                }
        }
        
        public static func parseArray(index: inout Int, tokens: Array<KSToken>) -> Result<KSValue, NSError> {
                let count = tokens.count
                guard index < count else {
                        let err = KSError.parseError(message: "\"[\" is required", line: KSToken.lastLine(tokens: tokens))
                        return .failure(err)
                }
                index += 1
                
                var result: Array<KSValue> = []
                loop: while index < count {
                        if tokens[index].isSymbol(c: "]") {
                                break loop
                        }
                        switch parse(index: &index, tokens: tokens) {
                        case .success(let val):
                                result.append(val)
                                index += 1
                        case .failure(let err):
                                return .failure(err)
                        }
                }
                
                if let err = requireSymbol(index: &index, tokens: tokens, symbol: "]") {
                        return .failure(err)
                } else {
                        switch KSValue.adjustValueTypes(values: result) {
                        case .success(let (restype, resvals)):
                                return .success(KSValue.arrayValue(elementType: restype, values: resvals))
                        case .failure(let err):
                                return .failure(err)
                        }
                }
        }
        
        private static func requireSymbol(index: inout Int, tokens: Array<KSToken>, symbol expsym: Character) -> NSError? {
                guard index < tokens.count else {
                        let err = KSError.parseError(message: "Symbol \(expsym) is required but no more tokens", line: KSToken.lastLine(tokens: tokens))
                        return err
                }
                let line = tokens[index].lineNo
                switch tokens[index].value {
                case .symbol(let sym):
                        if sym == expsym {
                                index += 1
                        } else {
                                let err = KSError.parseError(message: "Symbol \(expsym) is required but \(sym) was given", line: line)
                                return err
                        }
                default:
                        let err = KSError.parseError(message: "Symbol \(expsym) is required but not given", line: line)
                        return err
                }
                return nil
        }
        
        private static func requireIdentifier(index: inout Int, tokens: Array<KSToken>) -> Result<String, NSError> {
                guard index < tokens.count else {
                        let err = KSError.parseError(message: "Identifier is required", line: KSToken.lastLine(tokens: tokens))
                        return .failure(err)
                }
                let line = tokens[index].lineNo
                switch tokens[index].value {
                case .identifier(let str):
                        index += 1
                        return .success(str)
                default:
                        let err = KSError.parseError(message: "Identifier is required but not given", line: line)
                        return .failure(err)
                }
        }
}
