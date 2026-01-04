/**
 * @file        KSLibrary.swift
 * @brief      Define KSLibrary class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

open class KSLibrary
{
        public init() {

        }

        open func load(into ctxt: KSContext) -> NSError? {
                guard let libdir = FileManager.default.libraryDirectory(forClass: KSLibrary.self) else {
                        return MIError.error(errorCode: .fileError, message: "Library directory is nnot found", atFile: #file, function: #function)
                }

                /* load Library.js */
                if let err = load(into: ctxt, sourceFile: libdir.appending(path: "Library.js")) {
                        return err
                }

                /* load Boot.js */
                if let err = load(into: ctxt, sourceFile: libdir.appending(path: "Boot.js")) {
                        return err
                }

                return nil
        }

        public func load(into context: KSContext,  sourceFile src: URL) -> NSError? {
                do {
                        let script = try String(contentsOf: src, encoding: .utf8)
                        context.resetErrorCount()
                        let _ = context.evaluateScript(script, withSourceURL: src)
                        if context.errorCount == 0 {
                                return nil
                        } else {
                                return MIError.error(errorCode: .fileError, message: "Some exception has been occured at \(src.path)")
                        }
                } catch {
                        return MIError.error(errorCode: .fileError, message: "Failed to load script at \(src.path)")
                }
        }
}
