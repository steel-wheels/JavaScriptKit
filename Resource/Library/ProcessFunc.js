"use strict";
/**
 * ProcessFunc.ts
 */
/// <reference path="types/Process.d.ts"/>
function allocateProcess(inf, outf, errf) {
    let proc = newProcess();
    proc.standardInput = inf;
    proc.standardOutput = outf;
    proc.standardError = errf;
    return proc;
}
function startProcess(proc, exec, args) {
    proc.executableURL = exec;
    proc.arguments = args;
    return proc.start();
}
function waitProcess(proc) {
    while (proc.isRunning) {
    }
    return proc.exitCode;
}
