/*
 * @file UTStringStream.swift
 * @description Unit test for KSStringStream class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import JavaScriptKit
import Foundation

public func testStringStream() -> Bool
{
        var result = true
        let url  = URL(filePath: "data.json")
        do {
                let text = try String(contentsOf: url, encoding: .utf8)
                //print("test: \(text)")
                print("START")
                let stream = KSStringStream(string: text)
                //while let c = stream.getc() {
                //        print(c)
                //}
                switch KSTokenizer.tokenize(stream: stream) {
                case .success(let tokens):
                        for token in tokens {
                                print(token.toString())
                        }
                case .failure(let err):
                        print("[Error] " + KSError.errorToString(error: err))
                }
                print("END")
        } catch {
                print("[Error] Failed to load data")
                result = false
        }
        return result
}
