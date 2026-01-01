/**
 * @file        main.swift
 * @brief      Unit test
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import JavaScriptKit
import MultiDataKit
import JavaScriptCore
import Cocoa

func test() -> Bool
{
        /* setup context */
        let ctxt = KSContext(virtualMachine: JSVirtualMachine())
        if let err = KSLibrary.load(into: ctxt) {
                NSLog("[Error] \(MIError.errorToString(error: err))")
                return false
        }

        let scr0 = "_log(\"hello, world\");"
        ctxt.evaluateScript(scr0)

        let scr1 = "console.log(\"good morning\");"
        ctxt.evaluateScript(scr1)

        return true
}

test()

