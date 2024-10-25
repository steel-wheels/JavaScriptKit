/*
 * @file KSToken.swift
 * @description Define KSToken data structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */


import Foundation

public enum KSTokenValue {
        case symbol(Character)
        case identifier(String)
        case bool(Bool)
        case uInt(UInt)
        case int(Int)
        case double(Double)
        case string(String)
        case text(String)
        case comment(String)
}

public struct KSToken
{
        public var value:       KSTokenValue
        public var lineNo:      Int
        
        public init(_ value: KSTokenValue, at lineNo: Int) {
                self.value  = value
                self.lineNo = lineNo
        }

        public func isSymbol(c: Character) -> Bool {
                switch self.value {
                case .symbol(let sym):
                        return sym == c
                default:
                        return false
                }
        }
        
        public func uIntValue() -> UInt? {
                switch self.value {
                case .uInt(let val):
                        return val
                default:
                        return nil
                }
        }
        
        public func toString() -> String {
                let result: String
                switch self.value {
                case .symbol(let sym):          result = "symbol(\(sym))"
                case .identifier(let ident):    result = "identifier(\(ident))"
                case .bool(let val):            result = "bool(\(val))"
                case .uInt(let val):            result = "uInt(\(val))"
                case .int(let val):             result = "int(\(val))"
                case .double(let val):          result = "double(\(val))"
                case .string(let str):          result = "string(\(str))"
                case .text(let str):            result = "text(\(str))"
                case .comment(let str):         result = "comment(\(str))"
                }
                return result
        }
}

public class KSTokenizer
{
        public static func tokenize(stream strm: KSInputStream) -> Result<Array<KSToken>, NSError> {
                var result: Array<KSToken> = []
                var line:   Int = 0
                loop: while true {
                        switch parseToken(stream: strm, lineNo: &line) {
                        case .success(let tokenp):
                                if let token = tokenp {
                                        result.append(token)
                                } else {
                                        break loop
                                }
                        case .failure(let err):
                                return .failure(err)
                        }
                }
                return .success(replaceTokens(tokens: result))
        }
        
        private static func parseToken(stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                guard let c = skipSpaces(stream: strm, lineNo: &line) else {
                        return .success(nil)
                }
                if c == "0" {
                        return parseHexToken(stream: strm, lineNo: &line)
                } else if let v = c.wholeNumberValue {
                        return parseDecToken(firstChar: UInt(v), stream: strm, lineNo: &line)
                } else if c.isFirstIdentifier {
                        return parseIdentifierToken(firstChar: c, stream: strm, lineNo: &line)
                } else if c == "\"" {
                        return parseStringToken(stream: strm, lineNo: &line)
                } else if c == "/" {
                        return parseCommentToken(stream: strm, lineNo: &line)
                } else if c == "%" {
                        return parseTextToken(stream: strm, lineNo: &line)
                } else {
                        return .success(KSToken(.symbol(c), at: line))
                }
        }
        
        private static func skipSpaces(stream strm: KSInputStream, lineNo line: inout Int) -> Character? {
                var result: Character? = nil
                while let c = strm.getc() {
                        if c.isNewline {
                                line += 1
                        } else if !c.isWhitespace {
                                result = c
                                break
                        }
                }
                return result
        }
        
        private static func parseHexToken(stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                guard let c = strm.getc() else {
                        return .success(KSToken(.uInt(0), at: line))
                }
                let result:Result<KSToken?, NSError>
                switch c {
                case "x", "X":
                        var value: UInt = 0
                        var valid = false
                        while let c = strm.getc() {
                                if let v = c.hexDigitValue {
                                        value = value * 16 + UInt(v)
                                        valid = true
                                } else {
                                        let _ = strm.ungetc()
                                        break
                                }
                        }
                        if valid {
                                result = .success(KSToken(.uInt(value), at: line))
                        } else {
                                let err = KSError.parseError(message: "Invalid hex value at line \(line)")
                                result = .failure(err)
                        }
                default:
                        result = .success(KSToken(.uInt(0), at: line))
                }
                return result
        }
        
        private static func parseDecToken(firstChar fval: UInt, stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                var result: UInt = fval
                while let c = strm.getc() {
                        if let v = c.wholeNumberValue {
                                result = result * 10 + UInt(v)
                        } else {
                                let _ = strm.ungetc()
                                break
                        }
                }
                return .success(KSToken(.uInt(result), at: line))
        }
        
        private static func parseIdentifierToken(firstChar fc: Character, stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                var result: String = String(fc)
                while let c = strm.getc() {
                        if c.isMiddleIdentifier {
                                result += String(c)
                        } else {
                                let _ = strm.ungetc()
                                break
                        }
                }
                return .success(KSToken(.string(result), at: line))
        }
        
        private static func parseStringToken(stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                var result: String = ""
                var closed = false
                let ln     = line
                loop: while let c = strm.getc() {
                        switch c {
                        case "\"":
                                closed = true
                                break loop
                        case "\\":
                                switch escapedString(stream: strm, lineNo: &line) {
                                case .success(let str):
                                        result += str
                                case .failure(let err):
                                        return .failure(err)
                                }
                        default:
                                result.append(c)
                        }
                }
                if closed {
                        return .success(KSToken(.string(result), at: line))
                } else {
                        let err = KSError.parseError(message: "The string is not closed at line \(ln)")
                        return .failure(err)
                }
        }
       
