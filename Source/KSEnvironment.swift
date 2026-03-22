/**
 * @file        KSEnvironment.swift
 * @brief      Define KSEnvironment class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

public class KSEnvironment: NSObject, JSExport
{
        private var mContext:     KSContext
        private var mEnvironment: MIEnvironment

        public init(context ctxt: KSContext, core cenv: MIEnvironment){
                mContext     = ctxt
                mEnvironment = cenv
        }

        public func set(_ name: JSValue, _ value: JSValue) {
                if let str = name.toString(), let obj = value.toObject() as? NSObject {
                        mEnvironment.set(name: str, object: obj)
                } else {
                        NSLog("[Error] Invalid parameter ar \(#file)")
                }
        }

        public func get(_ name: JSValue) -> JSValue {
                guard let str = name.toString() else {
                        NSLog("[Error] Invalid parameter ar \(#file)")
                        return JSValue(nullIn: mContext)
                }
                if let obj = mEnvironment.get(name: str) {
                        return JSValue(object: obj, in:  mContext)
                } else {
                        return JSValue(nullIn: mContext)
                }
        }
}

