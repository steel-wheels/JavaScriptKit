/*
 * @file KSText.swift
 * @description Define KSText classes
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public enum KSTextType {
        case word
        case line
        case lines
}

public protocol KSText
{
        var type: KSTextType { get }
        func toString() -> String
}

public extension KSText {
        func generate(from texts: Array<KSText>) -> KSText {
                var words: Array<KSWord> = []
                var lines: Array<KSLine> = []
                let result: KSLines = KSLines()
                
                for text in texts {
                        switch text.type {
                        case .word:
                                if let word = text as? KSWord {
                                        words.append(word)
                                } else {
                                        NSLog("Can not happen: word")
                                }
                        case .line:
                                if let line = flush(words: words) {
                                        lines.append(line) ; words = []
                                }
                                if let line = text as? KSLine {
                                        lines.append(line)
                                } else {
                                        NSLog("Can not happen: line")
                                }
                        case .lines:
                                if let line = flush(words: words) {
                                        lines.append(line) ; words = []
                                }
                                for line in lines {
                                        result.append(line: line)
                                }
                        }
                }
                if let line = flush(words: words) {
                        lines.append(line) ; words = []
                }
                for line in lines {
                        result.append(line: line)
                }
                return result
        }
        
        private func flush(words: Array<KSWord>) -> KSLine? {
                if words.count > 0 {
                        return KSLine(words: words)
                } else {
                        return nil
                }
        }
}

public class KSWord: KSText
{
        private var mString: String
        
        public var type: KSTextType { get { return .word }}

        public init(word: String) {
                mString = word
        }
        
        public func toString() -> String {
                return mString
        }
}

public class KSLine: KSText
{
        private var mWords: Array<KSWord>
        
        public var type: KSTextType { get { return .line }}
        
        public init() {
                mWords = []
        }
        
        public init(words: Array<KSWord>){
                mWords = words
        }

        public func append(word: KSWord) {
                mWords.append(word)
        }

        public func toString() -> String {
                var result: String = ""
                var is1st = true
                for word in mWords {
                        if is1st { is1st = false } else { result += " "}
                        result += word.toString()
                }
                return result
        }
}

public class KSLines: KSText
{
        private var mLines: Array<KSLine>
        
        public var type: KSTextType { get { return .lines }}
        
        public init(){
                mLines = []
        }
        
        public init(lines: Array<KSLine>){
                mLines = lines
        }
        
        public func append(line: KSLine) {
                mLines.append(line)
        }
        
        public func append(lines: KSLines) {
                mLines.append(contentsOf: lines.mLines)
        }

        public func toString() -> String {
                var result: String = ""
                var is1st = true
                for line in mLines {
                        if is1st { is1st = false } else { result += "\n" }
                        result += line.toString()
                }
                return result
        }
}


