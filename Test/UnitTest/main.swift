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
        let env = MIEnvironment()

        /* setup context */
        let ctxt = KSContext(virtualMachine: JSVirtualMachine())
        let lib  = KSLibrary()
        if let err = lib.load(into: ctxt, environment: env) {
                NSLog("[Error] \(MIError.errorToString(error: err))")
                return false
        }

        let scr0 = "_log(\"hello, world !!\");"
        ctxt.evaluateScript(scr0)

        let scr1 = "env.set(\"a\", 1234) ;\n"
                 + "_log(env.get(\"a\")) ;\n"
        ctxt.evaluateScript(scr1)

        return true
}

if test() {
        NSLog("Summary: Passed")
} else {
        NSLog("Summary: Failed")
}

