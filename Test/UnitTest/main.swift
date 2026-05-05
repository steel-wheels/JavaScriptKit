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
        var result = true

        let env = MIEnvVariables(parent: nil)

        /* setup context */
        guard let vm = JSVirtualMachine() else {
                NSLog("[Error] Failed to allocate VM")
                return false
        }

        let prochdl = MIProcessFileHandle(input:  FileHandle.standardInput,
                                          output: FileHandle.standardOutput,
                                          error:  FileHandle.standardError)

        let lib  = KSLibrary()
        let ctxt: KSContext
        switch lib.load(virtualMachine: vm, processFileHandle: prochdl, environment: env) {
        case .success(let _ctxt):
                ctxt = _ctxt
        case .failure(let err):
                NSLog("[Error] \(MIError.errorToString(error: err))")
                return false
        }

        result = envTest(environment: env, context: ctxt) && result

        let scr0 = "_log(\"hello, world !!\");"
        ctxt.evaluateScript(scr0)

        let scr1 = "env.setString(\"a\", \"ABCDE\") ;\n"
                 + "_log(env.getString(\"a\")) ;\n"
        ctxt.evaluateScript(scr1)

        let scr2 = "let url0 = newURL(\"/bin/ls\") ;\n"
                 + "_log(url0.path) ;"
        ctxt.evaluateScript(scr2)

        let defin  = KSLibrary.BuiltinName.defaultInputFileHandle.rawValue
        let defout = KSLibrary.BuiltinName.defaultOutputFileHandle.rawValue
        let deferr = KSLibrary.BuiltinName.defaultErrorFileHandle.rawValue

        let scr3 = "\(defout).write(\"write to default output\\n\");\n"
        ctxt.evaluateScript(scr3)

        let scr4 = "let p0 = newProcess(); \n"
                 + "p0.executableURL = newURL(\"/bin/ls\") ; \n"
                 + "p0.standardInput = \(defin) ;\n"
                 + "p0.standardOutput = \(defout) ;\n"
                 + "p0.standardError = \(deferr) ;\n"
                 + "p0.arguments = [] ;\n"
                 + "let ecode = p0.run() ;\n"
                 + "\(defout).write(\"ecode: \" + ecode);\n"
                 + "p0.wait() ;\n"
        NSLog("scr4 = \(scr4)")
        ctxt.evaluateScript(scr4)

        NSLog("done")
        return true
}

private func envTest(environment env: MIEnvVariables, context ctxt: KSContext) -> Bool
{
        NSLog("test: environment")

        let envobj = KSEnvVariables(environment: env, context: ctxt)

        let key0str = "KEY0"
        guard let key0val = JSValue(object: key0str, in: ctxt) else {
                NSLog("[Error] Failed to allocate key0")
                return false
        }

        let str0str = "STR0"
        guard let str0val = JSValue(object: str0str, in: ctxt) else {
                NSLog("[Error] Failed to allocate str0")
                return false
        }

        envobj.setString(key0val, str0val)
        let dst0val = envobj.getString(key0val)
        if let dst0str = dst0val.toString() {
                if str0str != dst0str {
                        NSLog("[Error] Unexpected string value \(str0str) != \(dst0str)")
                        return false
                }
        } else {
                NSLog("[Error] Failed to get string")
                return false
        }

        return true
}

if test() {
        NSLog("Summary: Passed")
} else {
        NSLog("Summary: Failed")
}

