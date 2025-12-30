/**
 * @file        KSContext.swift
 * @brief      Define KSContext class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import Foundation
import JavaScriptCore

public class KSContext : JSContext
{
        public typealias ExceptionCallback =  (_ exception: JSValue?) -> Void

        public  var exceptionCallback           : ExceptionCallback
        private var mExceptionCount                 : Int

        public var exceptionCount: Int { get { return mExceptionCount }}

        public override init(virtualMachine vm: JSVirtualMachine) {
                exceptionCallback = {
                        (_ exception: JSValue?) -> Void in
                        NSLog("[JavaScript Exception] \(String(describing: exception))")
                }
                mExceptionCount = 0
                super.init(virtualMachine: vm)

                /* Set handler */
                self.exceptionHandler = {
                        [weak self] (context, value) in
                        if let myself = self {
                                myself.exceptionCallback(value)
                                myself.mExceptionCount += 1
                        } else {
                                NSLog("[JavaScript Exception] Failed to generate exception")
                        }
                }
        }

        public func resetExceptionCount() {
                mExceptionCount = 0
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
                        NSLog("[Error] Failed to set function at \(#file)")
                }
        }

        public func get(name n: String) -> JSValue? {
                if let obj = self.objectForKeyedSubscript(NSString(string: n)) {
                        return obj.isUndefined ? nil : obj
                } else {
                        return nil
                }
        }

        public func evaluateScript(script scr: String, sourceFile srcfile: URL?) -> JSValue {
                if let url = srcfile {
                        return self.evaluateScript(scr, withSourceURL: url)
                } else {
                        return self.evaluateScript(scr)
                }
        }
}

