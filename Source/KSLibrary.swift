/**
 * @file        KSLibrary.swift
 * @brief      Define KSLibrary class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

public class KSLibrary
{
        public static func load(into context: KSContext) -> NSError? {
                guard let libdir = FileManager.default.libraryDirectory else {
                        return MIError.error(errorCode: .fileError, message: "Library directory is nnot found", atFile: #file, function: #function)
                }
                let libfile = libdir.appending(path: "Library.js")
                return load(into: context, sourceFile: libfile.appending(path: "Library.js"))
        }

        public static func load(into context: KSContext,  sourceFile src: URL) -> NSError? {
                do {
                        let script = try String(contentsOf: src, encoding: .utf8)
                        context.resetExceptionCount()
                        let _       = context.evaluateScript(script: script, sourceFile: src)
                        if context.exceptionCount > 0 {
                                return nil
                        } else {
                                return MIError.error(errorCode: .fileError, message: "Some exception has been occured at \(src.path)")
                        }
                } catch {
                        return MIError.error(errorCode: .fileError, message: "Failed to load script at \(src.path)")
                }
        }

        public static func defineGlobalVariables(into context: KSContext){
                context.set(name: "_log", function: {
                        (_ val: JSValue) -> JSValue in
                        let result: Bool
                        if let str = val.toString() {
                                NSLog(str)
                                result = true
                        } else {
                                NSLog("[Error] Failed to decode: \(val)")
                                result = false
                        }
                        return JSValue(bool: result, in: context)
                })
        }
}
