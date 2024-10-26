/*
 * @file UTValue.swift
 * @description Unit test for KSValue class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import JavaScriptKit
import Foundation

public func printValue(name nm: String, value val: KSValue){
        print(nm + " : " + val.toString(withType: true))
}

public func testValue() -> Bool
{
        var values0: Array<KSValue> = []
        let val0 = KSValue.booleanValue(true) ;
        let val1 = KSValue.uintValue(1234) ;    values0.append(val1)
        let val2 = KSValue.intValue(-2345) ;    values0.append(val2)
        let val3 = KSValue.floatValue(-12.34) ; values0.append(val3)
        
        printValue(name: "val0", value: val0)
        for i in  0..<values0.count {
                printValue(name: "val\(i)", value: values0[i])
        }
        
        printValue(name: "cast: double -> int    ", value: val3.cast(to: .int)   ?? .booleanValue(false))
        printValue(name: "cast: int    -> double ", value: val1.cast(to: .float) ?? .booleanValue(false))

        print("adjust types")
        switch KSValue.adjustValueTypes(values: values0) {
        case .success(let (utype, uvalues)):
                for i in  0..<uvalues.count {
                        printValue(name: "val\(i)", value: uvalues[i])
                }
        case .failure(let err):
                print("[Error] " + KSError.errorToString(error: err))
        }
        
        return true
}

