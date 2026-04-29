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
        let env = MIEnvVariables(parent: nil)

        /* setup context */
        guard let vm = JSVirtualMachine() else {
                NSLog("[Error] Failed to allocate VM")
                return false
        }

        let lib  = KSLibrary()

        let ctxt: KSContext
        switch lib.load(virtualMachine: vm, environment: env) {
        case .success(let _ctxt):
                ctxt = _ctxt
        case .failure(let err):
                NSLog("[Error] \(MIError.errorToString(error: err))")
                return false
        }

        let scr0 = "_log(\"hello, world !!\");"
        ctxt.evaluateScript(scr0)

        let scr1 = "env.setString(\"a\", \"ABCDE\") ;\n"
                 + "_log(env.getString(\"a\")) ;\n"
        ctxt.evaluateScript(scr1)

        return true
}

if test() {
        NSLog("Summary: Passed")
} else {
        NSLog("Summary: Failed")
}

