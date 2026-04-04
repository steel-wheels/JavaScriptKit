/**
 * @file        KSProcess.swift
 * @brief      Define KSProcess class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

#if os(OSX)

@objc public protocol KSProcessProtocol: JSExport
{
        var standardInput: JSValue { get set }
        var standardOutput: JSValue { get set }
        var standardError: JSValue { get set }

        func run() -> JSValue
        func wait()
}

@objc public class KSProcess: NSObject, KSProcessProtocol
{
        private var mProcess:           Process
        private var mContext:           KSContext

        static public func allocate(context ctxt: KSContext, environment env: MIEnvironment) -> JSValue{
                let proccore = Process(environment: env)
                let newproc  = KSProcess(process: proccore, context: ctxt)
                return JSValue(object: newproc, in: ctxt)
        }

        public init(process proc: Process, context ctxt: KSContext) {
                mProcess        = proc
                mContext        = ctxt
        }

        public var standardInput: JSValue {
                get {
                        let hdlval = KSFileHandle(fileHandle: self.inputFileHandle, context: mContext)
                        return JSValue(object: hdlval, in: mContext)
                }
                set(val){
                        if let hdl = valueToFileHandle(fileHandle: val) {
                                mProcess.standardInput = hdl
                        } else {
                                NSLog("[Error] Failed to set input file handle at \(#file)")
                        }
                }
        }

        public var standardOutput: JSValue {
                get {
                        let hdlval = KSFileHandle(fileHandle: self.outputFileHandle, context: mContext)
                        return JSValue(object: hdlval, in: mContext)
                }
                set(val){
                        if let hdl = valueToFileHandle(fileHandle: val) {
                                mProcess.standardOutput = hdl
                        } else {
                                NSLog("[Error] Failed to set output file handle at \(#file)")
                        }
                }
        }

        public var standardError: JSValue {
                get {
                        let hdlval = KSFileHandle(fileHandle: self.errorFileHandle, context: mContext)
                        return JSValue(object: hdlval, in: mContext)
                }
                set(val){
                        if let hdl = valueToFileHandle(fileHandle: val) {
                                mProcess.standardError = hdl
                        } else {
                                NSLog("[Error] Failed to set error file handle at \(#file)")
                        }
                }
        }

        private var inputFileHandle: FileHandle { get {
                if let hdl = mProcess.standardInput as? FileHandle {
                        return hdl
                } else {
                        return FileHandle.standardInput
                }
        }}

        private var outputFileHandle: FileHandle { get {
                if let hdl = mProcess.standardOutput as? FileHandle {
                        return hdl
                } else {
                        return FileHandle.standardOutput
                }
        }}

        private var errorFileHandle: FileHandle { get {
                if let hdl = mProcess.standardError as? FileHandle {
                        return hdl
                } else {
                        return FileHandle.standardError
                }
        }}

        private func valueToFileHandle(fileHandle val: JSValue) -> FileHandle? {
                if let obj = val.toObject() as? KSFileHandle {
                        return obj.core
                } else {
                        return nil
                }
        }

        public var executableURL: JSValue {
                get {
                        if let url = mProcess.executableURL {
                                let obj = KSURL(URL: url, context: mContext)
                                return JSValue(object: obj, in: mContext)
                        } else {
                                return JSValue(nullIn: mContext)
                        }
                }
                set(val){
                        if let urlobj = KSURL.from(value: val) {
                                mProcess.executableURL = urlobj.core
                        } else {
                                NSLog("[Error] Failed to get URL at \(#file)")
                        }
                }
        }

        public var arguments: JSValue {
                get {
                        if let args = mProcess.arguments {
                                let objs = args.map{ $0 as NSString }
                                let arr  = NSArray(array: objs)
                                return JSValue(object: arr, in: mContext)
                        } else {
                                return JSValue(newArrayIn: mContext)
                        }
                }
                set(val) {
                        if let arr = val.toObject() as? Array<NSString> {
                                let strs = arr.map { $0 as String }
                                mProcess.arguments = strs
                        } else {
                                NSLog("[Error] Failed to get arguments at \(#file)")
                        }
                }
        }

        public func run() -> JSValue {
                let pid = mProcess.tryRun()
                if pid >= 0 {
                        return JSValue(int32: pid, in: mContext)
                } else {
                        return JSValue(nullIn: mContext)
                }
        }

        public func wait() {
                mProcess.waitUntilExit()
        }
}

#endif // os(OSX)

