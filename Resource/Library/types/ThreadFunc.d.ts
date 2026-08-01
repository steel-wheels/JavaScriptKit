/**
 * @file ThreadFunc.ts
 */
declare function allocateThread(inf: FileHandle, outf: FileHandle, errf: FileHandle): Thread;
declare function startThread(thd: Thread, script: string): void;
declare function waitThread(thd: Thread): number;
