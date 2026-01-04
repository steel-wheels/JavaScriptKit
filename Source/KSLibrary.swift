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
                /* define: _log */
                let logFunc: @convention(block) (_ value: JSValue) -> Void = {
                        (_ value: JSValue) -> Void in
                        if let msg = value.toString() {
                                NSLog(msg)
                        } else {
                                NSLog("Unexpected object: \(String(describing: value.toObject()))")
                        }
                }
                ctxt.set(name: "_log", function: logFunc)

                /* define: isUndefined */
                let isUndefinedFunc: @convention(block) (_ value: JSValue) -> JSValue = {
                        (_ value: JSValue) -> JSValue in
                        let result: Bool = value.isUndefined
                        return JSValue(bool: result, in: ctxt)
                }
                ctxt.set(name: "isUndefined", function: isUndefinedFunc)

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
