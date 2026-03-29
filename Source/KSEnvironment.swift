/**
 * @file        KSEnvironment.swift
 * @brief      Define KSEnvironment class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

@objc public protocol KSEnvironmentProtocol: JSExport
{
        func set(_ name: JSValue, _ value: JSValue)
        func get(_ name: JSValue) -> JSValue
}

@objc public class KSEnvironment: NSObject, KSEnvironmentProtocol
{
        private var mEnvironment:       MIEnvironment
        private var mContext:           KSContext

        static func from(value val: JSValue) -> KSEnvironment? {
                return val.toObject() as? KSEnvironment
        }

        public init(environment env: MIEnvironment, context ctxt: KSContext){
                mEnvironment    = env
                mContext        = ctxt
        }

        public func set(_ nameval: JSValue, _ strval: JSValue) {
                if let name = nameval.toString(), let str = strval.toString() {
                        return mEnvironment.set(name: name, value: str as NSString)
                } else {
                        NSLog("[Error] Failed to set value at \(#file)")
                }
        }

        public func get(_ nameval: JSValue) -> JSValue {
                if let name = nameval.toString() {
                        if let str = mEnvironment.get(name: name) {
                                return JSValue(object: str, in: mContext)
                        }
                } else {
                        NSLog("[Error] Failed to get value at \(#file)")
                }
                return JSValue(nullIn: mContext)
        }
}

