"use strict";
/**
 * @file ThreadFunc.ts
 */
/// <reference path="types/Thread.d.ts"/>
function allocateThread(inf, outf, errf) {
    let thd = newThread();
    thd.standardInput = inf;
    thd.standardOutput = outf;
    thd.standardError = errf;
    return thd;
}
function startThread(thd, script) {
    thd.script = script;
    thd.start();
}
function waitThread(thd) {
    while (thd.isRunning) {
    }
    return thd.exitCode;
}
