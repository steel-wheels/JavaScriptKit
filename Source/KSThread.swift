/**
 * @file        KSThread.swift
 * @brief      Define KSThread class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

public class KSScriptThread: MIFileThread
{
        private var mScript:    String
        private var mContext:   KSContext

        public init(context ctxt: KSContext) {
                mScript  = ""
                mContext = ctxt
        }

        public var script: String {
                get      { return mScript }
                set(scr) { mScript = scr  }
        }

        open override func main() {
                let ecode: Int32
                if let url = self.executableURL {
                        switch url.loadText() {
                        case .success(let scr):
                                ecode = execScript(script: scr)
                        case .failure(let err):
                                error(string: MIError.errorToString(error: err))
                                ecode = -1
                        }
                } else if !mScript.isEmpty {
                        ecode = execScript(script: mScript)
                } else {
                        error(string: "[Error] No script to execute\n")
                        ecode = -1
                }
                self.exitCode = ecode
        }

        private func execScript(script scr: String) -> Int32 {
                var result: Int32 = 0
                mContext.evaluateScript(scr)
                if let mainfunc = mContext.get(name: "main") {
                        /* allocate arguments value */
                        var args: Array<JSValue> = []
                        for arg in self.arguments {
                                args.append(JSValue(object: arg as NSString, in: mContext))
                        }
                        /* Call main function */
                        if let retval = mainfunc.call(withArguments: [args]) {
                                result = retval.toInt32()
                        } else {
                                error(string: "Failed to call main function\n")
                                result = -1
                        }
                }
                return result
        }
}

@objc public protocol KSThreadProtocol: JSExport
{
        var standardInput:  JSValue { get set }
        var standardOutput: JSValue { get set }
        var standardError:  JSValue { get set }

        var arguments:      JSValue { get set }

        var script:         JSValue { get set }
        var executableURL:  JSValue { get set }

        var isRunning: JSValue { get }
        var exitCode: JSValue { get }

        func start()
}

@objc public class KSThread: NSObject, KSThreadProtocol
{
        private var mThread:    KSScriptThread
        private var mContext:   KSContext

        public static func newThread(context ctxt: KSContext) -> JSValue {
                let thread = KSScriptThread(context: ctxt)
                let object = KSThread(thread: thread, context: ctxt)
                return JSValue(object: object, in: ctxt)
        }

        public init(thread thd: KSScriptThread, context ctxt: KSContext) {
                mThread  = thd
                mContext = ctxt
        }

        public var standardInput:  JSValue {
                get     { return fileHandleToValue(mThread.standardInput) }
                set(val){ mThread.standardInput = valueToFileHandle(val)  }
        }

        public var standardOutput:  JSValue {
                get     { return fileHandleToValue(mThread.standardOutput) }
                set(val){ mThread.standardOutput = valueToFileHandle(val)  }
        }

        public var standardError:  JSValue {
                get     { return fileHandleToValue(mThread.standardError) }
                set(val){ mThread.standardError = valueToFileHandle(val)  }
        }

        public var arguments: JSValue {
                get {
                        let arr = NSMutableArray(capacity: 8)
                        for arg in mThread.arguments {
                                arr.add(arg as NSString)
                        }
                        return JSValue(object: arr, in: mContext)
                }
                set(args){
                        if let arr = args.toArray() {
                                var result: Array<String> = []
                                for obj in arr {
                                        if let str = obj as? String {
                                                result.append(str)
                                        } else {
                                                NSLog("[Error] Invalid array element")
                                        }
                                }
                                mThread.arguments = result
                        } else {
                                NSLog("[Error] Array parameter required")
                        }
                }
        }

        public var executableURL:  JSValue {
                get {
                        if let url = mThread.executableURL {
                                let obj = KSURL(URL: url, context: mContext)
                                return JSValue(object: obj, in: mContext)
                        } else {
                                return JSValue(nullIn: mContext)
                        }
                }
                set(val) {
                        if let url = val.toObject() as? KSURL {
                                mThread.executableURL = url.core
                        } else if val.isNull {
                                mThread.executableURL = nil
                        } else {
                                NSLog("[Error] URL parameter required")
                        }
                }
        }

        public var script: JSValue {
                get { return JSValue(object: mThread.script, in: mContext ) }
                set(val) {
                        if let str = val.toString() {
                                mThread.script = str
                        } else {
                                NSLog("[Error] Unexpected type for script")
                        }
                }
        }

        public func start() {
                mThread.start()
        }

        public var isRunning: JSValue { get {
                return JSValue(bool: mThread.isRunning, in: mContext)
        }}

        public var exitCode: JSValue { get {
                return JSValue(int32: Int32(mThread.exitCode), in: mContext)
        }}

        private func fileHandleToValue(_ hdl: FileHandle) -> JSValue {
                let obj = KSFileHandle(fileHandle: hdl, context: mContext)
                return JSValue(object: obj, in: mContext)
        }

        private func valueToFileHandle(_ val: JSValue) -> FileHandle {
                if let hdl = val.toObject() as? KSFileHandle {
                        return hdl.core
                } else {
                        NSLog("[Error] FileHandle value is requires")
                        return FileHandle.standardError
                }
        }
}

