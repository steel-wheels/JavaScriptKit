/*
 * @file KSValue.swift
 * @description Define KSValue data structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public indirect enum KSValueType {
        case boolean
        case uint
        case int
        case float
        case string
        case array(KSValueType)
        case dictionary(KSValueType) // key is string
        case interface(String?, Dictionary<String, KSValueType>)
        
        public var elementType: KSValueType? { get {
                switch self {
                case .array(let elmtype):       return elmtype
                case .dictionary(let elmtype):  return elmtype
                default:                        return nil
                }
        }}
        
        public static func isSame(type0 t0: KSValueType, type1 t1: KSValueType) -> Bool {
                var result: Bool = false
                switch t0 {
                case boolean:
                        switch t1 {
                        case boolean:   result = true
                        default:        break
                        }
                case uint:
                        switch t1 {
                        case uint:      result = true
                        default:        break
                        }
                case int:
                        switch t1 {
                        case int:       result = true
                        default:        break
                        }
                case float:
                        switch t1 {
                        case float:     result = true
                        default:        break
                        }
                case string:
                        switch t1 {
                        case string:    result = true
                        default:        break
                        }
                case .array(let e0):
                        switch t1 {
                        case .array(let e1):    result = KSValueType.isSame(type0: e0, type1: e1)
                        default:                break
                        }
                case .dictionary(let e0):
                        switch t1 {
                        case .dictionary(let e1):    result = KSValueType.isSame(type0: e0, type1: e1)
                        default:                break
                        }
                case .interface(let t0, let e0):
                        switch t1 {
                        case .interface(let t1, let e1):
                                let t0m = t0 ?? "" ; let t1m = t1 ?? ""
                                if t0m == t1m {
                                        result = isSame(types0: e0, types1: e1)
                                }
                        default:                break
                        }
                }
                return result
        }
        
        private static func isSame(types0 t0: Array<KSValueType>, types1 t1: Array<KSValueType>) -> Bool {
                var result = false
                let num0 = t0.count ; let num1 = t1.count
                if num0 == num1 {
                        result = true
                        for i in 0..<num0 {
                                if !isSame(type0: t0[i], type1: t1[i]) {
                                        result = false
                                        break
                                }
                        }
                }
                return result
        }
        
        private static func isSame(types0 t0: Dictionary<String, KSValueType>, types1 t1: Dictionary<String, KSValueType>) -> Bool {
                guard t0.count == t1.count else {
                        return false
                }
                for (key0, type0) in t0 {
                        if let type1 = t1[key0] {
                                if !isSame(type0: type0, type1: type1) {
                                    return false
                                }
                        } else {
                                return false
                        }
                }
                return true
        }
        
        public static func union(type0 t0: KSValueType, type1 t1: KSValueType) -> KSValueType? {
                if isSame(type0: t0, type1: t1) {
                        return t0
                }
                var result: KSValueType? = nil
                switch t0 {
                case .uint:
                        switch t1 {
                        case .uint:     result = .uint
                        case .int:      result = .int
                        case .float:    result = .float
                        default:
                                break
                        }
                case .int:
                        switch t1 {
                        case .uint:     result = .int
                        case .int:      result = .int
                        case .float:    result = .float
                        default:
                                break
                        }
                case .float:
                        switch t1 {
                        case .uint:     result = .float
                        case .int:      result = .float
                        case .float:    result = .float
                        default:
                                break
                        }
                default:
                        break
                }
                return result
        }
}

public indirect enum KSValueBody {
        case boolean(Bool)
        case uint(UInt)
        case int(Int)
        case float(Double)
        case string(String)
        case array(Array<KSValue>)
        case dictionary(Dictionary<String, KSValue>) // key is string
        case interface(Dictionary<String, KSValue>)
}

public struct KSValue {
        public var      type:  KSValueType
        public var      value: KSValueBody
        
        public init(type: KSValueType, value: KSValueBody) {
                self.type = type
                self.value = value
        }
        
        public func cast(to dsttype: KSValueType) -> KSValue? {
                let result: KSValue?
                switch self.value {
                case .boolean(let value):
                        switch dsttype {
                        case .boolean:  result = self
                        case .uint:     result = KSValue.uintValue(value ? 1 : 0)
                        case .int:      result = KSValue.intValue(value ? 1 : 0)
                        default:        result = nil
                        }
                case .uint(let value):
                        switch dsttype {
                        case .boolean:  result = KSValue.booleanValue(value != 0)
                        case .uint:     result = self
                        case .int:      result = KSValue.intValue(Int(value))
                        case .float:    result = KSValue.floatValue(Double(value))
                        default:        result = nil
                        }
                case .int(let value):
                        switch dsttype {
                        case .boolean:  result = KSValue.booleanValue(value != 0)
                        case .uint:     result = KSValue.uintValue(UInt(value))
                        case .int:      result = self
                        case .float:    result = KSValue.floatValue(Double(value))
                        default:        result = nil
                        }
                case .float(let value):
                        switch dsttype {
                        case .boolean:  result = KSValue.booleanValue(value != 0.0)
                        case .uint:     result = KSValue.uintValue(UInt(value))
                        case .int:      result = KSValue.intValue(Int(value))
                        case .float:    result = self
                        default:        result = nil
                        }
                case .string(_):
                        switch dsttype {
                        case .string:   result = self
                        default:        result = nil
                        }
                case .array(let values):
                        if let srcelm = self.type.elementType {
                                switch dsttype {
                                case .array(let dstelm):
                                        if KSValueType.isSame(type0: srcelm, type1: dstelm) {
                                                result = self
                                        } else {
                                                var dstvals: Array<KSValue> = []
                                                for srcval in values {
                                                        if let dstval = srcval.cast(to: dstelm) {
                                                                dstvals.append(dstval)
                                                        } else {
                                                                NSLog("[Error] Failed to cast")
                                                        }
                                                }
                                                result = KSValue.arrayValue(elementType: dstelm, values: dstvals)
                                        }
                                default: result = nil
                                }
                        } else {
                                NSLog("[Error] Failed to get element type")
                                result = nil
                        }
                case .dictionary(let values):
                        if let srcelm = self.type.elementType {
                                switch dsttype {
                                case .dictionary(let dstelm):
                                        if KSValueType.isSame(type0: srcelm, type1: dstelm) {
                                                result = self
                                        } else {
                                                var dstvals: Dictionary<String, KSValue> = [:]
                                                for (srckey, srcval) in values {
                                                        if let dstval = srcval.cast(to: dstelm) {
                                                                dstvals[srckey] = dstval
                                                        } else {
                                                                NSLog("[Error] Failed to cast")
                                                        }
                                                }
                                                result = KSValue.dictionaryValue(elementType: dstelm, values: dstvals)
                                        }
                                default: result = nil
                                }
                        } else {
                                NSLog("[Error] Failed to get element type")
                                result = nil
                        }
                case .interface(_):
                        if KSValueType.isSame(type0: self.type, type1: dsttype) {
                                result = self
                        } else {
                                NSLog("[Error] Can not cast interface value")
                                result = nil
                        }
                }
                return result
        }
        
        public func toString() -> String {
                let result: String
                switch self.value {
                case .boolean(let value):       result = "\(value)"
                case .uint(let value):          result = "\(value)"
                case .int(let value):           result = "\(value)"
                case .float(let value):         result = "\(value)"
                case .string(let value):        result = value
                case .array(let values):
                        var is1st = true
                        var str   = "["
                        for value in values {
                                if is1st {
                                        is1st = false
                                } else {
                                        str += ", "
                                }
                                str += value.toString()
                        }
                        str += "]"
                        result = str
                case .dictionary(let values):
                        result = KSValue.toString(ductionary: values)
                case .interface(let values):
                        result = KSValue.toString(ductionary: values)
                }
                return result
        }
        
        private static func toString(ductionary dict: Dictionary<String, KSValue>) -> String {
                var is1st = true
                var str   = "{"
                let keys =  dict.keys.sorted()
                for key in keys {
                        if is1st {
                                is1st = false
                        } else {
                                str += ", "
                        }
                        str += key + ":"
                        if let val = dict[key] {
                                str += val.toString()
                        } else {
                                str += "?"
                        }
                }
                return str
        }
        
        public static func adjustValueTypes(values: Array<KSValue>) -> Result<(KSValueType, Array<KSValue>), NSError> {
                guard values.count > 0 else {
                        return .success((.boolean, [])) // empty array
                }
                
                /* get unioned type */
                var utype: KSValueType = values[0].type
                for i in 1..<values.count {
                        if let type = KSValueType.union(type0: utype, type1: values[i].type) {
                                utype = type
                        } else {
                                let err = KSError.parseError(message: "Failed to get unioned type", line: 0)
                                return .failure(err)
                        }
                }
                
                /* get unioned value */
                var uvalues: Array<KSValue> = []
                for i in 0..<values.count {
                        if let val = values[i].cast(to: utype) {
                                uvalues.append(val)
                        } else {
                                let err = KSError.parseError(message: "Failed to cast to unioned data", line: 0)
                                return .failure(err)
                        }
                }

                return .success((utype, uvalues))
        }
        
        public static func booleanValue(_ value: Bool) -> KSValue {
                return KSValue(type: .boolean, value: .boolean(value))
        }
        
        public static func uintValue(_ value: UInt) -> KSValue {
                return KSValue(type: .uint, value: .uint(value))
        }
        
        public static func intValue(_ value: Int) -> KSValue {
                return KSValue(type: .int, value: .int(value))
        }
        
        public static func floatValue(_ value: Double) -> KSValue {
                return KSValue(type: .float, value: .float(value))
        }
        
        public static func stringValue(_ value: String) -> KSValue {
                return KSValue(type: .string, value: .string(value))
        }
        
        public static func arrayValue(elementType: KSValueType, values: Array<KSValue>) -> KSValue {
                return KSValue(type: .array(elementType), value: .array(values))
        }
        
        public static func dictionaryValue(elementType: KSValueType, values: Dictionary<String, KSValue>) -> KSValue {
                return KSValue(type: .dictionary(elementType), value: .dictionary(values))
        }
        
        public static func interfaceValue(name: String?, values: Dictionary<String, KSValue>) -> KSValue {
                var valtypes: Dictionary<String, KSValueType> = [:]
                for (ident, value) in values {
                        valtypes[ident] = value.type
                }
                let iftype: KSValueType = .interface(name, valtypes)
                return KSValue(type: iftype, value: .interface(values))
        }
}
