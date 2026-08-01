/**
 * ProcessFunc.ts
 */
declare function allocateProcess(inf: FileHandle, outf: FileHandle, errf: FileHandle): Process;
declare function startProcess(proc: Process, exec: URL, args: string[]): number;
declare function waitProcess(proc: Process): number;