        // called after "/"
        private static func parseCommentToken(stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                guard let c = strm.getc() else {
                        return .success(KSToken(.symbol("/"), at: line))
                }
                if c == "/" {
                        var comment: String = ""
                        while let c = strm.getc() {
                                if c.isNewline {
                                        break
                                } else {
                                        comment += String(c)
                                }
                        }
                        return .success(KSToken(.comment(comment), at: line))
                } else {
                        let _ = strm.ungetc()
                        return .success(KSToken(.symbol("/"), at: line))
                }
        }
        
        // called after "%"
        private static func parseTextToken(stream strm: KSInputStream, lineNo line: inout Int) -> Result<KSToken?, NSError> {
                guard let c = strm.getc() else {
                        return .success(KSToken(.symbol("%"), at: line))
                }
                if c != "{" {
                        let _ = strm.ungetc()
                                return .success(KSToken(.symbol("%"), at: line))
                }
                var text = ""
                loop: while let c = strm.getc() {
                        switch c {
                        case "%":
                                if let nc = strm.getc() {
                                        if nc == "}" {
                                                break loop
                                        } else {
                                                let _ = strm.ungetc()
                                                text += String(c)
                                        }
                                } else {
                                        text += String(c)
                                }
                        default:
                                text += String(c)
                        }
                }
                return .success(KSToken(.text(text), at: line))
        }

        private static func escapedString(stream strm: KSInputStream, lineNo line: inout Int) -> Result<String, NSError> {
                if let c = strm.getc() {
                        let result: Character?
                        switch c {
                        case "n":       result = Character.newline
                        case "'":       result = Character.singleQuotation
                        case "\"":      result = Character.quotation
                        case "\\":      result = Character.backslash
                        case "t":       result = Character.tab
                        case "0":       result = Character.null
                        case "r":       result = Character.carriageReturn
                        default:        result = nil
                        }
                        if let resc = result {
                                return .success(String(resc))
                        } else {
                                return .success("\\" + String(c))
                        }
                } else {
                        let err = KSError.parseError(message: "Invalid escape sequence at line \(line)")
                        return .failure(err)
                }
        }
        
        private static func replaceTokens(tokens src: Array<KSToken>) ->Array<KSToken> {
                let dst0 = replaceByBooleanToken(tokens: src)
                let dst1 = replaceByNegativeToken(tokens: dst0)
                let dst2 = replaceByDoubleToken(tokens: dst1)
                return dst2
        }
        
        private static func replaceByBooleanToken(tokens src: Array<KSToken>) ->Array<KSToken> {
                var dst: Array<KSToken> = []
                for token in src {
                        switch token.value {
                        case .identifier(let ident):
                                if ident == "true" {
                                        dst.append(KSToken(.bool(true), at: token.lineNo))
                                } else if ident == "false" {
                                        dst.append(KSToken(.bool(false), at: token.lineNo))
                                } else {
                                        dst.append(token)
                                }
                        default:
                                dst.append(token)
                        }
                }
                return dst
        }
        
        /* replace "-" + int by negative int */
        private static func replaceByNegativeToken(tokens src: Array<KSToken>) ->Array<KSToken> {
                var result: Array<KSToken> = []
                var doskip = 0
                let count = src.count
                for i in 0..<count {
                        if doskip > 0 {
                                doskip -= 1
                                continue
                        }
                        if src[i].isSymbol(c: "-") {
                                if i+1 < count {
                                        switch src[i+1].value {
                                        case .uInt(let val):
                                                result.append(KSToken(.int(-Int(val)), at: src[i].lineNo))
                                                doskip = 1
                                        case .int(let val):
                                                result.append(KSToken(.int(-val), at: src[i].lineNo))
                                                doskip = 1
                                        default:
                                                result.append(src[i])
                                        }
                                } else {
                                        result.append(src[i])
                                }
                        } else {
                                result.append(src[i])
                        }
                }
                return result
        }
        
        /* replace int + "." + int by double value */
        private static func replaceByDoubleToken(tokens src: Array<KSToken>) ->Array<KSToken> {
                var result: Array<KSToken> = []
                var doskip = 0
                let count = src.count
                for i in 0..<count {
                        if doskip > 0 {
                                doskip -= 1
                                continue
                        }
                        switch src[i].value {
                        case .uInt(let val):
                                if i + 2 < count {
                                        if src[i+1].isSymbol(c: "."), let fval = src[i+2].uIntValue() {
                                                let dstr = "\(val).\(fval)"
                                                if let dval = Double(dstr) {
                                                        result.append(KSToken(.double(dval), at: src[i].lineNo))
                                                        doskip = 2
                                                } else {
                                                        NSLog("Failed to convert to double: \(dstr)")
                                                        result.append(src[i])
                                                }
                                        } else {
                                                result.append(src[i])
                                        }
                                } else {
                                        result.append(src[i])
                                }
                        case .int(let val):
                                if i + 2 < count {
                                        if src[i+1].isSymbol(c: "."), let fval = src[i+2].uIntValue() {
                                                let dstr = "\(val).\(fval)"
                                                if let dval = Double(dstr) {
                                                        result.append(KSToken(.double(dval), at: src[i].lineNo))
                                                        doskip = 2
                                                } else {
                                                        NSLog("Failed to convert to double: \(dstr)")
                                                        result.append(src[i])
                                                }
                                        } else {
                                                result.append(src[i])
                                        }
                                } else {
                                        result.append(src[i])
                                }
                        default:
                                result.append(src[i])
                        }
                }
                return result
        }
}
