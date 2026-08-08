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
        var allKeys: JSValue { get }

        func set(_ name: JSValue, _ value: JSValue)
        func get(_ name: JSValue) -> JSValue
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

        public var allKeys: JSValue { get {
                return JSValue(object: mEnvVariables.allKeys, in: mContext)
        }}

        public func set(_ name: JSValue, _ value: JSValue) {
                if let nm = name.toString(), let str = value.toString() {
                        mEnvVariables.set(value: str, for: nm)
                } else {
                        NSLog("[Error] Failed to set string vkey and alue")
                }
        }

        public func get(_ name: JSValue) -> JSValue {
                if let nm = name.toString() {
                        if let val = mEnvVariables.value(for: nm) {
                                return JSValue(object: val, in: mContext)
                        }
                } else {
                        NSLog("[Error] Failed to set string key")
                }
                return JSValue(nullIn: mContext)
        }
}
