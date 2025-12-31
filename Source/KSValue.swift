/**
 * @file        KSValue.swift
 * @brief      Extend MIValue class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import JavaScriptCore
import Foundation

public extension MIValue
{
        func toNativeValue(context ctxt: KSContext) -> JSValue? {
                var result: JSValue? = nil
                switch self.value {
                case .nilValue:
                        result = JSValue(nullIn: ctxt)
                case .booleanValue(let val):
                        result = JSValue(int32: val ? 1 : 0, in: ctxt)
                case .signedIntValue(let val):
                        result = JSValue(int32: Int32(val), in: ctxt)
                case .unsignedIntValue(let val):
                        result = JSValue(int32: Int32(val), in: ctxt)
                case .floatValue(let val):
                        result = JSValue(double: val, in: ctxt)
                case .stringValue(let val):
                        result = JSValue(object: NSString(utf8String: val), in: ctxt)
                case .arrayValue(_), .dictionaryValue(_):
                        result = JSValue(object: self.toObject(), in: ctxt)
                @unknown default:
                        NSLog("[Error] Unknown value type at \(#file)")
                        result = JSValue(nullIn: ctxt)
                }
                return result
        }

        static func fromScriptValue(value src: JSValue) -> MIValue {
                if let obj = src.toObject() as? NSObject {
                        return MIValue.fromObject(object: obj)
                } else {
                        NSLog("[Error] Unexpected object at \(#file)")
                        return MIValue()
                }
        }
}
