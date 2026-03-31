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
        var fileInterface: JSValue { get set }
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

        public var fileInterface: JSValue {
                get {
                        let fileif = KSFileInterface(
                                fileInterface:  mProcess.fileInterface,
                                context:        mContext
                        )
                        return JSValue(object: fileif, in: mContext)
                }
                set(val){
                        if let fileif = KSFileInterface.from(value: val) {
                                mProcess.fileInterface = fileif.core
                        } else {
                                NSLog("[Error] Failed to get file interface at \(#file)")
                        }
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
                let ecode = mProcess.runAndCheckError()
                return JSValue(int32: ecode, in: mContext)
        }

        public func wait() {
                mProcess.waitUntilExit()
        }
}

#endif // os(OSX)

