/**
 * @file        KSContext.swift
 * @brief      Define KSContext class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import Foundation
import JavaScriptCore

public class KSException
{
        private var mContext    : JSContext
        private var mValue      : JSValue?

        public init(context ctxt: JSContext, value val: JSValue?) {
                mContext        = ctxt
                mValue          = val
        }

        public init(context ctxt: JSContext, message msg: String) {
                mContext        = ctxt
                mValue          = JSValue(object: msg, in: ctxt)
        }

        public var description: String {
                get {
                        if let val = mValue {
                                return val.toString()
                        } else {
                                return "nil"
                        }
                }
        }
}

public class KSContext: JSContext
{
        public typealias ExceptionCallback =  (_ exception: KSException) -> Void

        public var exceptionCallback    : ExceptionCallback
        private var mErrorCount         : Int

        public var errorCount: Int { get { return mErrorCount }}
        public func resetErrorCount() {
                mErrorCount = 0
        }

        public override init(virtualMachine vm: JSVirtualMachine?) {
                exceptionCallback = {
                        (_ exception: KSException) -> Void in
                        NSLog("[Exception]  \(exception.description) at \(#file)")
                }
                mErrorCount                = 0
                super.init(virtualMachine: vm)

                /* Set handler */
                self.exceptionHandler = {
                        [weak self] (context, exception) in
                        if let myself = self, let ctxt = context as? KSContext {
                                let except = KSException(context: ctxt, value: exception)
                                myself.exceptionCallback(except)
                                myself.mErrorCount += 1
                        } else {
                                NSLog("[Error] No context at \(#file)")
                        }
                }
        }

        public func loadScript(from url: URL) -> NSError? {
                do {
                        let text = try String(contentsOf: url, encoding: .utf8)
                        let orgcnt = self.mErrorCount
                        let _ = self.evaluateScript(text)
                        let newcnt = self.mErrorCount
                        if orgcnt == newcnt {
                                return nil
                        } else {
                                return MIError.error(errorCode: .parseError, message: "Evaluaation error")
                        }
                } catch {
                        return MIError.error(errorCode: .fileError,
                                             message: "Failed to load from URL \(url.path)")
                }
        }

        public func set(name n: String, object o: JSExport){
                self.setObject(o, forKeyedSubscript: NSString(string: n))
        }

        public func set(name n: String, value val: JSValue){
                self.setObject(val, forKeyedSubscript: NSString(string: n))
        }

        public func set(name n: String, function obj: Any){
                if let val = JSValue(object: obj, in: self){
                        set(name: n, value: val)
                } else {
                        NSLog("[Error] Failed to allocate value at \(#file)")
                }
        }

        public func get(name n: String) -> JSValue? {
                if let obj = self.objectForKeyedSubscript(NSString(string: n)) {
                        return obj.isUndefined ? nil : obj
                } else {
                        return nil
                }
        }
}
