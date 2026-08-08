/**
 * @file ThreadFunc.ts
 */
declare function allocateThread(inf: FileHandle, outf: FileHandle, errf: FileHandle): Thread;
declare function startThreadWithScript(thd: Thread, args: string[], script: string): void;
declare function startThreadWithFile(thd: Thread, args: string[], url: URL): void;
declare function waitThread(thd: Thread): number;
