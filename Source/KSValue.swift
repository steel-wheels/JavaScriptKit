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
        func toScriptValue(context ctxt: KSContext) -> JSValue? {
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

@objc public protocol KSValueProtocol: JSExport
{
        var type: JSValue { get }

        func setNullValue()

        var booleanValue:       JSValue { get set }
        var numberValue:        JSValue { get set }
        var stringValue:        JSValue { get set }
        var arrayValue:         JSValue { get set }
        var dictionaryValue:    JSValue { get set }
}

@objc public class KSValue: NSObject, KSValueProtocol
{
        private var mValue:     MIValue
        private var mContext:   KSContext

        static public func allocate(context ctxt: KSContext) -> JSValue{
                let obj  = KSValue(context: ctxt)
                return JSValue(object: obj, in: ctxt)
        }

        public init(context ctxt: KSContext){
                mValue          = MIValue()
                mContext        = ctxt
        }

        public var type: JSValue { get {
                let result: MIValueType
                switch mValue.type {
                case .signedIntType, .unsignedIntType:
                        result = .floatType
                default:
                        result = mValue.type
                }
                return JSValue(int32: Int32(result.rawValue), in: mContext)
        }}

        public func setNullValue() {
                mValue = MIValue()
        }

        public var booleanValue: JSValue {
                get {           return getValue()       }
                set(val){       setValue(val)           }
        }

        public var numberValue: JSValue {
                get {           return getValue()       }
                set(val){       setValue(val)           }
        }

        public var stringValue: JSValue {
                get {           return getValue()       }
                set(val){       setValue(val)           }
        }

        public var arrayValue:  JSValue {
                get {           return getValue()       }
                set(val){       setValue(val)           }
        }

        public var dictionaryValue:  JSValue {
                get {           return getValue()       }
                set(val){       setValue(val)           }
        }

        private func getValue() -> JSValue {
                return KSConverter.nativeValueToValue(mValue, in: mContext)
        }

        private func setValue(_ src: JSValue) {
                switch KSConverter.valueToNativeValue(src) {
                case .success(let nval):
                        mValue = nval
                case .failure(let err):
                        let msg = MIError.errorToString(error: err)
                        NSLog("[Error] \(msg)")
                }
        }

        private func error(_ err: NSError) {
                let msg = MIError.errorToString(error: err)
                NSLog("[Error] \(msg)")
        }
}

/*

 /**
  * Value.d.ts
  */

 /// <reference path="types/URL.d.ts"/>

 /* The raw value for value must be compatible with MIValue.swift */
 declare enum ValueType
 {
         nilType                 = 0,
         booleanType             = 1,
         //signedIntType           = 2,
         //unsignedIntType         = 3,
         //floatType               = 4,
         numberType              = 4,
         stringType              = 5,
         arrayType               = 6,
         dictionaryType          = 7
 }

 declare interface ValueDictionary {
   [key: string]: Value;
 }

 declare class Value
 {
         get type(): ValueType ;

         setNullValue(): void ;

         set booleanValue(val: boolean) ;
         get booleanValue(): boolean ;

         set numberValue(val: number) ;
         get numberValue(): number ;

         set stringValue(val: string) ;
         get stringValue(): string ;

         set arrayValue(val: Value[]) ;
         get arrayValue(): Value[] ;

         set dictionaryValue(val: ValueDictionary) ;
         get dictionaryValue(): ValueDictionary ;
 }

 /* initial value: null */
 declare function newValue(): Value ;


 */
