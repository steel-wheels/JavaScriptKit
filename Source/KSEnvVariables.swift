/**
 * @file        KSEnvironment.swift
 * @brief      Define KSEnvironment class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

@objc public protocol KSEnvVariablesProtocol: JSExport
{
        func setString(_ name: JSValue, _ value: JSValue)
        func getString(_ name: JSValue) -> JSValue
}

@objc public class KSEnvVariables: NSObject, KSEnvVariablesProtocol
{
        private var mEnvVariables:      MIEnvVariables
        private var mContext:           KSContext

        static func from(value val: JSValue) -> KSEnvVariables? {
                return val.toObject() as? KSEnvVariables
        }

        public init(environment env: MIEnvVariables, context ctxt: KSContext){
                mEnvVariables   = env
                mContext        = ctxt
        }

        public func setString(_ keyval: JSValue, _ strval: JSValue) {
                if let key = keyval.toString(), let str = strval.toString() {
                        mEnvVariables.set(object: str as NSString, forKey: key)
                } else {
                        NSLog("[Error] Failed to set value at \(#file)")
                }
        }

        public func getString(_ keyval: JSValue) -> JSValue {
                if let key = keyval.toString() {
                        if let str = mEnvVariables.object(forKey: key) as? NSString {
                                return JSValue(object: str, in: mContext)
                        }
                } else {
                        NSLog("[Error] Failed to get value at \(#file)")
                }
                return JSValue(nullIn: mContext)
        }
}
