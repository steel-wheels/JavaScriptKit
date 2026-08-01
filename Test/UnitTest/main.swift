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

        /* load library */
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

        let result0 = envTest(environment: env, context: ctxt)
        let result1 = statementTest(environment: env, context: ctxt)
        let result2 = processTest(environment: env, context: ctxt)
        let result3 = threadTest(environment: env, context: ctxt)

        let result  = result0 && result1 && result2 && result3

        NSLog("done")
        return result
}

private func statementTest(environment env: MIEnvVariables, context ctxt: KSContext) -> Bool
{
        NSLog("test: statement")

        let scr0 = "_log(\"hello, world !!\");"
        ctxt.evaluateScript(scr0)

        let scr1 = "env.setString(\"a\", \"ABCDE\") ;\n"
                 + "_log(env.getString(\"a\")) ;\n"
        ctxt.evaluateScript(scr1)

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

private func processTest(environment env: MIEnvVariables, context ctxt: KSContext) -> Bool
{
        let defin  = KSLibrary.BuiltinName.defaultInputFileHandle.rawValue
        let defout = KSLibrary.BuiltinName.defaultOutputFileHandle.rawValue
        let deferr = KSLibrary.BuiltinName.defaultErrorFileHandle.rawValue

        NSLog("test: process")

        let lines: Array<String> = [
                "let proc = allocateProcess(\(defin), \(defout), \(deferr)) ;\n",
                "let exec = newURL(\"/bin/ls\") ;\n",
                "let pid  = startProcess(proc, exec, []) ;\n",
                "waitProcess(proc) ;\n"
        ]
        let script = lines.joined(separator: "\n")

        ctxt.evaluateScript(script)

        return true
}

private func threadTest(environment env: MIEnvVariables, context ctxt: KSContext) -> Bool
{
        let defin  = KSLibrary.BuiltinName.defaultInputFileHandle.rawValue
        let defout = KSLibrary.BuiltinName.defaultOutputFileHandle.rawValue
        let deferr = KSLibrary.BuiltinName.defaultErrorFileHandle.rawValue

        NSLog("test: thread")

        let lines: Array<String> = [
                "let thd    = allocateThread(\(defin), \(defout), \(deferr)) ;\n",
                "let script = \"_log(\\\"Message from thread\\\")\" ;\n",
                "startThread(thd, script) ;\n",
                "waitThread(thd) ;\n"
        ]
        let script = lines.joined(separator: "\n")

        ctxt.evaluateScript(script)

        return true
}

if test() {
        NSLog("Summary: Passed")
} else {
        NSLog("Summary: Failed")
}

