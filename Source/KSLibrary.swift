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
        public enum BuiltinName: String {
                case standardInputFileHandle    = "standardInputFileHandle"
                case standardOutputFileHandle   = "standardOutputFileHandle"
                case standardErrorFileHandle    = "standardErrorFileHandle"
                case env                        = "env"
                case newProcess                 = "newProcess"
                case newThread                  = "newThread"
                case newURL                     = "newURL"
        }

        public init() {
        }

        open func load(virtualMachine vm: JSVirtualMachine,
                       processFileHandle prochdl: MIProcessFileHandle,
                       environment env: MIEnvVariables) -> Result<KSContext, NSError> {
                let ctxt = KSContext(virtualMachine: vm)
                defineBuiltinVariables(into: ctxt, processFileHandle: prochdl, environment: env)
                defineBuiltinFunctions(into: ctxt, environment: env)
                defineBuiltinConstructor(into: ctxt, environment: env)
                if let err = loadBuiltinLibrary(into: ctxt, environment: env) {
                        NSLog("[Error] \(MIError.errorToString(error: err)) at \(#file)")
                        return .failure(err)
                }
                return .success(ctxt)
        }

        private func defineBuiltinVariables(into ctxt: KSContext,
                                            processFileHandle prochdl: MIProcessFileHandle,
                                            environment env: MIEnvVariables) {
                /* env */
                let envobj = KSEnvVariables(environment: env, context: ctxt)
                ctxt.set(name: BuiltinName.env.rawValue,
                         value: JSValue(object: envobj, in: ctxt))

                /* dstandardInputFileHandle  */
                let inobj = KSFileHandle(fileHandle: prochdl.inputFileHandle, context: ctxt)
                ctxt.set(name: BuiltinName.standardInputFileHandle.rawValue,
                         value: JSValue(object: inobj, in: ctxt))

                /* standardOutputFileHandle  */
                let outobj = KSFileHandle(fileHandle: prochdl.outputFileHandle, context: ctxt)
                ctxt.set(name: BuiltinName.standardOutputFileHandle.rawValue,
                         value: JSValue(object: outobj, in: ctxt))

                /* standardErrorFileHandle  */
                let errobj = KSFileHandle(fileHandle: prochdl.errorFilehandle, context: ctxt)
                ctxt.set(name: BuiltinName.standardErrorFileHandle.rawValue,
                         value: JSValue(object: errobj, in: ctxt))
        }

        private func defineBuiltinFunctions(into ctxt: KSContext, environment env: MIEnvVariables) {
                /* define: isUndefined */
                let isUndefinedFunc: @convention(block) (_ value: JSValue) -> JSValue = {
                        (_ value: JSValue) -> JSValue in
                        let result: Bool = value.isUndefined
                        return JSValue(bool: result, in: ctxt)
                }
                ctxt.set(name: "isUndefined", function: isUndefinedFunc)
        }

        private func defineBuiltinConstructor(into ctxt: KSContext, environment env: MIEnvVariables) {
                /* newURL */
                let allocateURLFunc: @convention(block) (_ pathval: JSValue) -> JSValue = {
                        (_ pathval: JSValue) -> JSValue in
                        return KSURL.allocate(pathval, context: ctxt)
                }
                ctxt.set(name: BuiltinName.newURL.rawValue, function: allocateURLFunc)

                #if os(OSX)
                /* newProcess */
                let newProcessFunc: @convention(block) () -> JSValue = {
                        () -> JSValue in
                        return KSProcess.newProcess(context: ctxt, environment: env)
                }
                ctxt.set(name: BuiltinName.newProcess.rawValue, function: newProcessFunc)
                #endif // os(OSX)

                /* newThread */
                let newThreadFunc: @convention(block) () -> JSValue = {
                        () -> JSValue in
                        return KSThread.newThread(context: ctxt)
                }
                ctxt.set(name: BuiltinName.newThread.rawValue, function: newThreadFunc)
        }

        private func loadBuiltinLibrary(into ctxt: KSContext, environment env: MIEnvVariables) -> NSError? {
                guard let dir = FileManager.default.resourceDirectory(forClass: KSLibrary.self) else {
                        let err = MIError.error(errorCode: .fileError, message: "No resource directory")
                        return err
                }
                let libfiles: Array<URL> = [
                        dir.appendingPathComponent("Library/Library.js"),
                        dir.appendingPathComponent("Library/SetupLibrary.js")
                ]
                for libfile in libfiles {
                        if let err = load(into: ctxt, sourceFile: libfile) {
                                return err
                        }
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
