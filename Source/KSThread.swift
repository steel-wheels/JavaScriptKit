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
                if !mScript.isEmpty {
                        mContext.evaluateScript(mScript)
                } else {
                        error(string: "[Error] No script to execute\n")
                        self.exitCode = -1
                }
        }
}

@objc public protocol KSThreadProtocol: JSExport
{
        var standardInput:  JSValue { get set }
        var standardOutput: JSValue { get set }
        var standardError:  JSValue { get set }
        var script:         JSValue { get set }

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

