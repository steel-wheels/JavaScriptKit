/*
 * @file UTValue.swift
 * @description Unit test for KSValue class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import JavaScriptKit
import Foundation

public func testValue() -> Bool
{
        var values: Array<KSValue> = []
        let val0 = KSValue.booleanValue(true) ; values.append(val0)
        let val1 = KSValue.uintValue(1234) ;    values.append(val1)
        let val2 = KSValue.intValue(-2345) ;    values.append(val2)
        
        for i in  0..<values.count {
                print("val\(i) = " + values[i].toString())
        }
        
        return true
}

