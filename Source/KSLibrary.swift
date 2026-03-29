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

        open func load(into ctxt: KSContext, environment env: MIEnvironment) -> NSError? {
                defineBuiltinVariables(into: ctxt, environment: env)
                defineBuiltinFunctions(into: ctxt, environment: env)
                if let err = loadBuiltinLibrary(into: ctxt, environment: env) {
                        NSLog("[Error] \(MIError.errorToString(error: err)) at \(#file)")
                        return err
                }
                return nil
        }

        private func defineBuiltinVariables(into ctxt: KSContext, environment env: MIEnvironment) {
                let envobj = KSEnvironment(environment: env, context: ctxt)
                ctxt.set(name: "env", value: JSValue(object: envobj, in: ctxt))
        }

        private func defineBuiltinFunctions(into ctxt: KSContext, environment env: MIEnvironment) {
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
        }

        private func defineBuiltinConstructor(into ctxt: KSContext, environment env: MIEnvironment) {
                /* allocateURL */
                let allocateURLFunc: @convention(block) (_ pathval: JSValue) -> JSValue = {
                        (_ pathval: JSValue) -> JSValue in
                        return KSURL.allocate(pathval, context: ctxt)
                }
                ctxt.set(name: "allocateURL", function: allocateURLFunc)

                #if os(OSX)
                /* allocateProcess */
                let allocateProcessFunc: @convention(block) () -> JSValue = {
                        () -> JSValue in
                        return KSProcess.allocate(context: ctxt, environment: env)
                }
                ctxt.set(name: "allocateProcess", function: allocateProcessFunc)
                #endif // os(OSX)
        }

        private func loadBuiltinLibrary(into ctxt: KSContext, environment env: MIEnvironment) -> NSError? {
                guard let dir = FileManager.default.resourceDirectory(forClass: KSLibrary.self) else {
                        let err = MIError.error(errorCode: .fileError, message: "No resource directory")
                        return err
                }
                let libfile = dir.appendingPathComponent("Library/Library.js")
                return load(into: ctxt, sourceFile: libfile)
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
