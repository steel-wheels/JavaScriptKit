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
function startThreadWithScript(thd, args, script) {
    thd.script = script;
    thd.arguments = args;
    thd.start();
}
function startThreadWithFile(thd, args, url) {
    thd.executableURL = url;
    thd.arguments = args;
    thd.start();
}
function waitThread(thd) {
    while (thd.isRunning) {
    }
    return thd.exitCode;
}
