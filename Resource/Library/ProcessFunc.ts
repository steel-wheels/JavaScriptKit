/**
 * ProcessFunc.ts
 */

/// <reference path="types/Process.d.ts"/>

function allocateProcess(inf: FileHandle, outf: FileHandle,
			  errf: FileHandle): Process
{
	let proc = newProcess() ;
	proc.standardInput	= inf ;
	proc.standardOutput	= outf ;
	proc.standardError	= errf ;
	return proc ;
}

function startProcess(proc: Process, exec: URL, args: string[]): number
{
	proc.executableURL	= exec ;
	proc.arguments		= args ;
	return proc.start() ;
}

function waitProcess(proc: Process): number
{
	while(proc.isRunning){
	}
	return proc.exitCode ;
}

